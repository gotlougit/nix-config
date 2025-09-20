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
      name = "Noto";
      package = pkgs.noto-fonts;
    };
    serif = sansSerif;
    sizes.applications = 10;
  };
  stylix.cursor = {
    size = 32;
    name = "macOS-Monterey";
    package = pkgs.apple-cursor;
  };
  environment.systemPackages = with pkgs; [
    # Icon packs
    papirus-icon-theme
    adwaita-icon-theme
  ];
}
