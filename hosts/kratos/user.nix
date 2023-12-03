{ config, inputs, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Change user name according to your preference

  users.mutableUsers = false;
  users.users.gotlou = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$rw1wMForHIg1XuK9HWnCD0$j.19g/PKjzKFPgEF/X2.lMOLIrXLfgGAQ9m9zz85Bc5";
    extraGroups = [ "wheel" "wireshark" "networkmanager" config.users.groups.keys.name "libvirtd" ];
    # TODO: make this even more comprehensive
    # Add whatever you want
    # I mainly add GUI programs in here
    packages = with pkgs; [
      inputs.code-sandbox.packages.x86_64-linux.default # Installs sandboxes
      inputs.archiver.packages.x86_64-linux.default # Installs archiving script
      inputs.sshield.packages.x86_64-linux.default # Installs sshield
      firefox # Just plain Firefox
      thunderbird # Email client
      ark # KDE archiving program
      bottles # Easily manage Wine prefixes
      cemu # Wii U emulator
      chiaki # PS4 Remote Play client
      discordo # CLI Discord client
      dolphin-emu # GameCube and Wii emulator
      filelight # View disk usage in pie chart form
      frida-tools # For Android reverse engineering
      ghidra # Decompiler
      gImageReader # OCR PDFs and images easily
      guerrilla
      gomuks # CLI Matrix client
      inkscape # Vector images
      krita # Raster image editor
      keepassxc # Password manager
      libreoffice-qt # Document editor
      libsForQt5.ksshaskpass # Ask password in GUI from CLI
      magit # Advanced git UI using emacs
      mangohud # Overlay while playing games
      minetest # Open source Minecraft-like game
      mullvad-browser # Browser for private browsing
      otpclient # TOTP client
      duckstation # PS1 emulator
      pcsx2 # PS2 emulator
      qbittorrent # Best torrent client
      rpcs3 # PS3 emulator
      rhythmbox # Preferred music player
      songrec # Shazam on Linux
      signal-desktop # Secure and easy messaging
      scli # Secure and easy messaging on command line
      steam # Cross platform games store
      tdesktop # Telegram desktop client
      tor-browser-bundle-bin # Needs no intro
      vlc # Easiest media player
      wl-clipboard # CLI util for copying and pasting in Wayland
      xemu # Original Xbox emulator
    ];
  };
  programs.steam.enable = true;
}
