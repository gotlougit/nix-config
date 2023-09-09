{ ... }:

{
  # Enable syncthing to sync important files in background
  services.syncthing = {
    enable = true;
    user = "gotlou";
    group = "users";
    configDir = "/persist/sensitive/syncthing";
    dataDir = "/home/gotlou";
    openDefaultPorts = true;
  };
  # Enable vnstatd to monitor total net usage
  services.vnstat.enable = true;
  # Enable the OpenSSH daemon to act as SSH server
  services.openssh.enable = true;
  # Enable firmware updates
  services.fwupd.enable = true;
  # Enable AppArmor for more security
  security.apparmor.enable = true;
}
