{ ... }:
{
  # kratos-specific rules for networking
  networking.hostName = "kratos";
  # Enable networkmanager
  networking.networkmanager.enable = true;
  # Randomize MAC address
  networking.networkmanager.wifi.macAddress = "stable";
  networking.networkmanager.ethernet.macAddress = "stable";
  # Allow KDE connect
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  # Allow Syncthing
  networking.firewall.allowedUDPPorts = [ 22000 ];
}
