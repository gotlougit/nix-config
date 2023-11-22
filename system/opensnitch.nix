{ pkgs, lib, ... }:
{
  imports = [
  ];
  # OpenSnitch stuff
  systemd.user.services."opensnitch-ui" = {
    enable = true;
    description = "OpenSnitch UI";
    after = [ "graphical-session-pre.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      #Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.opensnitch-ui}/bin/opensnitch-ui";
      Restart = "on-failure";
    };

    #Install = { WantedBy = [ "graphical-session.target" ]; };
  };
  services.opensnitch = {
    enable = true;
    rules = {
      deny-insecure-dirs = {
        name = "deny-insecure-dirs";
        enabled = true;
        action = "deny";
        duration = "always";
        operator = {
            type = "regexp";
            operand = "process.path";
            data = "^(/tmp/|/var/tmp/|/dev/shm/|/var/run|/var/lock).*";
        };
      };
      chronyd = {
        name = "chronyd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.chrony}/bin/chronyd";
        };
      };
      dnscrypt-proxy2 = {
        name = "dnscrypt-proxy2";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
        };
      };
      nsncd = {
        name = "nsncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.nsncd}/bin/nsncd";
        };
      };
      NetworkManager = {
        name = "NetworkManager";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.networkmanager}/bin/NetworkManager";
        };
      };
      syncthing = {
        name = "syncthing";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.syncthing}/bin/syncthing";
        };
      };
      tailscale = {
        name = "tailscale";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.tailscale}/bin/.tailscaled-wrapped";
        };
      };
      kdeconnect = {
        name = "kdeconnect";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.kdeconnect}/libexec/.kdeconnectd-wrapped";
        };
      };
      signal-allow = {
        name = "signal-only-allow-signal.org";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          sensitive = false;
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.signal-desktop}/lib/Signal/signal-desktop\", \"sensitive\": true}, {\"type\": \"regexp\", \"operand\": \"dest.host\", \"data\": \".*\\\\.signal.org\", \"sensitive\": false}]";
          list = [
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.signal-desktop}/lib/Signal/signal-desktop";
              sensitive = true;
            }
            {
              type= "regexp";
              operand= "dest.host";
              data= ".*\\.signal.org";
              sensitive= false;
            }
          ];
        };
      };
    };
  };

}
