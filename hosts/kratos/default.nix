{
  imports = [
    ./impermanence.nix
    ./hardware-configuration.nix
    ./boot.nix
    ./configuration.nix
    ./user.nix
    ./systemprograms.nix
    ./zfs.nix
    ./services/desktop.nix
    ./services/sound.nix
    ./services/tailscale.nix
  ];
}
