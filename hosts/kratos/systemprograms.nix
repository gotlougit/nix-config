{ pkgs, ... }:
{
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    gparted # *The* GUI for partitioning drives
    steam-run # Create traditional FHS for non-Nix packaged software to run in
    neovim # Classic editor around as a backup
    tealdeer # Rust implementation of tldr
    apparmor-profiles # Enable AppArmor in NixOS
    age # A sane encrytion/decryption tool made for mortals
    android-tools # adb, fastboot etc
    aria # download manager
    aspell # CLI spell check
    bandwhich # view what programs are making network requests
    bear # Generate autocomplete for large projects
    blesh # Bash made smarter
    curl # no intro needed
    dig # for DNS testing
    direnv # Effortless dev environment setup
    cloudflare-warp # A good quality VPN
    file # To show type of file
    fd # Fast `file` replacement
    ffmpeg # Multimedia Swiss Army Knife
    gocryptfs # For plasma-vault
    gh # Github CLI
    htop # Classic system monitoring tool
    hut # Sourcehut CLI
    helix # New Rust-based modal editor
    img2pdf # Useful utility
    jq # JSON manipulator
    libsForQt5.kdeconnect-kde # KDE Connect
    lm_sensors # For temperatures and fan speeds
    man-pages # Add more man pages
    man-pages-posix # Provide more man docs for syscalls etc
    meek # Pluggable transport for tor
    macchina # Nice startup screen for terminal
    nftables # Modern firewall program
    nix-direnv # Direnv + Nix
    nmap # Classic network exploration utility
    opensnitch # Application firewall
    opensnitch-ui # Application firewall UI
    obfs4 # Pluggable transport for tor
    parallel # Parallelize many shell commands
    pandoc # Convert docs
    picard # Tag music files
    poppler_utils # PDF conversion and misc utils
    plasma-vault # Encrypted folders in KDE
    pinentry # Enter gpg password securely
    radeontop # AMD GPU monitoring
    syncthing # Sync all files
    snowflake # Pluggable transport for tor
    socat # Socket cat
    sqlite # No intro needed
    sequoia-sq # Rust reimplementation of OpenPGP
    sequoia-sqv # Rust reimplementation to verify OpenPGP signatures
    sequoia-chameleon-gnupg # Sequoia based drop-in gpg replacement
    tailscale # Create a mesh network
    tetex # LaTEX related tooling
    tor # The Onion Router
    unrar # Useful for decompressing
    unzip # Useful for decompressing ZIP files
    virt-manager # Easy KVM based VMs
    vnstat # View total data usage
    vulkan-tools # Manage vulkan
    wget # Another, simpler download manager
    whois # Useful utility
    wireshark # View real time network traffic across multiple interfaces
    wireguard-tools # Use kernel Wireguard
    yt-dlp # Useful video download utility
    zip # Create ZIP files from CLI

    # Rust replacements
    bat # cat
    difftastic # diff
    skim # fzf
    hexyl # hexdump
    eza # ls
    ripgrep # grep
    loc # cloc
  ];

  # Additional config for skim
  programs.skim = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  # Additional config for direnv to use nix-direnv and allow caching
  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    # persistDerivations = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # Allow KDE connect through firewall
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];

}
