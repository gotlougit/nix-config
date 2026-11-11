{
  imports = [
    ./base.nix
    ./configuration.nix
    ./expand.nix
    ./filesystems.nix
    ./impermanence.nix
    ./minimal.nix
    ./packages.nix
    ./services.nix

    # Shared system daemons and local frontends for this host.
    ../../system/mimir.nix
  ];
}
