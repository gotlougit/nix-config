{ pkgs, ... }:
{
  imports = [
    ./rofi/rofi.nix
    ./waybar/waybar.nix
    ./notifs/dunst.nix
  ];
  # Install river
  home.packages = with pkgs; [ river pamixer comic-mono jetbrains-mono font-awesome dejavu_fonts ];

  # Create the shell script containing our river config
  home.file.".config/river/init" = {
    executable = true;
    source = ./init;
  };
}
