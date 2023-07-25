{ pkgs, config, lib, ... }:
{
  services.openssh.enable = true;
  services.tailscale.enable = true;
  networking.hostName = "pi";
  users = {
    users.gotlou = {
      password = "myPassword";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
