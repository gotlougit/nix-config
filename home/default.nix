{ pkgs, inputs, ... }: {
  imports = [
    inputs.stylix.homeModules.stylix
    ./home-manager-gc.nix
    ./dev.nix
    ./firefox.nix
    ./gaming.nix
    # ./conty
    ./git.nix
    ./helix.nix
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
    inputs.code-sandbox.packages.${pkgs.system}.default # Installs sandboxes
    inputs.archiver.packages.${pkgs.system}.default # Installs archiving script
    gImageReader # OCR PDFs and images easily
    inkscape # Vector images
    krita # Raster image editor
    libreoffice-qt # Document editor
    mullvad-browser # Browser for private browsing
    qbittorrent # Best torrent client
    rhythmbox # Music player
    songrec # Shazam on Linux
    signal-desktop # Secure and easy messaging
    telegram-desktop # Telegram desktop client
    tor-browser # Needs no intro
    chromium # Keep around as backup browser
    nicotine-plus # Soulseek client
    # stremio-new
  ];

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  stylix.fonts = rec {
    monospace = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
    sansSerif = {
      name = "Noto";
      package = pkgs.noto-fonts;
    };
    serif = sansSerif;
    sizes.applications = 10;
  };

  manual.manpages.enable = false;
  home.stateVersion = "22.11";
}
