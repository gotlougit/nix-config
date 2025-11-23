{ pkgs, inputs, ... }: {
  imports = [
    inputs.stylix.homeModules.stylix
    ./home-manager-gc.nix
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
    inputs.code-sandbox.packages.x86_64-linux.default # Installs sandboxes
    inputs.archiver.packages.x86_64-linux.default # Installs archiving script
    # ghidra # Decompiler
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
    stremio-new # Streaming app
    nicotine-plus # Soulseek client

    # LLM software
  
    # llama-cpp # Run local LLMs efficiently on CPU/GPU
    opencode # Open source model agnostic CLI agent
    vamp-cli # Sourcegraph's CLI coding agent (local server)
    claude-code # Claude in the terminal
    gemini-cli # Gemini in the terminal
    codex # ChatGPT in the terminal
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
