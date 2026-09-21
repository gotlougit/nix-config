{
  imports = [
    # Self hosted services
    ./cyberchef.nix
    ./hister.nix
    ./kittygram.nix
    ./nitter.nix
    ./redlib.nix
    ./tokidoki.nix

    # System services
    ./bluetooth.nix
    ./colord.nix
    ./dns-resolver.nix
    ./flatpak.nix
    ./keyd.nix
    ./networking.nix
    ./nix.nix
    ./oom.nix
    ./openssh.nix
    ./standard-services.nix
    ./style.nix
    ./sudo.nix
    ./syncthing.nix
    ./time.nix
    ./udev.nix
    ./virt.nix
    ./zram.nix

    # Experimental services
    ./omega.nix
  ];
}
