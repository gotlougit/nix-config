let
  servicePort = 5090;
in
{
  services.redlib = {
    enable = true;
    port = 5090;
    address = "127.0.0.1";
    openFirewall = false;
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

}
