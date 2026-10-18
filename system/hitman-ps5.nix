{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.hitman-ps5 ];

  users.groups.hitman-ps5 = { };
  users.users.hitman-ps5 = {
    isSystemUser = true;
    group = "hitman-ps5";
  };

  environment.persistence."/persist/system".directories = [
    {
      directory = "/var/lib/hitman-ps5";
      user = "hitman-ps5";
      group = "hitman-ps5";
      mode = "0700";
    }
  ];

  networking.firewall.allowedTCPPorts = [ 8410 ];

  systemd.services.hitman-ps5 = {
    description = "HITMAN PS5 Node backend";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    environment = {
      HOST = "0.0.0.0";
      PORT = "8410";
      NODE_ENV = "production";
      HITMAN_PS5_STATE_DIR = "/var/lib/hitman-ps5";
    };
    serviceConfig = {
      ExecStart = lib.getExe pkgs.hitman-ps5;
      User = "hitman-ps5";
      Group = "hitman-ps5";
      StateDirectory = "hitman-ps5";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/hitman-ps5";
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077";
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateMounts = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
    };
  };

  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "hitman-ps5.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
