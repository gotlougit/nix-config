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
  home.file.".config/dolphinrc".text = ''
    [$Version]
    update_info=dolphin_detailsmodesettings.upd:rename-leading-padding,dolphin_detailsmodesettings.upd:move-content-display

    [General][$i]
    EditableUrl[$i]=true
    EditableUrl\x5b$i\x5d[$i]=true
    EditableUrlx5b$ix5d[$i]=true
    RememberOpenedTabs[$i]=false
    RememberOpenedTabs\x5b$i\x5d[$i]=false
    RememberOpenedTabsx5b$ix5d[$i]=false
    Version[$i]=202
    Version\x5b$i\x5d[$i]=202
    Versionx5b$ix5d[$i]=202
    ViewPropsTimestamp[$i]=2023,10,4,17,14,27.119
    ViewPropsTimestamp\x5b$i\x5d[$i]=2023,10,4,17,14,27.119
    ViewPropsTimestampx5b$ix5d[$i]=2023,10,4,17,14,27.119

    [General.$i]
    EditableUrl[$i]=true
    EditableUrl\x5b$i\x5d=true
    EditableUrlx5b$ix5d=true
    RememberOpenedTabs[$i]=false
    RememberOpenedTabs\x5b$i\x5d=false
    RememberOpenedTabsx5b$ix5d=false
    Version[$i]=202
    Version\x5b$i\x5d=202
    Versionx5b$ix5d=202
    ViewPropsTimestamp[$i]=2023,10,4,17,14,27.119
    ViewPropsTimestamp\x5b$i\x5d=2023,10,4,17,14,27.119
    ViewPropsTimestampx5b$ix5d=2023,10,4,17,14,27.119

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [KPropertiesDialog]
    1920x1080 screen: Window-Maximized=true
    2 screens: Height=532
    2 screens: Width=462
    2 screens: Window-Maximized=true

    [MainWindow]
    MenuBar=Disabled

    [PreviewSettings]
    Plugins=audiothumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,blenderthumbnail,mobithumbnail,ffmpegthumbs,rawthumbnail,gsthumbnail,directorythumbnail

    [Search]
    Location=Everywhere
  '';

}
