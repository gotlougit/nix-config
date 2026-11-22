{ lib, pkgs, ... }:
let
  servicePort = 5090;
in
{
  services.redlib = {
    enable = true;
    package = pkgs.redlib;
    port = 5090;
    address = "127.0.0.1";
    openFirewall = false;
  };

  # Create the root-only file that systemd loads as a credential at start.
  # Put one reddit_session cookie per line in here; it is never exposed via
  # /nix/store.
  systemd.tmpfiles.rules = [
    "f /persist/redlib-auth 0600 root root -"
  ];

  systemd.services.redlib = {
    environment = {
      REDLIB_DEFAULT_USE_HLS = "on";
      REDLIB_DEFAULT_REMOVE_DEFAULT_FEEDS = "on";
      REDLIB_DEFAULT_THEME = "nord";
      REDLIB_REDDIT_COOKIE_FILE = "%d/redlib-auth";
    };

    serviceConfig.LoadCredential = "redlib-auth:/persist/redlib-auth";
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

  # Allow gotlou to restart redlib without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "redlib.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
