{ ... }:

{
  # Just to be safe, we disable default systemd-timesyncd
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [ "time.cloudflare.com" "nts.netnod.se" ];
  };
  systemd.services.chronyd.serviceConfig = {
    InaccessiblePaths = "/persist";
  };
}
