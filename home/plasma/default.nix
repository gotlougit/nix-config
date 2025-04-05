{ lib, pkgs, ... }: {
  imports = [ ./display-scale.nix ./panel.nix ./plasma.nix ];

  # ref: https://github.com/nix-community/home-manager/issues/5098#issuecomment-2352172073
  xdg.configFile."menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  qt = {
    enable = true;
    platformTheme.package = with pkgs.kdePackages; [
      plasma-integration
      # I don't remember why I put this is here, maybe it fixes the theme of the system setttings
      systemsettings
    ];
    style = {
      package = pkgs.nordic;
      name = lib.mkForce "Breeze";
    };
  };
  systemd.user.sessionVariables = { QT_QPA_PLATFORMTHEME = lib.mkForce "kde"; };

  # Stores dolphin preferences
  home.file.".local/share/dolphin/dolphinstaterc".text = ''
    [State]
    1920x1080 screen: Window-Maximized=true
    State=AAAA/wAAAAD9AAAAAwAAAAAAAAEEAAAD8vwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAuAAAB5wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAuAAAD8gAAAF0BAAADAAAAAQAAALgAAAPy/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAC4AAAPyAAAACgEAAAMAAAADAAAHgAAAAL78AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAAAAAHgAAAAAoBAAADAAAGXQAAA/IAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA=
  '';

}
