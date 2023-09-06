{ ... }:
{
  imports = [
    ./git.nix
    ./helix.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
