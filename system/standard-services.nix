{ ... }:

{
  # Enable vnstatd to monitor total net usage
  services.vnstat.enable = true;
  systemd.services.vnstat = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
  # Enable firmware updates
  services.fwupd.enable = true;
  # Use irqbalance to help handle system being laggy during high load
  services.irqbalance.enable = true;
}
