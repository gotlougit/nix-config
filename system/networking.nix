{ ... }:
{
  # Setup networking
  networking = {
    # Enable networkmanager
    networkmanager.enable = true;
    # Randomize MAC address
    networkmanager.wifi.macAddress = "stable";
    networkmanager.ethernet.macAddress = "stable";

    nameservers = [ "127.0.0.1" "::1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    # Enable firewall by default

    # Note that services like tailscale and SSH will have their ports opened
    # if they are enabled, so we don't need to declare that here
    firewall.enable = true;
  };
  systemd.services.NetworkManager = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
  systemd.services.NetworkManager-dispatcher = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
  systemd.services.ModemManager = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
}
