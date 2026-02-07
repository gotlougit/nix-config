{ pkgs, inputs, ... }:
{
  imports = [
    # Import minimal config (shared between host and microvm)
    ./minimal.nix

    ./firefox.nix
    ./gaming.nix
    ./git.nix
    # ./conty
    ./keepassxc.nix
    ./otpclient.nix
    ./plasma
    ./shell.nix
    ./sshield.nix
    # ./tor-browser/default.nix
    ./tiny-irc.nix
    ./thunderbird.nix
    ./wezterm.nix
    # ./zed.nix
  ];

  home.packages = with pkgs; [
    # Miscellaneous programs I use
    inputs.code-sandbox.packages.${pkgs.stdenv.hostPlatform.system}.default # Installs sandboxes
    inputs.archiver.packages.${pkgs.stdenv.hostPlatform.system}.default # Installs archiving script
    # island # Sandboxing tool using Landlock

    gImageReader # OCR PDFs and images easily
    inkscape # Vector images
    krita # Raster image editor
    libreoffice-qt # Document editor
    mullvad-browser # Browser for private browsing
    qbittorrent # Best torrent client
    rhythmbox # Music player
    spotiflac
    songrec # Shazam on Linux
    signal-desktop # Secure and easy messaging
    telegram-desktop # Telegram desktop client
    fractal # Matrix client
    tor-browser # Needs no intro
    chromium # Keep around as backup browser
    nicotine-plus # Soulseek client
    # stremio-new
    # NOTE: etcher is insecure, but if needed can be gotten with:
    # `NIXPKGS_ALLOW_INSECURE=1 nix run github:nixos/nixpkgs/nixos-20.09#etcher --impure`
  ];

}
