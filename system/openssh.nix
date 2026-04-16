{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      MaxAuthTries = 10;
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  systemd.services.sshd.serviceConfig = {
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
  };
}
