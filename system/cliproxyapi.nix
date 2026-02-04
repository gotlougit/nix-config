{ pkgs, ... }:
{
  # systemd.sockets.cliproxyapi = {
  #   description = "CLIProxyAPI Socket";
  #   wantedBy = [ "sockets.target" ];

  #   socketConfig = {
  #     ListenStream = "127.0.0.1:8317";
  #     Accept = false;
  #   };
  # };

  systemd.services.cliproxyapi = {
    description = "CLIProxyAPI";
    after = [ "network.target" ];
    # requires = [ "cliproxyapi.socket" ];

    serviceConfig = {
      ExecStart = "${pkgs.cliproxyapi}/bin/server --config %d/config.yaml";
      Restart = "always";
      RestartSec = "3";

      StateDirectory = "cliproxyapi";
      DynamicUser = true;

      # Load config file as credential (readable by dynamic user)
      LoadCredential = "config.yaml:/persist/system/cliproxyapi.yaml";

      # Hardening
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@resources"
        "~@privileged"
      ];
      UMask = "0077";
      InaccessiblePaths = "/persist";
    };
  };
}
