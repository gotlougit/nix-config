{ ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./plasma.nix
    ./scli.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
