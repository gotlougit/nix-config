{ ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./keepassxc.nix
    ./macchina.nix
    ./plasma/plasma.nix
    ./scli.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
