{ lib, ... }:
let
  servicePort = 8090;
in
{
  services.nitter = {
    enable = true;

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
}
