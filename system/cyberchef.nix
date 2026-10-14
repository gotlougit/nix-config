{ pkgs, lib, ... }:
let
  servicePort = 5080;
in
{
  systemd.services.cyberchef = {
    description = "Self-hosted CyberChef - Cyber Swiss Army Knife";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.miniserve}/bin/miniserve ${pkgs.cyberchef}/share/cyberchef --port ${toString servicePort} --index index.html";
      Restart = "on-failure";
      DynamicUser = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

  # Allow gotlou to restart cyberchef without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "cyberchef.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
