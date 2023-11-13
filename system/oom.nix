{ ... }:
{
  # Enable earlyoom to manage memory better and prevent freezes
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 15;
  };
  systemd.oomd.enable = false;
  # Harden earlyoom
  systemd.services.earlyoom = {
    enable = true;
    serviceConfig = {
      NoNewPrivileges = true;
      LockPersonality = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = true;
      PrivateNetwork = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      InaccessiblePaths = "/persist";
      CapabilityBoundingSet = [ "" ];
      ProtectHome = true;
      ProtectClock = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
      UMask = "0077";
    };
  };
}
