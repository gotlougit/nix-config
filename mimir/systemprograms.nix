{ pkgs, ...}:
{
  imports = [
  ];
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    tealdeer # Rust implementation of tldr
    aria # download manager
    bandwhich # view what programs are making network requests
    compsize # View btrfs compression info
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
    neofetch # Nice startup screen for terminal
    parallel # Parallelize many shell commands
    rustscan # Faster replacement for nmap
    syncthing # Sync all files
    socat # Socket cat
    sqlite # No intro needed
    tailscale # Create a mesh network
    tetex # LaTEX related tooling
    tor # The Onion Router
    unrar # Useful for decompressing
    vnstat # View total data usage
    wget # Another, simpler download manager
    whois # Useful utility
    yt-dlp # Useful video download utility

    # Rust replacements
    bat # cat
    difftastic # diff
    skim # fzf
    hexyl # hexdump
    exa # ls
    ripgrep # grep

  ];

}
