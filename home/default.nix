{ ... }:
{
  imports = [
    ./direnv.nix
    ./easyeffects.nix
    ./firefox.nix
    ./git.nix
    ./helix.nix
    ./htop.nix
    ./keepassxc.nix
    ./macchina.nix
    ./okular.nix
    ./otpclient.nix
    ./plasma/plasma.nix
    ./scli.nix
    ./shell.nix
    ./sshield.nix
    # ./tor-browser/default.nix
    ./thunderbird.nix
    ./vlc.nix
    ./wezterm.nix
  ];
  home.stateVersion = "22.11";
}
