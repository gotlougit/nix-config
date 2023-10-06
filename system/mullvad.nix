{ ... }:
{
  # Enable Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };
}
