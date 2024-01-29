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
  # Use system76-scheduler to improve desktop experience
  services.system76-scheduler.enable = true;
}
