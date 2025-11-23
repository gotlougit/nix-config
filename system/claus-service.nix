{ pkgs, ... }: {
  environment.sessionVariables = { ANTHROPIC_API_KEY = "BOOO"; };
  systemd.sockets.vamp = {
    listenStreams = [ "127.0.0.1:25799" ];
    wantedBy = [ "sockets.target" ];
  };
  systemd.services.vamp = {
    environment.VAMP_DB = "%S/vamp/cloxy-db.sqlite";
    environment.GEMEC_DB = "%S/vamp/gemec-db.sqlite";
    environment.RUST_LOG = "info";
    serviceConfig = {
      ExecStart = "${pkgs.claus}/bin/vamp";
      StateDirectory = "vamp";
      DevicePolicy = "closed";
      DynamicUser = true;
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
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      UMask = "0077";
      InaccessiblePaths = "/persist";
    };
  };
  systemd.sockets.cloxy = {
    listenStreams = [ "127.0.0.1:25784" ];
    wantedBy = [ "sockets.target" ];
  };
  systemd.services.cloxy = {
    environment.CLOXY_DB = "%S/cloxy/db.sqlite";
    environment.RUST_LOG = "info";
    serviceConfig = {
      ExecStart = "${pkgs.claus}/bin/cloxy";
      StateDirectory = "cloxy";
      DevicePolicy = "closed";
      DynamicUser = true;
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
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      UMask = "0077";
      InaccessiblePaths = "/persist";
    };
  };
}

