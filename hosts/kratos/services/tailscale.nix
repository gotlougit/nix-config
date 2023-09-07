{ ... }:
{
  services.tailscale = {
    enable = true;
    # Use exit nodes and subnet routers
    useRoutingFeatures = "client";
  };
}
