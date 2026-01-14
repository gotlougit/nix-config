{ pkgs, ... }:
{

  users.groups.vamp-api.members = [ "gotlou" ];

  systemd.sockets.vamp-api = {
    description = "Vamp API Socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      Service = "vamp.service";
      ListenStream = "127.0.0.1:25799";
      FileDescriptorName = "api";
    };
  };

  systemd.sockets.vamp-admin = {
    description = "Vamp Admin Socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      Service = "vamp.service";
      ListenStream = "127.0.0.1:25899";
      FileDescriptorName = "admin";
    };
  };

  systemd.services.vamp = {
    requires = [
      "vamp-api.socket"
      "vamp-admin.socket"
    ];
    after = [
      "vamp-api.socket"
      "vamp-admin.socket"
    ];

    environment.VAMP_DB = "%S/vamp/cloxy-db.sqlite";
    environment.RUST_LOG = "info";
    environment.VAMP_SOCKET = "@fd-tcp";
    environment.VAMP_ADMIN_SOCKET = "@fd-tcp";

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
