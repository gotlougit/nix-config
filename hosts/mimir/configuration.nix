{ pkgs, config, lib, ... }:
{
  time.timeZone = "Asia/Kolkata";
  services.openssh.enable = true;
  services.tailscale.enable = true;
  networking.hostName = "mimir";
  users = {
    users.gotlou = {
      password = "myPassword";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}