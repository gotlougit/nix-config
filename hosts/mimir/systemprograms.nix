{ pkgs, ... }: {
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    tealdeer # Rust implementation of tldr
    direnv
    aria # download manager
    curl # no intro needed
    dig # for DNS testing
    file # To show type of file
    gitFull # For git-send-email
    htop
    helix # New Rust-based modal editor
    jq # JSON manipulator
    lm_sensors # For temperatures and fan speeds
    man-pages
    man-pages-posix # Provide more man docs for syscalls etc
    macchina # Nice startup screen for terminal
    parallel # Parallelize many shell commands
    rustscan # Faster replacement for nmap
    tailscale # Create a mesh network
    tor # The Onion Router
    unrar # Useful for decompressing
    vnstat # View total data usage
    wget # Another, simpler download manager
    yt-dlp # Useful video download utility

    # Rust replacements
    bat # cat
    difftastic # diff
    skim # fzf
    hexyl # hexdump
    eza # ls
    ripgrep # grep
    rm-improved # rm
  ];

}
