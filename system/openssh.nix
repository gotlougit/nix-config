{ ... }:
{
  # Enable the OpenSSH daemon to act as SSH server
  services.openssh.enable = true;
  systemd.services.sshd = {
    enable = true;
    serviceConfig = {
      ProtectSystem = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      PrivateDevices = true;
      LockPersonality = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      MemoryDenyWriteExecute = true;
      RestrictSUIDGID = true;
      RestrictRealtime = true;
      # Protect Impermanence paths, which are full of private data
      InaccessiblePaths = [ "/persist" ];
      SystemCallArchitectures = "native";
      NoNewPrivileges = true;
      SystemCallFilter = [
        "@system-service"
        "~@resources"
      ];
    };
  };
}
