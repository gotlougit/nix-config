{ inputs, pkgs, ... }:
let
  serviceAddress = "0.0.0.0:4433";
in
{
  imports = [ inputs.hister.nixosModules.default ];

  services.hister = {
    enable = true;
    package = pkgs.hister;
    user = "hister";
    group = "hister";
    config = {
      app = {
        directory = "/var/lib/hister";
        search_url = "https://search.brave.com/search?q={query}";
        log_level = "info";
      };
      server = {
        address = serviceAddress;
        base_url = "http://${serviceAddress}";
        database = "db.sqlite3";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 4433 ];

  systemd.services.hister.serviceConfig = {
    StateDirectory = "hister";
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
}
