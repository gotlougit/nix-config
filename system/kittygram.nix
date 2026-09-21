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
}
