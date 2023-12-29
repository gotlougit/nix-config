{ pkgs, ... }:
{
  home.packages = with pkgs; [ thunderbird ];
  home.file.".local/share/applications/thunderbird.desktop".source = ./thunderbird.desktop;
}
