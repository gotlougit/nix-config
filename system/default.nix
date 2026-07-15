{
  imports = [
    # Self hosted services
    ./hister.nix
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
    ./warp.nix
    ./zram.nix

    # Experimental services
    ./lightpanda.nix
  ];
}
