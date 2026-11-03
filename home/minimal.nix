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
  # Home Manager uses the global NixOS pkgs (useGlobalPkgs = true), so it
  # cannot define nixpkgs.overlays. Stylix must not apply its overlays from
  # the Home Manager side.
  stylix.overlays.enable = false;
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
