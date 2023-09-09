{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  # Files and folders that are saved by Impermanence from deletion
  # Symlinks will be created automatically at boot
  environment.persistence."/persist/system" = {
    directories = [
      "/etc/NetworkManager"
      "/var/log/cloudflare-warp"
      "/var/log/libvirt"
      "/var/log/private"
      "/var/lib"
    ];
    files = [ ];
  };
  environment.persistence."/persist/dotfiles" = {
    directories = [
      "/home/gotlou/.local/share/tor-browser/TorBrowser"
      "/home/gotlou/.local/share/rhythmbox"
      "/home/gotlou/.mullvad"
    ];
    files = [ ];
  };

  # Games
  environment.persistence."/persist/gaming" = {
    directories = [
      "/home/gotlou/.config/rpcs3"
      "/home/gotlou/.config/PCSX2"
      "/home/gotlou/.config/duckstation"
      "/home/gotlou/.config/Chiaki"
    ];
    files = [ ];
  };

  # Data directories for communication live here
  environment.persistence."/persist/communication" = {
    directories = [
      "/home/gotlou/.thunderbird"
      "/home/gotlou/.config/gomuks"
      "/home/gotlou/.local/share/gomuks"
      "/home/gotlou/.config/Signal"
    ];
    files = [ ];
  };

  # Any passwords or key data goes here  
  environment.persistence."/persist/sensitive" = {
    directories = [
      "/home/gotlou/.config/gh"
      "/home/gotlou/.config/hut"
      "/home/gotlou/.config/sshield"
      "/home/gotlou/.ssh"
      "/home/gotlou/.config/kdeconnect"
      "/home/gotlou/.local/share/kwalletd"
      "/home/gotlou/.local/share/plasma-vault"
      "/home/gotlou/.leetcode"
      "/home/gotlou/.mozilla"
    ];
    files = [ ];
  };

}
