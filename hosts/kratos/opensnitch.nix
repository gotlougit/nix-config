{ pkgs, lib, ...}:
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
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };
      dnscrypt-proxy2 = {
        name = "dnscrypt-proxy2";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
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
          type ="simple";
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
          type ="simple";
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
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.syncthing}/bin/syncthing";
          };
        };
      };
  };

}
