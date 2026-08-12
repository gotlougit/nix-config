# Minimal, disposable VM that runs the Bluetooth daemon (bluetoothd/bluez) in
# isolation. The physical radio is passed through from the host as a USB
# device; the daemon's only contact with the outside world is the D-Bus
# socket bridged to the host over vsock.
#
# Boot model: RAM-backed root (tmpfs), Nix store as a read-only image inside
# the VM, no host filesystem access except the bluetooth state directory
# (9p), no network (restrict=on slirp). This is the "microvm-like" profile of
# the stock NixOS qemu-vm module, no microvm.nix involved.
{ lib, pkgs, modulesPath, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.dbus-next ]);
in
{
  imports = [
    # Stock NixOS qemu-vm module (normally only pulled in by the test
    # driver / build-vm); this is what provides all the virtualisation.*
    # options we use below.
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  networking.hostName = "btvm";
  system.stateVersion = "24.11";

  # We don't need a package manager / docs / etc. inside the VM.
  nix.enable = lib.mkForce false;
  documentation.enable = false;

  # --- Bluetooth daemon -----------------------------------------------------
  # Same service the host used to run, with the same hardening applied on top
  # of the stock NixOS unit (which itself runs bluez with systemd sandboxing).
  hardware.bluetooth.enable = true;

  systemd.services.bluetooth = {
    # /var/lib/bluetooth is a 9p share with the host; pairings survive VM
    # restarts. Wait for the mount before starting.
    after = [ "var-lib-bluetooth.mount" ];
    requires = [ "var-lib-bluetooth.mount" ];
    serviceConfig = lib.mkMerge [
      (import ../../system/hardening-base.nix)
      {
        # hardening-base assumes the host's /persist exists; the VM has a
        # RAM-backed root with no such path, and systemd's mount-namespace
        # setup then fails before bluetoothd can even spawn (226/NAMESPACE).
        InaccessiblePaths = lib.mkForce [ ];
        SystemCallFilter = [ "~@privileged" ];
        ProtectProc = "invisible";
        IPAddressDeny = [ "any" ];
        RestrictAddressFamilies = [
          "AF_BLUETOOTH"
          "AF_UNIX"
        ];
        ProtectKernelModules = lib.mkForce true;
        ProtectKernelTunables = lib.mkForce true;
        # If bluetoothd dies (or fails to come up) keep retrying instead of
        # leaving the VM with no Bluetooth at all.
        Restart = "on-failure";
        RestartSec = 2;
      }
    ];
  };

  # --- Firmware ------------------------------------------------------------
  # The RTL8822CU radio (0bda:c123) needs rtl_bt/rtl8822cu_fw.bin and
  # rtl_bt/rtl8822cu_config.bin; without them btusb can't bring hci0 up and
  # bluetoothd fails at boot. Use the standard NixOS mechanism so the VM gets
  # whatever redistributable firmware its hardware ends up needing rather than
  # hand-picked files.
  hardware.enableRedistributableFirmware = true;
  # --- VM plumbing ----------------------------------------------------------
  virtualisation = {
    graphics = false;
    memorySize = 1024;
    cores = 2;

    # RAM-backed root; the Nix store is a read-only erofs image inside the VM.
    # Nothing of the host's filesystem is mounted.
    diskImage = null;
    useNixStoreImage = true;

    # Guest is fully network-isolated (slirp with restrict=on).
    restrictNetwork = true;

    qemu.options = [
      # Realtek RTL8822CU Bluetooth radio (0bda:c123) from the host. QEMU
      # detaches the host's btusb driver when it claims the device, so the
      # host loses hci0 for as long as the VM runs.
      "-device usb-host,vendorid=0x0bda,productid=0xc123"
      # Host <-> VM channel used by the D-Bus bridge.
      "-device vhost-vsock-pci,guest-cid=5"
    ];

    # Pairing keys / adapter state live on the host so they survive rebuilds
    # and VM restarts: this is the host's own bluetooth state (a persistent
    # ZFS dataset), so existing pairings carry over and new ones survive.
    # security_model=none maps guest root to the qemu uid (root on the host).
    sharedDirectories.bluetooth-state = {
      source = "/var/lib/bluetooth";
      target = "/var/lib/bluetooth";
      securityModel = "none";
    };
  };

  # --- D-Bus bridge ----------------------------------------------------------
  # The host reaches bluetoothd by tunnelling the VM's system D-Bus socket
  # over vsock (port 51820). The counterpart runs on the host
  # (system/bluetooth-vm.nix) and the desktop-facing relay is
  # system/bluetooth-vm/relay.py.
  systemd.services.bluetooth-vsock-bridge = {
    description = "Bridge the D-Bus system socket to vsock for the host";
    wantedBy = [ "multi-user.target" ];
    after = [ "dbus.service" ];
    requires = [ "dbus.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat VSOCK-LISTEN:51820,fork,reuseaddr UNIX-CONNECT:/run/dbus/system_bus_socket";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  # --- FD proxy (A2DP/HFP audio) -------------------------------------------
  # BlueZ hands the audio socket to clients by passing a file descriptor over
  # D-Bus, which cannot cross the vsock D-Bus bridge. This service acquires
  # transports inside the VM and pumps the raw byte stream to the host over a
  # dedicated vsock port (51821), where the relay (relay.py) presents a
  # host-side socketpair to PipeWire/WirePlumber.
  services.dbus.packages = [
    (pkgs.writeTextDir "share/dbus-1/system.d/org.btfdproxy.conf" ''
      <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
       "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
      <busconfig>
        <policy user="root">
          <allow own="org.btfdproxy"/>
        </policy>
        <policy context="default">
          <allow send_destination="org.btfdproxy"/>
        </policy>
      </busconfig>
    '')
  ];
  systemd.services.bluetooth-fdproxy = {
    description = "Bridge BlueZ audio transports to the host over vsock";
    wantedBy = [ "multi-user.target" ];
    after = [ "dbus.service" "bluetooth.service" ];
    requires = [ "dbus.service" ];
    serviceConfig = {
      ExecStart = "${python}/bin/python3 ${../../system/bluetooth-vm/fdproxy-vm.py}";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
