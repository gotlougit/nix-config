{ lib, ... }:
let
  servicePort = 9686;
in
{
  imports = [ ../overlays/tokidoki/tokidoki-module.nix ];

  services.tokidoki = {
    enable = true;
    port = servicePort;
    address = "127.0.0.1";
    authUrl = "null://";
    openFirewall = false;
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

  # Allow gotlou to restart tokidoki without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "tokidoki.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
