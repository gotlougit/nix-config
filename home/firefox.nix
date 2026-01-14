{ pkgs, ... }:
{
  home.packages = with pkgs; [ firefox ];
  home.file.".local/share/applications/firefox.desktop".source = ./firefox.desktop;
}
