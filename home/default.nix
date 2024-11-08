{ pkgs, inputs, ... }: {
  imports = [
    ./firefox.nix
    ./gaming.nix
    ./git.nix
    ./helix.nix
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
    ./zed.nix
  ];

  home.packages = with pkgs; [
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
    rhythmbox # Music player
    songrec # Shazam on Linux
    signal-desktop # Secure and easy messaging
    tdesktop # Telegram desktop client
    tor-browser-bundle-bin # Needs no intro
    aider-chat # AI helper for coding
    # llama-cpp # Run local LLMs efficiently on CPU/GPU
    chromium # Keep around as backup browser
  ];

  manual.manpages.enable = false;
  home.stateVersion = "22.11";
}
