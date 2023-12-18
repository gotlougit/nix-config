{ inputs, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix.image = ../home/wallpaper.png;
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
