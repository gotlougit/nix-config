{ ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./plasma.nix
    ./scli.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
