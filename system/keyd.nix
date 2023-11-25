{ config, lib, ... }:
let
  cfg = {
    main = {
      "capslock" = "overload(nav, esc)";
      "esc" = "capslock";
      # Insert ( when tapped and be shift when held
      "leftshift" = "overload(shift, S-9)";
      # Insert ) when tapped and be shift when held
      "rightshift" = "overload(shift, S-0)";
      # Insert { when tapped and be alt when held
      "leftalt" = "overload(alt, S-[)";
      # Insert } when tapped and be alt when held
      "rightalt" = "overload(alt, S-])";
      # Insert [ when tapped and be alt when held
      "leftcontrol" = "overload(control, [)";
      # Insert ] when tapped and be alt when held
      "rightcontrol" = "overload(control, ])";
      # FIXME when I don't need these to go cold turkey
      # This is a learning tool
      "backspace" = "noop";
      "delete" = "noop";
      "S-9" = "noop";
      "S-0" = "noop";
      "[" = "noop";
      "]" = "noop";
      "S-[" = "noop";
      "S-]" = "noop";
    };
    # vi keybindings for navigation
    nav = {
      "j" = "down";
      "k" = "up";
      "l" = "right";
      "h" = "left";
      "w" = "C-right";
      "b" = "C-left";
      ";" = "backspace";
      "d" = "delete";
      "shift" = "layer(selection)";
    };
    # vi-like key bindings for selection
    selection = {
      "l" = "S-right";
      "h" = "S-left";
      "w" = "C-S-right";
      "b" = "C-S-left";
      "x" = "C-a";
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
    CapabilityBoundingSet = lib.mkForce [ "CAP_SYS_NICE" "CAP_SYS_RESOURCE" ];
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
