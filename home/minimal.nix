{ pkgs, inputs, ... }:
{
  # Minimal home configuration suitable for both host and microvm
  # Excludes GUI-specific modules (plasma, firefox, gaming, etc.)
  imports = [
    inputs.stylix.homeModules.stylix
    ./home-manager-gc.nix
    ./dev.nix
    ./shell-shared.nix
  ];


  stylix.enable = true;
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

  manual.manpages.enable = false;
  home.stateVersion = "22.11";
}
