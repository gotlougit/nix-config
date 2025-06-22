let
  servicePort = 9686;
in {
  imports = [ ../overlays/tokidoki/tokidoki-module.nix ];

  services.tokidoki = {
    enable = true;
    port = servicePort;
    address = "0.0.0.0";
    authUrl = "null://";
    openFirewall = false;
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };
}
