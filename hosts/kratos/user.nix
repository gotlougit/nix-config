{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Change user name according to your preference

  users.mutableUsers = false;
  users.users.gotlou = {
    isNormalUser = true;
    home = "/home/gotlou";
    hashedPassword = "$y$j9T$rw1wMForHIg1XuK9HWnCD0$j.19g/PKjzKFPgEF/X2.lMOLIrXLfgGAQ9m9zz85Bc5";
    extraGroups = [ "wheel" "wireshark" "networkmanager" config.users.groups.keys.name "libvirtd" ];
    packages = with pkgs; [
      vlc
    ];
  };
  programs.steam.enable = true;
}
