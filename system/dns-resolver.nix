{ ... }: {
  # Disable resolved, we won't be using it
  services.resolved.enable = false;
  # dnscrypt-proxy2 specific config
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key =
          "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Ideally add one or two more here
      server_names = [
        "cloudflare"
        "mullvad-adblock-doh"
        "quad9-dnscrypt-ip4-nofilter-ecs-pri"
      ];
    };
  };
  systemd.services.dnscrypt-proxy2 = {
    enable = true;
    serviceConfig = { InaccessiblePaths = [ "/persist" ]; };
  };
}
