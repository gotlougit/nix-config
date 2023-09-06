{ ... }:
{
  imports = [
    ./git.nix
    ./helix.nix
    ./plasma.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
