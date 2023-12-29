{ pkgs, ... }:
{
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    gparted # *The* GUI for partitioning drives
    steam-run # Create traditional FHS for non-Nix packaged software to run in
    neovim # Classic editor around as a backup
    helix # New Rust-based modal editor
    android-tools # adb, fastboot etc
    bandwhich # view what programs are making network requests
    curl # no intro needed
    lm_sensors # For temperatures and fan speeds
    man-pages # Add more man pages
    man-pages-posix # Provide more man docs for syscalls etc
    nmap # Classic network exploration utility
    parallel # Parallelize many shell commands
    pinentry # Enter gpg password securely
    radeontop # AMD GPU monitoring
    # sequoia-sq # Rust reimplementation of OpenPGP
    # sequoia-sqv # Rust reimplementation to verify OpenPGP signatures
    # sequoia-chameleon-gnupg # Sequoia based drop-in gpg replacement
    vnstat # View total data usage
    vulkan-tools # Manage vulkan
    wireshark # View real time network traffic across multiple interfaces
    wireguard-tools # Use kernel Wireguard
  ];

}
