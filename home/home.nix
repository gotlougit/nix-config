{ ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./macchina.nix
    ./plasma.nix
    ./river.nix
    ./scli.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
