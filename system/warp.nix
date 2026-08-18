{ inputs, ... }:
{
  imports = [ inputs.warp-re.nixosModules.warp-proxy ];
  services.warp-proxy = {
    enable = true;
    acceptTos = true;
    bind = "0.0.0.0";
    ipv6 = true;
    socksPort = 6666;
    httpPort = 6667;
  };
}
