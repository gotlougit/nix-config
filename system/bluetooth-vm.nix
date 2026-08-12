# Runs the Bluetooth daemon inside an isolated QEMU VM instead of on the
# host. The Realtek radio is passed through as a USB device; bluetoothd and
# the whole bluez userspace (the interesting C attack surface) live in the
# guest. The host only sees bluetooth through a D-Bus relay.
#
# Security model: a bluez memory-corruption bug can at worst take over the
# VM. The host kernel keeps no bluetooth driver bound while the VM runs, and
# QEMU mediates all USB traffic (no VFIO DMA from the radio).
#
# The pieces:
#   bluetooth-vm.service     the QEMU VM itself (root, device access only)
#   bluetooth-vm-bus.service socat: host unix socket <-> guest vsock 51820
#   bluetooth-vm-relay.service  owns org.bluez on the host system bus and
#                             forwards to the VM bus (relay.py)
{ config, lib, pkgs, self, ... }:

let
  vm = self.nixosConfigurations.btvm.config.system.build.vm;
  runVm = "${vm}/bin/run-btvm-vm";
  python = pkgs.python3.withPackages (ps: [ ps.dbus-next ]);
in
{
  options.bluetoothVM.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Run bluetoothd inside an isolated VM instead of on the host.";
  };

  config = lib.mkIf config.bluetoothVM.enable {
    # The radio belongs to the VM now; never run bluetoothd on the host. Mask
    # the unit too: a bluetoothd left over from an older generation keeps
    # owning org.bluez on the host bus and shadows the relay below (the host
    # has no radio, so it answers with an empty adapter list).
    hardware.bluetooth.enable = lib.mkForce false;
    systemd.services.bluetooth.enable = lib.mkForce false;

    # Keep bluetoothctl available on the host (it talks to the VM through
    # the relay / bridged socket).
    environment.systemPackages = [ pkgs.bluez ];

    # The vsock channel between QEMU and the guest.
    boot.kernelModules = [ "vhost_vsock" ];

    systemd.services.bluetooth-vm = {
      description = "Bluetooth daemon VM (QEMU)";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = runVm;
        Restart = "on-failure";
        RestartSec = 5;
        # Only the devices the VM needs: KVM, vsock and usbfs (char major
        # 189, where /dev/bus/usb/* lives).
        DeviceAllow = [
          "/dev/kvm rw"
          "/dev/vhost-vsock rw"
          "char-189 rw"
        ];
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
      };
    };

    # Expose the VM's D-Bus system socket on the host. Note the guest's dbus
    # validates EXTERNAL auth against the peer it sees on the bridged
    # connection (the guest-side socat, uid 0), so only root can connect to
    # this socket directly. Normal users should use the relay below, which
    # owns org.bluez on the host system bus (what bluetoothctl and the
    # desktop talk to by default).
    systemd.services.bluetooth-vm-bus = {
      description = "Expose the Bluetooth VM's D-Bus socket on the host";
      wantedBy = [ "multi-user.target" ];
      requires = [ "bluetooth-vm.service" ];
      after = [ "bluetooth-vm.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:/run/bluetooth-vm/system_bus_socket,fork,reuseaddr,unlink-early,mode=0666 VSOCK-CONNECT:5:51820";
        RuntimeDirectory = "bluetooth-vm";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    # Make org.bluez appear on the host system bus (what Plasma bluetooth,
    # KDE Connect, bluetoothctl etc. actually talk to) by relaying the VM
    # bus. See relay.py for what is and isn't forwarded.
    systemd.services.bluetooth-vm-relay = {
      description = "Relay org.bluez from the Bluetooth VM to the host system bus";
      wantedBy = [ "multi-user.target" ];
      requires = [ "bluetooth-vm-bus.service" ];
      after = [ "bluetooth-vm-bus.service" "dbus.service" ];
      serviceConfig = {
        ExecStart = "${python}/bin/python3 ${./bluetooth-vm/relay.py}";
        Restart = "on-failure";
        RestartSec = 2;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_VSOCK" ];
      };
    };

    # Allow gotlou to start/stop the VM services without sudo.
    security.polkit.extraConfig = lib.mkAfter ''
      polkit.addRule(function(action, subject) {
          if (subject.user == "gotlou" &&
              action.id == "org.freedesktop.systemd1.manage-units") {
              var unit = action.lookup("unit");
              var verb = action.lookup("verb");
              if (unit && unit.match(/^bluetooth-vm(-bus|-relay)?\.service$/) &&
                  (verb == "start" || verb == "stop" || verb == "restart")) {
                  return polkit.Result.YES;
              }
          }
      });
    '';
  };
}
