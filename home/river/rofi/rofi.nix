{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./tokyo.rasi;
    package = pkgs.rofi-wayland;
  };
}
