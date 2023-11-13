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
  # Enable AppArmor for more security
  security.apparmor.enable = true;
}
