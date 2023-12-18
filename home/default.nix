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
    ./otpclient.nix
    ./plasma
    ./scli.nix
    ./shell.nix
    ./sshield.nix
    ./stylix.nix
    # ./tor-browser/default.nix
    ./tiny-irc.nix
    ./thunderbird.nix
    ./wezterm.nix
  ];
  manual.manpages.enable = false;
  home.stateVersion = "22.11";
}
