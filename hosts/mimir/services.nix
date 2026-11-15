{ lib, ... }:
{
  networking = {
    useNetworkd = true;
    useDHCP = true;
    firewall.enable = true;

    # WiFi is configured imperatively after boot.  The resulting
    # /etc/wpa_supplicant state is persisted by impermanence.
    wireless = {
      enable = true;
      userControlled = true;
      allowAuxiliaryImperativeNetworks = true;
    };

    # Keep DNSCrypt as the primary resolver, but fall back to public DNS if it
    # is not ready yet (e.g. during first boot or source-list refresh).
    nameservers = lib.mkForce [
      "127.0.0.1"
      "9.9.9.9"
      "1.1.1.1"
    ];
  };

  services.dnscrypt-proxy.settings = {
    # The Pi may not have working IPv6 connectivity; avoid selecting IPv6
    # DNSCrypt upstreams in that case.
    ipv6_servers = false;
  };

  systemd.network.wait-online.enable = false;

  users.users.root.hashedPassword = lib.mkForce "$y$j9T$rw1wMForHIg1XuK9HWnCD0$j.19g/PKjzKFPgEF/X2.lMOLIrXLfgGAQ9m9zz85Bc5";

  services.openssh = {
    # Open SSH on all interfaces. Password authentication is enabled globally
    # by system/openssh.nix.
    openFirewall = true;
    settings.PermitRootLogin = lib.mkForce "yes";

    # Avoid socket activation and the sshd@ sandbox entirely on this host.
    startWhenNeeded = lib.mkForce false;

    # One modern host key is enough.  Store it on /persist because /etc is
    # tmpfs; otherwise every reboot looks like a new server to SSH clients.
    hostKeys = lib.mkForce [
      {
        type = "ed25519";
        path = "/persist/system/etc/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  services.tailscale.enable = true;
}
