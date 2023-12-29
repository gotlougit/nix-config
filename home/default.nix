{ pkgs, inputs, ... }:
{
  imports = [
    ./easyeffects.nix
    ./firefox.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./keepassxc.nix
    ./otpclient.nix
    ./plasma
    ./scli.nix
    ./shell.nix
    ./sshield.nix
    # ./tor-browser/default.nix
    ./tiny-irc.nix
    ./thunderbird.nix
    ./wezterm.nix
  ];

  home.packages = with pkgs; [
    # Gaming stuff
    bottles # Easily manage Wine prefixes
    cemu # Wii U emulator
    chiaki # PS4 Remote Play client
    dolphin-emu # GameCube and Wii emulator
    duckstation # PS1 emulator
    pcsx2 # PS2 emulator
    rpcs3 # PS3 emulator
    xemu # Original Xbox emulator
    minetest # Open source Minecraft-like game
    mangohud # Overlay while playing games

    # Miscellaneous programs I use
    inputs.code-sandbox.packages.x86_64-linux.default # Installs sandboxes
    inputs.archiver.packages.x86_64-linux.default # Installs archiving script
    ghidra # Decompiler
    gImageReader # OCR PDFs and images easily
    gomuks # CLI Matrix client
    inkscape # Vector images
    krita # Raster image editor
    libreoffice-qt # Document editor
    mullvad-browser # Browser for private browsing
    qbittorrent # Best torrent client
    songrec # Shazam on Linux
    signal-desktop # Secure and easy messaging
    tdesktop # Telegram desktop client
    tor-browser-bundle-bin # Needs no intro
  ];

  manual.manpages.enable = false;
  home.stateVersion = "22.11";
}
