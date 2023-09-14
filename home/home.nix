{ ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./keepassxc.nix
    ./macchina.nix
    ./otpclient.nix
    ./plasma/plasma.nix
    ./scli.nix
    ./starship.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
