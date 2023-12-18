{ config, pkgs, ... }:

{
  stylix.image = config.lib.file.mkOutOfStoreSymlink "/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129110216.png";
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  stylix.fonts = rec {
    monospace = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
    sansSerif = {
      name = "Inter";
      package = pkgs.inter;
    };
    serif = sansSerif;
    sizes.applications = 10;
  };
  stylix.cursor = {
    name = "macOS-Monterey";
    package = pkgs.apple-cursor;
  };
}
