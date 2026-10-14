{ lib, ... }:
let
  servicePort = 8095;
  redisPort = 6380;
in
{
  imports = [ ../overlays/kittygram/kittygram-module.nix ];

  services.kittygram = {
    enable = true;
    address = "0.0.0.0";
    port = servicePort;
    openFirewall = false;

    redisCreateLocally = true;
    redisHost = "127.0.0.1";
    redisPort = redisPort;
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

  # Allow gotlou to restart kittygram without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "kittygram.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
