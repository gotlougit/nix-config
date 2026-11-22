{ lib, pkgs, ... }:
let
  servicePort = 8090;
in
{
  services.nitter = {
    enable = true;
    package = pkgs.shitter;

    server = {
      address = "127.0.0.1";
      port = servicePort;
      title = "xitter";
    };

    sessionsFile = "/persist/nitter-auth";
    redisCreateLocally = true;
    openFirewall = false;

    preferences = {
      theme = "Nitter";
      proxyVideos = true;
      hlsPlayback = true;
      infiniteScroll = false;
    };
  };

  # Create the root-only file that systemd loads as a credential at start.
  # Put the JSONL session tokens in here; they are never exposed via /nix/store.
  systemd.tmpfiles.rules = [
    "f /persist/nitter-auth 0600 root root -"
  ];

  systemd.services.nitter.serviceConfig = {
    ProtectSystem = "strict";
    PrivateTmp = true;
    PrivateMounts = true;
    NoNewPrivileges = true;
    SystemCallFilter = lib.mkForce [
      "@system-service"
      "~@cpu-emulation"
      "~@debug"
      "~@keyring"
      "~@memlock"
      "~@mount"
      "~@obsolete"
      "~@privileged"
      "~@resources"
      "~@setuid"
    ];
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

  # Allow gotlou to restart nitter without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit == "nitter.service" &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
