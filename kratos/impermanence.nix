{ inputs, ...}:
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
    files = [
    ];
  };
  environment.persistence."/persist/dotfiles" = {
    directories = [
      "/home/gotlou/.config/Chiaki"
      "/home/gotlou/.config/gh"
      "/home/gotlou/.config/hut"
      "/home/gotlou/.config/nvim"
      "/home/gotlou/.config/neofetch"
      "/home/gotlou/.config/syncthing"
      "/home/gotlou/.config/rpcs3"
      "/home/gotlou/.config/PCSX2"
      "/home/gotlou/.config/sshield"
      "/home/gotlou/.config/kdeconnect"
      "/home/gotlou/.pcsxr"
      "/home/gotlou/.ssh"
      "/home/gotlou/.leetcode"
      "/home/gotlou/.local/share/kwalletd"
      "/home/gotlou/.local/share/tor-browser/TorBrowser"
      "/home/gotlou/.local/share/dolphin"
      "/home/gotlou/.local/share/rhythmbox"
      "/home/gotlou/.local/share/plasma-vault"
      "/home/gotlou/.mullvad"
      "/home/gotlou/.mozilla"
      "/home/gotlou/.thunderbird"
      "/home/gotlou/.config/Signal"
      "/home/gotlou/.config/helix"
      "/home/gotlou/.config/lazygit"
    ];
    files = [ 
      "/home/gotlou/.gitconfig" 
      "/home/gotlou/.globalgitignore" 
    ];
  };

  # Persist path for nix-direnv
  environment.pathsToLink = [
    "/persist/nix-direnv"
  ];

}
