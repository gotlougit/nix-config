#!/usr/bin/env python3
"""Bridge BlueZ audio transports from the VM to the host over vsock.

BlueZ hands the A2DP/HFP audio socket to clients by passing a file
descriptor over D-Bus (MediaTransport1.Acquire / Profile1.NewConnection).
File descriptors cannot cross the vsock D-Bus bridge, so the host relay
cannot use the real socket. Instead, this service (running inside the VM
where the fd never needs to leave) acquires the transport locally and pumps
the raw byte stream over a dedicated vsock connection (port 51821) to the
host, where the relay presents a host-side socketpair fd to the client
(PipeWire/WirePlumber).

Control flow:
  1. Host client calls MediaTransport1.Acquire -> the host relay intercepts.
  2. The relay asks this service (org.btfdproxy.AcquireTransport) for the
     transport path.
  3. We call org.bluez MediaTransport1.Acquire ourselves (fd stays in the
     VM), connect vsock to the host, send the transport path as a handshake
     line, and pump bytes in both directions until either side closes.
  4. When the stream ends we call MediaTransport1.Release to free the
     transport in bluetoothd.
"""
import asyncio
import logging
import os
import socket

from dbus_next import Message, MessageType, BusType
from dbus_next.aio import MessageBus
from dbus_next.service import ServiceInterface, method

logging.basicConfig(level=logging.INFO, format="%(name)s: %(message)s")
log = logging.getLogger("bt-fdproxy-vm")

HOST_VSOCK_PORT = 51821  # must match the host relay
BUF = 1 << 16


class FdProxy(ServiceInterface):
    def __init__(self, bus):
        super().__init__("org.btfdproxy")
        self.bus = bus

    @method()
    async def AcquireTransport(self, path: "s") -> "s":
        """Acquire the transport in the VM and pump it to the host."""
        log.info("acquiring transport %s", path)
        try:
            reply = await self.bus.call(
                Message(
                    destination="org.bluez",
                    path=path,
                    interface="org.bluez.MediaTransport1",
                    member="Acquire",
                )
            )
            if reply.message_type is MessageType.ERROR:
                log.error("Acquire failed: %s %s", reply.error_name, reply.body)
                return f"ERR {reply.error_name}"
            fd = reply.unix_fds[reply.body[0]]
            read_mtu, write_mtu = reply.body[1], reply.body[2]
            vsock = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
            vsock.connect((socket.VMADDR_CID_HOST, HOST_VSOCK_PORT))
            vsock.sendall(path.encode() + b"\n")
            asyncio.get_running_loop().create_task(self._pump(path, fd, vsock))
            # pass the transport MTUs back so the host relay can answer the
            # client's Acquire with the (fd, read_mtu, write_mtu) it expects
            return f"OK {read_mtu} {write_mtu}"
        except Exception as e:
            log.error("AcquireTransport %s failed: %s", path, e)
            return f"ERR {e}"

    @method()
    async def ReleaseTransport(self, path: "s") -> "s":
        """Release the transport in bluetoothd (idempotent)."""
        try:
            await self.bus.call(
                Message(
                    destination="org.bluez",
                    path=path,
                    interface="org.bluez.MediaTransport1",
                    member="Release",
                )
            )
        except Exception as e:
            log.info("Release %s: %s", path, e)
        return "OK"

    async def _pump(self, path, fd, vsock):
        loop = asyncio.get_running_loop()
        try:
            fd_sock = socket.socket(fileno=fd)
        except OSError as e:
            log.error("wrapping transport fd failed: %s", e)
            vsock.close()
            return
        for s in (fd_sock, vsock):
            s.setblocking(False)
        log.info("pumping %s (fd=%d) <-> host", path, fd)
        counts = {"to_vsock": 0, "to_bt": 0}

        async def copy(src, dst, name):
            while True:
                try:
                    data = await loop.sock_recv(src, BUF)
                except (ConnectionError, OSError) as e:
                    log.warning("pump %s recv error: %s", name, e)
                    return
                if not data:
                    log.info("pump %s EOF", name)
                    return
                counts[name] += len(data)
                try:
                    await loop.sock_sendall(dst, data)
                except (ConnectionError, OSError) as e:
                    log.warning("pump %s send error: %s", name, e)
                    return

        t1 = asyncio.ensure_future(copy(fd_sock, vsock, "to_vsock"))
        t2 = asyncio.ensure_future(copy(vsock, fd_sock, "to_bt"))
        try:
            await asyncio.wait({t1, t2}, return_when=asyncio.FIRST_COMPLETED)
        finally:
            t1.cancel()
            t2.cancel()
            log.info("transport %s closed (to_vsock=%d bytes, to_bt=%d bytes)",
                     path, counts["to_vsock"], counts["to_bt"])
            fd_sock.close()
            vsock.close()
            try:
                await self.bus.call(
                    Message(
                        destination="org.bluez",
                        path=path,
                        interface="org.bluez.MediaTransport1",
                        member="Release",
                    )
                )
            except Exception:
                pass


async def main():
    # negotiate_unix_fd is required: bluetoothd hands the audio socket over
    # as an SCM_RIGHTS fd in the Acquire reply, and without negotiation the
    # bus broker cannot deliver it (the connection is dropped instead).
    bus = MessageBus(bus_type=BusType.SYSTEM, negotiate_unix_fd=True)
    await bus.connect()
    bus.export("/org/btfdproxy", FdProxy(bus))
    reply = await bus.request_name("org.btfdproxy")
    log.info("org.btfdproxy requested: %s", reply)
    await bus.wait_for_disconnect()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
