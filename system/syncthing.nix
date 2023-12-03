{ lib, ... }:
{
  # Enable syncthing to sync important files in background
  services.syncthing = {
    enable = true;
    user = "gotlou";
    group = "users";
    configDir = "/persist/sensitive/syncthing";
    dataDir = "/persist/sensitive/syncthing/datadir";
    openDefaultPorts = true;
  };
  systemd.services.syncthing = {
    enable = true;
    serviceConfig = {
      ProtectClock = true;
      ProtectSystem = "full";
      SystemCallArchitectures = "native";
      RestrictRealtime = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = [ "@known" "~@clock" "~@cpu-emulation" "~@raw-io" "~@reboot" "~@mount" "~@obsolete" "~@swap" "~@debug" "~@keyring" "~@pkey" "~@privileged" "~@module" ];
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
      CapabilityBoundingSet = lib.mkForce [ "" ];
    };
  };
}
