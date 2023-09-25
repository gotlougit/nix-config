{ config, ... }:
let
  cfg = {
    main = {
      "capslock" = "overload(custom, esc)";
      "esc" = "capslock";
    };
    custom = {
      "j" = "down";
      "k" = "up";
      "l" = "right";
      "h" = "left";
      "b" = "(";
      "c" = ":";
    };
  };
in
{
  services.keyd = {
    enable = true;
    keyboards.default.ids = [ "*" ];
    keyboards.default.settings = cfg;
  };
  systemd.services.keyd.serviceConfig = {
    Restart = "always";

    # TODO investigate why it doesn't work propeprly with DynamicUser
    # See issue: https://github.com/NixOS/nixpkgs/issues/226346
    # DynamicUser = true;
    SupplementaryGroups = [
      config.users.groups.input.name
      config.users.groups.uinput.name
    ];
    # CapabilityBoundingSet = "";
    DeviceAllow = [
      "char-input rw"
      "/dev/uinput rw"
    ];
    ProtectClock = true;
    PrivateNetwork = true;
    ProtectHome = true;
    ProtectHostname = true;
    # PrivateUsers = true;
    PrivateMounts = true;
    PrivateTmp = true;
    RestrictNamespaces = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    MemoryDenyWriteExecute = true;
    RestrictRealtime = true;
    LockPersonality = true;
    ProtectProc = "invisible";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
    InaccessiblePaths = "/persist";
    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictSUIDSGID = true;
    IPAddressDeny = [ "any" ];
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProcSubset = "pid";
    UMask = "0077";
  };
}
