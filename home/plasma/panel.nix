{ ... }: {

  # Selects holiday region for calendar
  xdg.configFile."plasma_calendar_holiday_regions".text = ''
    [General]
    selectedRegions=in_en-gb
  '';

  # Panel config
  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".text = ''
    [ActionPlugins][0]
    RightButton;NoModifier=org.kde.contextmenu
    wheel:Vertical;NoModifier=org.kde.switchdesktop

    [ActionPlugins][1]
    RightButton;NoModifier=org.kde.contextmenu

    [Containments][1]
    ItemGeometries-1920x1080=
    ItemGeometriesHorizontal=
    activityId=a90bd124-d21f-41ff-b3f8-64d92ce5f9e9
    formfactor=0
    immutability=1
    lastScreen=0
    location=0
    plugin=org.kde.plasma.folder
    wallpaperplugin=org.kde.image

    [Containments][1][ConfigDialog]
    DialogHeight=540
    DialogWidth=720

    [Containments][1][Configuration]
    PreloadWeight=26

    [Containments][1][General]
    ToolBoxButtonState=topcenter
    ToolBoxButtonX=557

    [Containments][1][Wallpaper][org.kde.image][General]
    Image=/home/gotlou/Pictures/wallpaper/Uncharted 4_ A Thief’s End™_20200113144917.png
    SlidePaths=/nix/store/65csdsq0r66kxv8x0lwp37nm2czddmwv-breeze-qt5-5.27.7-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/

    [Containments][2]
    activityId=
    formfactor=3
    immutability=1
    lastScreen=0
    location=5
    plugin=org.kde.panel
    wallpaperplugin=org.kde.image

    [Containments][2][Applets][20][Configuration]
    PreloadWeight=42

    [Containments][2][Applets][21]
    immutability=1
    plugin=org.kde.plasma.showdesktop

    [Containments][2][Applets][21][Configuration]
    PreloadWeight=26

    [Containments][2][Applets][21][Configuration][ConfigDialog]
    DialogHeight=1080
    DialogWidth=1882

    [Containments][2][Applets][3]
    immutability=1
    plugin=org.kde.plasma.kickoff

    [Containments][2][Applets][3][Configuration]
    PreloadWeight=100
    popupHeight=516
    popupWidth=655

    [Containments][2][Applets][3][Configuration][ConfigDialog]
    DialogHeight=1080
    DialogWidth=1882

    [Containments][2][Applets][3][Configuration][General]
    favoritesPortedToKAstats=true
    icon=nix-snowflake-white
    systemFavorites=suspend\\,hibernate\\,reboot\\,shutdown

    [Containments][2][Applets][3][Configuration][Shortcuts]
    global=Alt+F1

    [Containments][2][Applets][3][Shortcuts]
    global=Alt+F1

    [Containments][2][Applets][32]
    immutability=1
    plugin=org.kde.plasma.digitalclock

    [Containments][2][Applets][32][Configuration]
    PreloadWeight=65
    popupHeight=450
    popupWidth=525

    [Containments][2][Applets][32][Configuration][Appearance]
    autoFontAndSize=false
    enabledCalendarPlugins=holidaysevents
    fontFamily=Inter
    fontSize=12
    fontStyleName=Regular
    fontWeight=400
    showDate=false
    use24hFormat=2

    [Containments][2][Applets][32][Configuration][ConfigDialog]
    DialogHeight=1080
    DialogWidth=1879

    [Containments][2][Applets][4]
    immutability=1
    plugin=org.kde.plasma.pager

    [Containments][2][Applets][4][Configuration]
    PreloadWeight=34

    [Containments][2][Applets][5]
    immutability=1
    plugin=org.kde.plasma.icontasks

    [Containments][2][Applets][5][Configuration]
    PreloadWeight=34

    [Containments][2][Applets][5][Configuration][ConfigDialog]
    DialogHeight=1080
    DialogWidth=1882

    [Containments][2][Applets][5][Configuration][General]
    groupingStrategy=0
    launchers=
    showOnlyCurrentScreen=true

    [Containments][2][Applets][6]
    immutability=1
    plugin=org.kde.plasma.marginsseparator

    [Containments][2][Applets][6][Configuration]
    PreloadWeight=34

    [Containments][2][Applets][7]
    immutability=1
    plugin=org.kde.plasma.systemtray

    [Containments][2][Applets][7][Configuration]
    PreloadWeight=49
    SystrayContainmentId=8

    [Containments][2][ConfigDialog]
    DialogHeight=1080
    DialogWidth=157

    [Containments][2][Configuration]
    PreloadWeight=26

    [Containments][2][General]
    AppletOrder=3;4;5;6;7;32;21

    [Containments][29]
    activityId=a90bd124-d21f-41ff-b3f8-64d92ce5f9e9
    formfactor=0
    immutability=1
    lastScreen=1
    location=0
    plugin=org.kde.plasma.folder
    wallpaperplugin=org.kde.image

    [Containments][29][ConfigDialog]
    DialogHeight=540
    DialogWidth=720

    [Containments][29][Configuration]
    PreloadWeight=42

    [Containments][29][Wallpaper][org.kde.image][General]
    Image=/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129170335.png
    SlidePaths=/nix/store/kyzzdby4nr2ylgyw36j01v0m3iralxp6-breeze-qt5-5.27.8-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/

    [Containments][30][Applets][51][Configuration]
    PreloadWeight=76

    [Containments][8]
    activityId=
    formfactor=3
    immutability=1
    lastScreen=0
    location=5
    plugin=org.kde.plasma.private.systemtray
    popupHeight=432
    popupWidth=432
    wallpaperplugin=org.kde.image

    [Containments][8][Applets][10]
    immutability=1
    plugin=org.kde.plasma.devicenotifier

    [Containments][8][Applets][10][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][11]
    immutability=1
    plugin=org.kde.plasma.manage-inputmethod

    [Containments][8][Applets][11][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][12]
    immutability=1
    plugin=org.kde.plasma.notifications

    [Containments][8][Applets][12][Configuration]
    PreloadWeight=39

    [Containments][8][Applets][13]
    immutability=1
    plugin=org.kde.kdeconnect

    [Containments][8][Applets][13][Configuration]
    PreloadWeight=39

    [Containments][8][Applets][14]
    immutability=1
    plugin=org.kde.kscreen

    [Containments][8][Applets][14][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][15]
    immutability=1
    plugin=org.kde.plasma.keyboardindicator

    [Containments][8][Applets][15][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][16]
    immutability=1
    plugin=org.kde.plasma.keyboardlayout

    [Containments][8][Applets][16][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][17]
    immutability=1
    plugin=org.kde.plasma.printmanager

    [Containments][8][Applets][17][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][18]
    immutability=1
    plugin=org.kde.plasma.vault

    [Containments][8][Applets][18][Configuration]
    PreloadWeight=39

    [Containments][8][Applets][19]
    immutability=1
    plugin=org.kde.plasma.volume

    [Containments][8][Applets][19][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][19][Configuration][General]
    migrated=true

    [Containments][8][Applets][22]
    immutability=1
    plugin=org.kde.plasma.networkmanagement

    [Containments][8][Applets][22][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][23]
    immutability=1
    plugin=org.kde.plasma.bluetooth

    [Containments][8][Applets][23][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][24]
    immutability=1
    plugin=org.kde.plasma.nightcolorcontrol

    [Containments][8][Applets][24][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][25]
    immutability=1
    plugin=org.kde.plasma.battery

    [Containments][8][Applets][25][Configuration]
    PreloadWeight=34

    [Containments][8][Applets][30]
    immutability=1
    plugin=org.kde.plasma.cameraindicator

    [Containments][8][Applets][30][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][31]
    immutability=1
    plugin=org.kde.plasma.brightness

    [Containments][8][Applets][9]
    immutability=1
    plugin=org.kde.plasma.clipboard

    [Containments][8][Applets][9][Configuration]
    PreloadWeight=39

    [Containments][8][ConfigDialog]
    DialogHeight=1080
    DialogWidth=1879

    [Containments][8][Configuration]
    PreloadWeight=34

    [Containments][8][General]
    extraItems=org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kscreen,org.kde.plasma.bluetooth,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.cameraindicator,org.kde.plasma.brightness,org.kde.kdeconnect,org.kde.plasma.vault
    knownItems=org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kscreen,org.kde.plasma.bluetooth,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.cameraindicator,org.kde.plasma.brightness,org.kde.kdeconnect,org.kde.plasma.vault
    scaleIconsToFit=true

    [Containments2Appletsts][5][Configuration][General]
    groupingStrategy=0
    launchers=

    [ScreenMapping]
    itemsOnDisabledScreens=

  '';

}
