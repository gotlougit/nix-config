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
      # Themes and Icon packs
      # nordic
      papirus-icon-theme
      gnome.adwaita-icon-theme
      firefox # Just plain Firefox
      thunderbird # Email client
      ark # KDE archiving program
      bottles # Easily manage Wine prefixes
      cemu # Wii U emulator
      chiaki # PS4 Remote Play client
      dolphin-emu # GameCube and Wii emulator
      ghidra # Decompiler
      gImageReader # OCR PDFs and images easily
      guerrilla
      gomuks # CLI Matrix client
      inkscape # Vector images
      krita # Raster image editor
      keepassxc # Password manager
      libreoffice-qt # Document editor
      libsForQt5.ksshaskpass # Ask password in GUI from CLI
      (libsForQt5.bismuth.overrideAttrs
        (finalAttrs: previousAttrs: {
          patches =
            (previousAttrs.patches or [ ])
            ++ [
              (fetchpatch {
                name = "bismuth-3.1-4-window-id.patch";
                url = "https://github.com/jkcdarunday/bismuth/commit/ce377a33232b7eac80e7d99cb795962a057643ae.patch";
                sha256 = "sha256-15txf7pRhIvqsrBdBQOH1JDQGim2Kh5kifxQzVs5Zm0=";
              })
            ];
        }))
      magit # Advanced git UI using emacs
      mangohud # Overlay while playing games
      minetest # Open source Minecraft-like game
      mullvad-browser # Browser for private browsing
      otpclient # TOTP client
      duckstation # PS1 emulator
      pcsx2 # PS2 emulator
      qbittorrent # Best torrent client
      rpcs3 # PS3 emulator
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
