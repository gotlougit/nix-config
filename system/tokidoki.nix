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
}
