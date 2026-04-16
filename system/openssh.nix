{ ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      MaxAuthTries = 10;
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  systemd.services."sshd@".serviceConfig = {
    ProtectSystem = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateDevices = true;
    LockPersonality = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    MemoryDenyWriteExecute = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    # Protect Impermanence paths, which are full of private data
    InaccessiblePaths = [ "/persist" ];
    SystemCallArchitectures = "native";
    NoNewPrivileges = true;
    UMask = "0077";
    SystemCallFilter = [
      "~@clock"
      "~@cpu-emulation"
      "~@debug"
      "~@module"
      "~@obsolete"
      "~@raw-io"
      "~@reboot"
      "~@swap"
    ];
  };
}
