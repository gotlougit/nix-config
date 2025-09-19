{ inputs, pkgs, ... }: {
  imports =
    [ ./ishmael-shell.nix ./helix.nix inputs.stylix.homeModules.stylix ];

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  home.stateVersion = "22.11";
}
