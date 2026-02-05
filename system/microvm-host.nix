{ ... }:
{
  # Create microbr bridge for microvms
  systemd.network.netdevs."20-microbr".netdevConfig = {
    Kind = "bridge";
    Name = "microbr";
  };

  systemd.network.networks."20-microbr" = {
    matchConfig.Name = "microbr";
    addresses = [ { Address = "192.168.83.1/24"; } ];
    networkConfig = {
      ConfigureWithoutCarrier = true;
    };
  };

  # Attach microvm tap interfaces to the bridge
  systemd.network.networks."21-microvm-tap" = {
    matchConfig.Name = "microvm*";
    networkConfig.Bridge = "microbr";
  };

  # Enable NAT for microvms
  networking.nat = {
    enable = true;
    internalInterfaces = [ "microbr" ];
    externalInterface = "enp2s0";
  };

  # Open firewall for microvm subnet
  networking.firewall.interfaces."microbr" = {
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ 53 ];
  };
}
