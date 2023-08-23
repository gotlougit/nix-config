{ pkgs, ...}:
{
  imports = [
  ];
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    bubblewrap # Tried and tested user namespace based sandboxes
    slirp4netns # Create userspace networking device
    gparted # *The* GUI for partitioning drives
    steam-run # Create traditional FHS for non-Nix packaged software to run in
    neovim # Classic editor around as a backup
    tealdeer # Rust implementation of tldr
    apparmor-profiles # Enable AppArmor in NixOS
    android-tools # adb, fastboot etc
    aria # download manager
    aspell # CLI spell check
    bandwhich # view what programs are making network requests
    bear # Generate autocomplete for large projects
    blesh # Bash made smarter
    cargo-rr # rr + cargo
    compsize # View btrfs compression info
    curl # no intro needed
    dig # for DNS testing
    direnv # Effortless dev environment setup
    cloudflare-warp # A good quality VPN
    file # To show type of file
    ffmpeg # Multimedia Swiss Army Knife
    gocryptfs # For plasma-vault
    gh # Github CLI
    gdb # Underrated development tool
    gitFull # For git-send-email
    gnupg # Manage PGP keys
    htop # Classic system monitoring tool
    hut # Sourcehut CLI
    helix # New Rust-based modal editor
    hspell # Spelling utility
    img2pdf # Useful utility
    jq # JSON manipulator
    lazygit # Nice wrapper around git to maintain sanity
    libsForQt5.kdeconnect-kde # KDE Connect
    lm_sensors # For temperatures and fan speeds
    man-pages # Add more man pages
    man-pages-posix # Provide more man docs for syscalls etc
    meek # Pluggable transport for tor
    neofetch # Nice startup screen for terminal
    nix-direnv # Direnv + Nix
    opensnitch # Application firewall
    opensnitch-ui # Application firewall UI
    obfs4 # Pluggable transport for tor
    parallel # Parallelize many shell commands
    pandoc # Convert docs
    picard # Tag music files
    poppler_utils # PDF conversion and misc utils
    plasma-vault # Encrypted folders in KDE
    pinentry # Enter gpg password securely
    postgresql_15 # Database
    rr # Record and replay while debugging
    rustscan # Faster replacement for nmap
    radeontop # AMD GPU monitoring
    syncthing # Sync all files
    snowflake # Pluggable transport for tor
    socat # Socket cat
    sqlite # No intro needed
    tailscale # Create a mesh network
    tetex # LaTEX related tooling
    trash-cli # Send file to trash instead of permanently deleting
    tor # The Onion Router
    unrar # Useful for decompressing
    virt-manager # Easy KVM based VMs
    vnstat # View total data usage
    vulkan-tools # Manage vulkan
    wget # Another, simpler download manager
    winePackages.stagingFull # Latest Wine to run Windows programs
    whois # Useful utility
    wireshark # View real time network traffic across multiple interfaces
    wireguard-tools # Use kernel Wireguard
    yt-dlp # Useful video download utility

    # Rust replacements
    bat # cat
    difftastic # diff
    skim # fzf
    hexyl # hexdump
    exa # ls
    ripgrep # grep
    loc # cloc
    rm-improved # rm
  ];

  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    persistDerivations = true;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
}
