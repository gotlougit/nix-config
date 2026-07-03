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

  systemd.services.redlib.environment = {
    REDLIB_DEFAULT_USE_HLS = "on";
    REDLIB_DEFAULT_REMOVE_DEFAULT_FEEDS = "on";
    REDLIB_DEFAULT_THEME = "nord";
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };

}
