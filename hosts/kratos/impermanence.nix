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

  # Stuff that isn't too sensitive but is still not worth publishing publicly
  environment.persistence."/persist/dotfiles" = {
    directories = [
      # Tor Browser config
      "/home/gotlou/.local/share/tor-browser/TorBrowser"
      # Music info
      "/home/gotlou/.local/share/rhythmbox"
      # Mullvad Browser config
      "/home/gotlou/.mullvad"
    ];
    files = [ ];
  };

  # Games
  environment.persistence."/persist/gaming" = {
    directories = [
      # PS3 Emulator
      "/home/gotlou/.config/rpcs3"
      # PS2 Emulator
      "/home/gotlou/.config/PCSX2"
      # PS1 Emulator
      "/home/gotlou/.config/duckstation"
      # PS4 remote play client
      "/home/gotlou/.config/Chiaki"
    ];
    files = [ ];
  };

  # Data directories for communication live here
  environment.persistence."/persist/communication" = {
    directories = [
      # Email
      "/home/gotlou/.thunderbird"
      # Matrix
      "/home/gotlou/.cache/gomuks"
      "/home/gotlou/.config/gomuks"
      "/home/gotlou/.local/share/gomuks"
      # Signal
      "/home/gotlou/.config/Signal"
      # nchat (WhatsApp TUI client)
      "/home/gotlou/.nchat"
      # scli (Signal TUI client)
      "/home/gotlou/.local/share/scli"
      "/home/gotlou/.local/share/signal-cli"
      # Telegram
      "/home/gotlou/.local/share/TelegramDesktop"
    ];
    files = [ ];
  };

  # Any passwords or key data goes here  
  environment.persistence."/persist/sensitive" = {
    directories = [
      # GitHub
      "/home/gotlou/.config/gh"
      # SourceHut
      "/home/gotlou/.config/hut"
      # SSH
      "/home/gotlou/.config/sshield"
      "/home/gotlou/.ssh"
      # KDE Connect
      "/home/gotlou/.config/kdeconnect"
      # KWallet (mostly for Wi-Fi passwords)
      "/home/gotlou/.local/share/kwalletd"
      # Plasma Vault
      "/home/gotlou/.local/share/plasma-vault"
      # LeetCode Cookies
      "/home/gotlou/.leetcode"
      # Firefox
      "/home/gotlou/.mozilla"
    ];
    files = [ ];
  };

}
