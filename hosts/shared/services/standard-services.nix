{ ... }:

{
  # Enable vnstatd to monitor total net usage
  services.vnstat.enable = true;
  # Enable the OpenSSH daemon to act as SSH server
  services.openssh.enable = true;
  # Enable firmware updates
  services.fwupd.enable = true;
  # Enable AppArmor for more security
  security.apparmor.enable = true;
}
