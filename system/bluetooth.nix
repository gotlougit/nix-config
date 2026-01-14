{ lib, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  systemd.services.bluetooth.serviceConfig = lib.mkMerge [
    (import ./hardening-base.nix)
    {
      SystemCallFilter = [
        "~@privileged"
        "~@resources"
      ];
      ProtectProc = "invisible";
      IPAddressDeny = [ "any" ];
      RestrictAddressFamilies = [
        "AF_BLUETOOTH"
        "AF_UNIX"
      ];
      ProtectKernelModules = lib.mkForce true;
      ProtectKernelTunables = lib.mkForce true;
    }
  ];

}
