{ ... }:
{
  imports = [ ../overlays/mullvad-tailscale/mullvad-tailscale-module.nix ];

  # Enable the Mullvad VPN daemon (from upstream nixpkgs)
  services.mullvad-vpn = {
    enable = true;
    # Optionally block traffic during early boot before Mullvad can connect
    enableEarlyBootBlocking = false;
  };

  # Enable our mullvad-tailscale integration
  services.mullvad-tailscale = {
    enable = true;
    # Automatically apply nftables rules at boot so Tailscale and Mullvad
    # can coexist from the start. The rules mark tailscale IPs to bypass
    # the Mullvad tunnel.
    enableAutoConf = true;
    # Interface whose IPs should bypass the Mullvad tunnel. Required for
    # `tailscaleTCPPorts` / `tailscaleUDPPorts` to take effect.
    tailscaleInterface = "tailscale0";
    # Keep this list in sync with `networking.firewall.interfaces.tailscale0`
    # in the service modules (openssh, redlib, tokidoki, ...). This
    # guarantees they remain reachable over Tailscale while Mullvad VPN
    # is active. NixOS dedupes the resulting firewall rules.
    tailscaleTCPPorts = [
      22 # openssh
      5090 # redlib
      9686 # tokidoki
    ];
    tailscaleUDPPorts = [ ];
  };

  # Ensure nftables is enabled (required by mullvad-tailscale)
  networking.nftables.enable = true;

  # Kernel module required by Mullvad VPN
  boot.kernelModules = [ "tun" ];
}
