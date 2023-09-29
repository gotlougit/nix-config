{ config, ... }:

{

  imports = [
    ./display-scale.nix
    ./panel.nix
  ];

  # Import the dynamic workspaces plugin used for kwin
  # TODO: make this more declarative and less dependent on my specific path
  home.file.".local/share/kwin/scripts/dynamic_workspaces" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/gotlou/nixos/dotfiles/dynamic_workspaces;
    recursive = true;
  };

  # Stores dolphin preferences
  home.file.".local/share/dolphin/dolphinstaterc".text = ''
    [State]
    1920x1080 screen: Window-Maximized=true
    State=AAAA/wAAAAD9AAAAAwAAAAAAAAEEAAAD8vwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAuAAAB5wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAuAAAD8gAAAF0BAAADAAAAAQAAALgAAAPy/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAC4AAAPyAAAACgEAAAMAAAADAAAHgAAAAL78AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAAAAAHgAAAAAoBAAADAAAGXQAAA/IAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA=
  '';

  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-a90bd124-d21f-41ff-b3f8-64d92ce5f9e9" = [ ];
      "kwin"."AutotileFocusAbove" = [ ];
      "kwin"."AutotileFocusBelow" = [ ];
      "kwin"."AutotileFocusLeft" = [ ];
      "kwin"."AutotileFocusRight" = [ ];
      "kwin"."AutotileInsertAbove" = [ ];
      "kwin"."AutotileInsertBelow" = [ ];
      "kwin"."AutotileInsertLeft" = [ ];
      "kwin"."AutotileInsertRight" = [ ];
      "kwin"."AutotileRetileWindow" = [ ];
      "kwin"."AutotileSwapAbove" = [ ];
      "kwin"."AutotileSwapBelow" = [ ];
      "kwin"."AutotileSwapLeft" = [ ];
      "kwin"."AutotileSwapRight" = [ ];
      "kwin"."FlexGridMoveDown" = [ ];
      "kwin"."FlexGridMoveLeft" = [ ];
      "kwin"."FlexGridMoveRight" = [ ];
      "kwin"."FlexGridMoveUp" = [ ];
      "kwin"."FlexGridNextLayout" = "Meta+Ctrl+Right";
      "kwin"."FlexGridPreviousLayout" = "Meta+Ctrl+Left";
      "kwin"."FlexGridUntile" = [ ];
      "kwin"."Invert Screen Colors" = [ ];
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."Window to Next Desktop" = "Ctrl+Alt+Right";
      "kwin"."Window to Previous Desktop" = "Ctrl+Alt+Left";
      "mediacontrol"."mediavolumedown" = [ ];
      "mediacontrol"."mediavolumeup" = [ ];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [ ];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org.kde.konsole.desktop"."_launch" = [ ];
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.wezfurlong.wezterm.desktop"."_launch" = "Ctrl+Alt+T";
    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found";
      "baloofilerc"."General"."exclude folders[$e]" = "$HOME/";
      "baloofilerc"."General"."folders[$e]" = "$HOME/Documents/College/,$HOME/Documents/Documentation/";
      "baloofilerc"."General"."only basic indexing" = true;
      "dolphinrc"."General"."EditableUrl" = true;
      "dolphinrc"."General"."RememberOpenedTabs" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."PreviewSettings"."Plugins" = "audiothumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,blenderthumbnail,mobithumbnail,ffmpegthumbs,rawthumbnail,gsthumbnail,directorythumbnail";
      "kactivitymanagerdrc"."activities"."a90bd124-d21f-41ff-b3f8-64d92ce5f9e9" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "a90bd124-d21f-41ff-b3f8-64d92ce5f9e9";
      "kcminputrc"."Libinput.2.14.ETPS/2 Elantech Touchpad"."TapToClick" = true;
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 2;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "995,598";
      "kdeglobals"."General"."BrowserApplication" = "mullvadbrowser-sandbox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "wezterm start --cwd .";
      "kdeglobals"."General"."TerminalService" = "org.wezfurlong.wezterm.desktop";
      "kdeglobals"."Icons"."Theme" = "Papirus-Dark";
      "kdeglobals"."KDE"."LookAndFeelPackage" = "com.github.varlesh.arc-dark";
      "kdeglobals"."KDE"."SingleClick" = false;
      "kdeglobals"."KDE"."widgetStyle" = "Breeze";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = false;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Date";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = true;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 138;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."KShortcutsDialog Settings"."Dialog Size" = "600,480";
      "kdeglobals"."PreviewSettings"."MaximumRemoteSize" = 0;
      "kdeglobals"."WM"."activeBackground" = "47,52,63";
      "kdeglobals"."WM"."activeBlend" = "47,52,63";
      "kdeglobals"."WM"."activeForeground" = "211,218,227";
      "kdeglobals"."WM"."inactiveBackground" = "47,52,63";
      "kdeglobals"."WM"."inactiveBlend" = "47,52,63";
      "kdeglobals"."WM"."inactiveForeground" = "102,106,115";
      "kglobalshortcutsrc"."ksmserver"."_k_friendly_name" = "Session Management";
      "kglobalshortcutsrc"."kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left";
      "kglobalshortcutsrc"."kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 1" = "Ctrl+F1,Ctrl+F1,Switch to Desktop 1";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 2" = "Ctrl+F2,Ctrl+F2,Switch to Desktop 2";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 3" = "Ctrl+F3,Ctrl+F3,Switch to Desktop 3";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 4" = "Ctrl+F4,Ctrl+F4,Switch to Desktop 4";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 5" = "Ctrl+F5,Ctrl+F5,Switch to Desktop 5";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 6" = "Ctrl+F6,Ctrl+F6,Switch to Desktop 6";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 7" = "Ctrl+F7,Ctrl+F7,Switch to Desktop 7";
      "kglobalshortcutsrc"."kwin"."Switch to Desktop 8" = "Ctrl+F8,Ctrl+F8,Switch to Desktop 8";
      "kglobalshortcutsrc"."mediacontrol"."_k_friendly_name" = "Media Controller";
      "kglobalshortcutsrc"."org.wezfurlong.wezterm.desktop"."_k_friendly_name" = "WezTerm";
      "khotkeysrc"."Data_1_1Triggers0"."Uuid" = "{d03619b6-9b3c-48cc-9d9c-a2aadb485550}";
      "khotkeysrc"."Data_2_1Triggers0"."Uuid" = "{1b12efe7-b4cf-43e2-8669-f07d5c864cd0}";
      "khotkeysrc"."Data_2_2Triggers0"."Uuid" = "{611f28cc-7225-4ca1-9db7-809b5b2bae56}";
      "khotkeysrc"."Data_2_3Triggers0"."Uuid" = "{718f5c6e-2077-49c1-b978-f34a2bffb5ea}";
      "khotkeysrc"."Data_2_4Triggers0"."Uuid" = "{3c657a09-3169-4ca7-bdf9-ac0ce39da067}";
      "khotkeysrc"."Data_2_5Triggers0"."Uuid" = "{689067f0-499a-411e-b64b-9ae32a84083c}";
      "khotkeysrc"."Data_2_6Triggers0"."Uuid" = "{5b321459-77ef-4ed2-b137-6fc7fcf78a9b}";
      "khotkeysrc"."Data_2_8Triggers0"."Uuid" = "{b6dc2ea4-90bb-4f80-b013-8a21615dd1cf}";
      "khotkeysrc"."DirSelect Dialog"."DirSelectDialog Size[$d]" = "";
      "khotkeysrc"."General"."BrowserApplication[$d]" = "";
      "khotkeysrc"."General"."TerminalApplication[$d]" = "";
      "khotkeysrc"."General"."TerminalService[$d]" = "";
      "khotkeysrc"."GesturesExclude"."Comment" = "";
      "khotkeysrc"."GesturesExclude"."WindowsCount" = 0;
      "khotkeysrc"."KDE"."LookAndFeelPackage[$d]" = "";
      "khotkeysrc"."KDE"."SingleClick[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Allow Expansion[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Automatically select filename extension[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Breadcrumb Navigation[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Decoration position[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."LocationCombo Completionmode[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."PathCombo Completionmode[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Bookmarks[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Full Path[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Inline Previews[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Preview[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Speedbar[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show hidden files[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort by[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort directories first[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort hidden files last[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort reversed[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Speedbar Width[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."View Style[$d]" = "";
      "khotkeysrc"."KShortcutsDialog Settings"."Dialog Size[$d]" = "";
      "khotkeysrc"."PreviewSettings"."MaximumRemoteSize[$d]" = "";
      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kiorc"."Confirmations"."ConfirmTrash" = false;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "alwaysAsk";
      "klipperrc"."General"."IgnoreImages" = false;
      "klipperrc"."General"."KeepClipboardContents" = false;
      "klipperrc"."General"."SyncClipboards" = true;
      "krunnerrc"."Plugins"."baloosearchEnabled" = true;
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."Image" = "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."PreviewImage" = "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."SlidePaths" = "/nix/store/1yiqw7605f5wmwy6gr3bx07i26cgxp6w-breeze-qt5-5.27.4-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/";
      "kwalletrc"."Wallet"."Close When Idle" = false;
      "kwalletrc"."Wallet"."Close on Screensaver" = false;
      "kwalletrc"."Wallet"."Default Wallet" = "kdewallet";
      "kwalletrc"."Wallet"."Enabled" = true;
      "kwalletrc"."Wallet"."First Use" = false;
      "kwalletrc"."Wallet"."Idle Timeout" = 10;
      "kwalletrc"."Wallet"."Launch Manager" = false;
      "kwalletrc"."Wallet"."Leave Manager Open" = false;
      "kwalletrc"."Wallet"."Leave Open" = true;
      "kwalletrc"."Wallet"."Prompt on Open" = false;
      "kwalletrc"."Wallet"."Use One Wallet" = true;
      "kwalletrc"."org.freedesktop.secrets"."apiEnabled" = false;
      "kwinrc"."Desktops"."Id_1" = "d516980a-fdeb-4550-be70-5fef9371e24c";
      "kwinrc"."Desktops"."Id_2" = "834fd96c-503a-4be4-8d14-d6a5778f142f";
      "kwinrc"."Desktops"."Id_3" = "0f311a32-09be-4a57-9480-f861d1ca91e9";
      "kwinrc"."Desktops"."Name_2" = "New Desktop";
      "kwinrc"."Desktops"."Number" = 3;
      "kwinrc"."NightColor"."Active" = true;
      "kwinrc"."NightColor"."Mode" = "Constant";
      "kwinrc"."Plugins"."autotileEnabled" = false;
      "kwinrc"."Plugins"."desktopchangeosdEnabled" = true;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = true;
      "kwinrc"."Script-autotile"."Borders" = 2;
      "kwinrc"."Tiling.213a9620-187e-58a6-b80b-85d8fb95dfce"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling.23d84027-6b81-5a63-91b8-8e7e614d6fad"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling.3b09003e-31fd-5563-a5d0-e1df30d8aa4c"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling.bd455426-91b5-5aa4-b78c-9e21c3c810ab"."tiles" = "{\"layoutDirection\":\"floating\",\"tiles\":[]}";
      "kwinrc"."Tiling.cc55641a-b969-52cd-87bf-88d4810033db"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Windows"."SnapOnlyWhenOverlapping" = true;
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;
      "kwinrc"."Xwayland"."Scale" = 1;
      "plasma-localerc"."Formats"."LANG" = "en_IN";
      "plasmanotifyrc"."Notifications"."PopupPosition" = "TopRight";
      "plasmarc"."Wallpapers"."usersWallpapers" = "/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129170335.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129165840.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129153219.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129110216.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128192154.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128161858.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128161841.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221127161512.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221127144544.png,/home/gotlou/Pictures/wallpaper/PXL_20220623_195037007.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_192003680.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_191049547.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_184054157.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220410_073123359.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_111019412.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_111016660.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_110340969.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_110306245.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_122655523.PORTRAIT.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_180350726.NIGHT.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_174611447.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163340872.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163125571.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163122882.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163115778.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_161752069.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_161737943.jpg,/home/gotlou/Pictures/wallpaper/IMG_0760.heic,/home/gotlou/Pictures/wallpaper/PXL_20211016_163212987.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_180722093.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_180718228.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_175850636.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_114329445.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_105859260.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_105557074.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_094727526.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_093652065.jpg,/home/gotlou/Pictures/wallpaper/IMG_9956.JPG,/home/gotlou/Pictures/wallpaper/IMG_0296.JPG,/home/gotlou/Pictures/wallpaper/IMG_0596.JPG,/home/gotlou/Pictures/wallpaper/IMG_0677.JPG,/home/gotlou/Pictures/wallpaper/IMG_0767.JPG,/home/gotlou/Pictures/wallpaper/IMG_0759.JPG,/home/gotlou/Pictures/wallpaper/IMG_0806.JPG,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200704213904.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200718131532.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200718131521.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210307124749.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210324130751.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311140559.png,/home/gotlou/Pictures/wallpaper/God of War_20200216141951.png,/home/gotlou/Pictures/wallpaper/God of War_20191231131741.png,/home/gotlou/Pictures/wallpaper/God of War_20191226151341.png,/home/gotlou/Pictures/wallpaper/God of War_20190713120728.png,/home/gotlou/Pictures/wallpaper/God of War_20190511121620.png,/home/gotlou/Pictures/wallpaper/God of War_20190430150654.png,/home/gotlou/Pictures/wallpaper/God of War_20190430150654_1.png,/home/gotlou/Pictures/wallpaper/Uncharted 4_ A Thief’s End™_20200113144917.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20200224104658.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20200222130417.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20190831111403.png";
      "systemsettingsrc"."KFileDialog Settings"."detailViewIconSize" = 16;
      "systemsettingsrc"."Open-with settings"."CompletionMode" = 1;
      "systemsettingsrc"."Open-with settings"."History" = "mull,konsole";
    };
  };
}
