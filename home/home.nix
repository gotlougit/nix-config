{ ... }:
{
  imports = [
    ./direnv.nix
    ./firefox.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./keepassxc.nix
    ./macchina.nix
    ./otpclient.nix
    ./plasma/plasma.nix
    ./scli.nix
    ./shell.nix
    ./sshield.nix
    ./thunderbird.nix
    # ./tor-browser/default.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
