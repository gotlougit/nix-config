#!/usr/bin/env python3
"""Relay org.bluez between the host system bus and the Bluetooth VM.

The relay owns "org.bluez" on the host system bus. Method calls targeting it
are forwarded to the bluetooth daemon running inside the VM (reached through
the bridged D-Bus socket). Signals from the VM are re-emitted on the host bus
so desktop clients (Plasma bluetooth, KDE Connect, bluetoothctl, ...) keep
working as if bluez were running locally.

Because every host client shares the relay's single VM-side connection,
bluetoothd sees the relay as the sender of every call, so it routes its
callbacks (agents, A2DP endpoints, GATT applications, profiles, ...) back to
the relay. The relay tracks which host client registered which object path
(RegisterAgent/RegisterEndpoint/RegisterApplication/RegisterProfile) and
forwards those callbacks to the right client by object path. Replies are
routed back over the pending-call table.

Limitations: file descriptor passing over the *D-Bus* bridge is not
forwarded (fds cannot cross vsock), so A2DP/HFP audio transports are
bridged differently: the relay intercepts MediaTransport1.Acquire, returns a
host-side socketpair fd to the client, and pumps the VM's real transport
socket to it over a dedicated vsock channel (see fdproxy-vm.py in the VM).
Authorisation policies (polkit) are evaluated inside the VM; and because
clients share one VM-side connection, bluetoothd keeps discovery sessions
alive even after a host client exits (the relay stops any leftover discovery
when it (re)connects).
"""
import asyncio
import logging
import os
import socket

from dbus_next import Message, MessageType, BusType
from dbus_next.aio import MessageBus

logging.basicConfig(level=logging.INFO, format="%(name)s: %(message)s")
log = logging.getLogger("bluez-relay")

HOST_NAME = "org.bluez"
HOST_BUS_ADDRESS = os.environ.get("BLUEZ_HOST_BUS")
VM_BUS_ADDRESS = os.environ.get("BLUEZ_VM_BUS", "unix:path=/run/bluetooth-vm/system_bus_socket")
CALL_TIMEOUT = 30.0
FD_PROXY_NAME = "org.btfdproxy"
FD_PROXY_PATH = "/org/btfdproxy"
FD_PROXY_PORT = 51821  # vsock data channel; must match fdproxy-vm.py
FD_BUF = 1 << 16

# Methods through which a host client asks bluez to call back into an object
# it exports: (interface, member) -> index of the object-path argument.
REGISTRATIONS = {
    ("org.bluez.AgentManager1", "RegisterAgent"): 0,
    ("org.bluez.AgentManager1", "UnregisterAgent"): 0,
    ("org.bluez.Media1", "RegisterEndpoint"): 0,
    ("org.bluez.Media1", "UnregisterEndpoint"): 0,
    ("org.bluez.Media1", "RegisterApplication"): 0,
    ("org.bluez.Media1", "UnregisterApplication"): 0,
    ("org.bluez.GattManager1", "RegisterApplication"): 0,
    ("org.bluez.GattManager1", "UnregisterApplication"): 0,
    ("org.bluez.ProfileManager1", "RegisterProfile"): 0,
    ("org.bluez.ProfileManager1", "UnregisterProfile"): 0,
}


class Relay:
    def __init__(self):
        self.host = None
        self.vm = None
        # callbacks forwarded vm -> host: host serial -> (vm serial, vm sender)
        self.pending = {}
        # object path prefix (as registered by a host client) -> host unique name
        self.callback_owners = {}
        # transport path -> host-side socketpair endpoint waiting for a vsock
        # connection from the VM proxy (fdproxy-vm.py)
        self.acquire_pending = {}

    # ---------------------------------------------------------------- setup
    async def start(self):
        if HOST_BUS_ADDRESS:
            self.host = MessageBus(bus_address=HOST_BUS_ADDRESS, negotiate_unix_fd=True)
        else:
            self.host = MessageBus(bus_type=BusType.SYSTEM, negotiate_unix_fd=True)
        await self.host.connect()
        self.host.add_message_handler(self.on_host_message)
        asyncio.get_running_loop().create_task(self._vsock_listener())

        # Claim org.bluez on the host bus only while the VM's bluetoothd is
        # actually reachable. Clients (WirePlumber, Plasma, ...) enumerate the
        # adapter when the name appears, so releasing it while the VM is down
        # (or booting) makes them re-enumerate cleanly instead of caching a
        # failed GetManagedObjects forever.
        while True:
            try:
                self.vm = MessageBus(bus_address=VM_BUS_ADDRESS)
                await self.vm.connect()
                # dbus-next only subscribes to NameOwnerChanged; we need every
                # signal from the daemon (PropertiesChanged, InterfacesAdded, ...)
                await self.vm.call(
                    Message(
                        destination="org.freedesktop.DBus",
                        path="/org/freedesktop/DBus",
                        interface="org.freedesktop.DBus",
                        member="AddMatch",
                        signature="s",
                        body=["type='signal'"],
                    )
                )
                await self._wait_for_bluez()
                reply = await self.host.request_name(HOST_NAME)
                log.info("host bus: requested %s -> %s", HOST_NAME, reply)
                await self.clear_stale_discovery()
                self.vm.add_message_handler(self.on_vm_message)
                await self.vm.wait_for_disconnect()
            except Exception as e:
                log.warning("vm bus connection failed (%s); retrying in 2s", e)
                await asyncio.sleep(2)
            finally:
                # drop the name so host clients re-enumerate when we come back
                try:
                    await self.host.release_name(HOST_NAME)
                except Exception:
                    pass

    async def _wait_for_bluez(self, timeout=120):
        loop = asyncio.get_running_loop()
        deadline = loop.time() + timeout
        while True:
            try:
                r = await self.vm.call(
                    Message(
                        destination="org.freedesktop.DBus",
                        path="/org/freedesktop/DBus",
                        interface="org.freedesktop.DBus",
                        member="ListNames",
                    )
                )
                if r.message_type is MessageType.METHOD_RETURN and "org.bluez" in r.body[0]:
                    return
            except Exception:
                pass
            if loop.time() > deadline:
                raise TimeoutError("bluetoothd did not appear on the VM bus")
            await asyncio.sleep(1)

    # All host clients share this single VM-side connection, so bluetoothd
    # cannot tell when a host client exits: if one dies mid-scan (or a
    # previous relay incarnation was killed) its discovery session leaks and
    # every later StartDiscovery fails with InProgress. On (re)connect, stop
    # any discovery left running so the bus starts clean.
    async def clear_stale_discovery(self):
        try:
            reply = await self.vm.call(
                Message(
                    destination="org.bluez",
                    path="/",
                    interface="org.freedesktop.DBus.ObjectManager",
                    member="GetManagedObjects",
                )
            )
            if reply.message_type is MessageType.ERROR:
                return
            for path in reply.body[0]:
                if path.startswith("/org/bluez/hci"):
                    await self.vm.call(
                        Message(
                            destination="org.bluez",
                            path=path,
                            interface="org.bluez.Adapter1",
                            member="StopDiscovery",
                        )
                    )
        except Exception as e:
            log.info("stale discovery cleanup skipped: %s", e)

    # ------------------------------------------------ fd proxy (A2DP/HFP audio)
    async def _vsock_listener(self):
        loop = asyncio.get_running_loop()
        while True:
            try:
                s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
                s.bind((socket.VMADDR_CID_ANY, FD_PROXY_PORT))
                s.listen(8)
                s.setblocking(False)
                break
            except OSError as e:
                log.warning("vsock listener bind failed (%s); retrying in 2s", e)
                await asyncio.sleep(2)
        log.info("fd proxy: listening on vsock port %d", FD_PROXY_PORT)
        while True:
            try:
                conn, _ = await loop.sock_accept(s)
                loop.create_task(self._handle_vsock_conn(conn))
            except (ConnectionError, OSError) as e:
                log.warning("vsock accept error: %s", e)
                await asyncio.sleep(1)

    async def _handle_vsock_conn(self, conn):
        loop = asyncio.get_running_loop()
        conn.setblocking(False)
        path = None
        try:
            buf = b""
            while b"\n" not in buf:
                data = await loop.sock_recv(conn, 256)
                if not data:
                    return
                buf += data
                if len(buf) > 4096:
                    return
            line = buf.split(b"\n", 1)[0].decode().strip()
            if line.startswith("ERR"):
                log.warning("fd proxy error for transport: %s", line)
                conn.close()
                return
            path = line
            entry = self.acquire_pending.pop(path, None)
            if entry is None:
                log.warning("vsock conn for unknown transport %s", path)
                conn.close()
                return
            sp = entry["sp"]
            sp.setblocking(False)
            log.info("fd proxy: bridging %s", path)
            counts = {"to_vsock": 0, "to_client": 0}

            async def copy(src, dst, name):
                while True:
                    try:
                        data = await loop.sock_recv(src, FD_BUF)
                    except (ConnectionError, OSError) as e:
                        log.warning("fd proxy %s recv error: %s", name, e)
                        return
                    if not data:
                        log.info("fd proxy %s EOF", name)
                        return
                    counts[name] += len(data)
                    try:
                        await loop.sock_sendall(dst, data)
                    except (ConnectionError, OSError) as e:
                        log.warning("fd proxy %s send error: %s", name, e)
                        return

            t1 = asyncio.ensure_future(copy(sp, conn, "to_vsock"))
            t2 = asyncio.ensure_future(copy(conn, sp, "to_client"))
            try:
                await asyncio.wait({t1, t2}, return_when=asyncio.FIRST_COMPLETED)
            finally:
                t1.cancel()
                t2.cancel()
                sp.close()
                conn.close()
                log.info("fd proxy: transport %s closed (to_vsock=%d, to_client=%d)",
                         path, counts["to_vsock"], counts["to_client"])
                # release the acquisition in the VM
                try:
                    await self.vm.call(
                        Message(
                            destination=FD_PROXY_NAME,
                            path=FD_PROXY_PATH,
                            interface=FD_PROXY_NAME,
                            member="ReleaseTransport",
                            signature="s",
                            body=[path],
                        )
                    )
                except Exception:
                    pass
        except Exception as e:
            log.warning("vsock conn handling failed: %s", e)
            conn.close()
            if path and path in self.acquire_pending:
                self.acquire_pending.pop(path)["sp"].close()

    async def _handle_acquire(self, msg):
        """Intercept MediaTransport1.Acquire: return a host-side socketpair fd
        and pump the VM's real transport socket to it over vsock.

        PipeWire expects the reply as (fd, read_mtu, write_mtu) = hqq, so the
        MTUs from the VM's real Acquire reply are forwarded."""
        loop = asyncio.get_running_loop()
        sp1, sp2 = socket.socketpair()
        path = msg.path
        self.acquire_pending[path] = {"sp": sp1, "task": None}
        read_mtu, write_mtu = 0, 0
        try:
            r = await self.vm.call(
                Message(
                    destination=FD_PROXY_NAME,
                    path=FD_PROXY_PATH,
                    interface=FD_PROXY_NAME,
                    member="AcquireTransport",
                    signature="s",
                    body=[path],
                )
            )
            if r.message_type is MessageType.METHOD_RETURN:
                parts = (r.body[0] or "").split()
                if len(parts) >= 3 and parts[0] == "OK":
                    read_mtu, write_mtu = int(parts[1]), int(parts[2])
        except Exception as e:
            log.error("fd proxy trigger for %s failed: %s", path, e)
        # give the fd to the client; data is buffered in the socketpair until
        # the vsock channel from the VM proxy is up. Close our copy of sp2 so
        # the client's end is the only reference (its close -> EOF on sp1).
        await self.host.send(
            Message(
                destination=msg.sender,
                reply_serial=msg.serial,
                message_type=MessageType.METHOD_RETURN,
                signature="hqq",
                body=[0, read_mtu, write_mtu],
                unix_fds=[sp2.fileno()],
            )
        )
        sp2.close()
        # safety net: if no vsock connection arrives, fail the stream
        loop.call_later(15, lambda: self._acquire_timeout(path))

    def _acquire_timeout(self, path):
        entry = self.acquire_pending.pop(path, None)
        if entry:
            log.warning("fd proxy: no vsock connection for %s; closing", path)
            entry["sp"].close()

    async def _handle_release(self, msg):
        entry = self.acquire_pending.pop(msg.path, None)
        if entry:
            entry["sp"].close()
        try:
            await self.vm.call(
                Message(
                    destination=FD_PROXY_NAME,
                    path=FD_PROXY_PATH,
                    interface=FD_PROXY_NAME,
                    member="ReleaseTransport",
                    signature="s",
                    body=[msg.path],
                )
            )
        except Exception:
            pass
        await self.host.send(
            Message(
                destination=msg.sender,
                reply_serial=msg.serial,
                message_type=MessageType.METHOD_RETURN,
                signature="",
                body=[],
            )
        )

    # ------------------------------------------------- host bus: client -> relay
    def on_host_message(self, msg):
        if msg.message_type is MessageType.METHOD_CALL and msg.destination == HOST_NAME:
            asyncio.create_task(self.forward_host_call(msg))
            return True
        if msg.message_type in (MessageType.METHOD_RETURN, MessageType.ERROR):
            if msg.reply_serial in self.pending:
                asyncio.create_task(self.forward_callback_reply(msg))
                return True
        if (msg.message_type is MessageType.SIGNAL
                and msg.interface == "org.freedesktop.DBus"
                and msg.member == "NameOwnerChanged"):
            # a host client vanished: drop its registered callback objects so
            # bluetoothd's callbacks are not routed to a dead name
            name, _old, new = msg.body
            if not new:
                dead = [p for p, o in self.callback_owners.items() if o == name]
                for p in dead:
                    del self.callback_owners[p]
                if dead:
                    log.info("host client %s left; dropped registrations: %s", name, dead)
        return None

    async def forward_host_call(self, msg):
        # A2DP/HFP transports: the audio socket fd cannot cross vsock, so
        # handle Acquire/Release with the fd proxy instead of forwarding.
        if msg.interface == "org.bluez.MediaTransport1" and msg.member in ("Acquire", "TryAcquire"):
            await self._handle_acquire(msg)
            return
        if msg.interface == "org.bluez.MediaTransport1" and msg.member == "Release":
            await self._handle_release(msg)
            return
        member = msg.member or ""
        reg = REGISTRATIONS.get((msg.interface, member))
        if reg is not None and len(msg.body or []) > reg:
            path = msg.body[reg]
            if member.startswith("Unregister"):
                self.callback_owners.pop(path, None)
                log.info("unregistered callback path %s", path)
            else:
                self.callback_owners[path] = msg.sender
                log.info("registered callback path %s -> %s", path, msg.sender)
        fwd = Message(
            destination=msg.destination,
            path=msg.path,
            interface=msg.interface,
            member=member,
            signature=msg.signature,
            body=msg.body,
            flags=msg.flags,
        )
        try:
            reply = await asyncio.wait_for(self.vm.call(fwd), timeout=CALL_TIMEOUT)
        except Exception as e:
            log.error("forwarding %s.%s failed: %s", msg.interface, member, e)
            reply = Message.new_error(
                msg,
                "org.freedesktop.DBus.Error.NoReply",
                f"bluetooth VM unreachable: {e}",
            )
        if reply is None:
            return
        await self.host.send(
            Message(
                destination=msg.sender,
                reply_serial=msg.serial,
                message_type=reply.message_type,
                error_name=reply.error_name,
                signature=reply.signature,
                body=reply.body,
            )
        )

    async def forward_callback_reply(self, msg):
        vm_serial, vm_sender = self.pending.pop(msg.reply_serial, (None, None))
        if vm_serial is None:
            return
        await self.vm.send(
            Message(
                destination=vm_sender,
                reply_serial=vm_serial,
                message_type=msg.message_type,
                error_name=msg.error_name,
                signature=msg.signature,
                body=msg.body,
            )
        )

    # ---------------------------------------------------- vm bus: daemon -> relay
    def on_vm_message(self, msg):
        if msg.message_type is MessageType.SIGNAL:
            if msg.interface == "org.freedesktop.DBus" and msg.member == "NameOwnerChanged":
                return None  # don't relay bus-internal bookkeeping
            asyncio.create_task(self.forward_signal(msg))
            return True
        if msg.message_type is MessageType.METHOD_CALL:
            dest = msg.destination or ""
            if dest not in (HOST_NAME, "org.freedesktop.DBus"):
                # bluetoothd is calling back into an object a host client
                # registered (agent, endpoint, app, profile, ...)
                owner = self.owner_for(msg.path)
                if owner:
                    asyncio.create_task(self.forward_callback_call(msg, owner))
                    return True
                log.warning("vm bus: dropping callback to %s (no owner registered)", msg.path)
                return None  # dbus-next replies with an UnknownMethod error
        return None

    def owner_for(self, path):
        best, best_len = None, -1
        for prefix, owner in self.callback_owners.items():
            if path == prefix or path.startswith(prefix + "/"):
                if len(prefix) > best_len:
                    best, best_len = owner, len(prefix)
        return best

    async def forward_signal(self, msg):
        await self.host.send(
            Message(
                path=msg.path,
                interface=msg.interface,
                member=msg.member,
                message_type=MessageType.SIGNAL,
                signature=msg.signature,
                body=msg.body,
            )
        )

    async def forward_callback_call(self, msg, owner):
        fwd = Message(
            destination=owner,
            path=msg.path,
            interface=msg.interface,
            member=msg.member,
            signature=msg.signature,
            body=msg.body,
            flags=msg.flags,
        )
        await self.host.send(fwd)  # assigns fwd.serial synchronously
        self.pending[fwd.serial] = (msg.serial, msg.sender)


async def main():
    await Relay().start()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
