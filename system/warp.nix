{ inputs, ... }:
{
  imports = [ inputs.warp-re.nixosModules.warp-proxy ];

  services.warp-proxy = {
    enable = true;
    acceptTos = true;
    bind = "0.0.0.0";
    # The Pi has no working IPv6 uplink.
    ipv6 = false;
    socksPort = 6666;
    httpPort = 6667;
  };

  networking.firewall.allowedTCPPorts = [
    6666
    6667
  ];
}
