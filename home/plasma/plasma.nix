{
  programs.plasma = {
    enable = true;
    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" =
        "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" =
        "Meta+Alt+K";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = [
        "Touchpad Toggle"
        "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle"
        "Meta+Ctrl+Zenkaku Hankaku"
      ];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = [ "Microphone Mute" ];
      "kmix"."mute" = "Volume Mute";
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" =
        "Meta+Shift+W,Ctrl+F9,Toggle Present Windows (Current desktop)";
      "kwin"."ExposeAll" = [ "Meta+W" ];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."KrohnkiteFloatAll" = "Meta+Shift+F";
      "kwin"."KrohnkiteFocusDown" = "Meta+Down";
      "kwin"."KrohnkiteFocusLeft" = "Meta+Left";
      "kwin"."KrohnkiteFocusRight" = "Meta+Right";
      "kwin"."KrohnkiteFocusUp" = "Meta+Up";
      "kwin"."KrohnkiteRotate" = "Meta+R";
      "kwin"."KrohnkiteRotatePart" = "Meta+Shift+R";
      "kwin"."KrohnkiteShiftLeft" = "Meta+Shift+H";
      "kwin"."KrohnkiteShiftRight" = "Meta+Shift+L";
      "kwin"."KrohnkiteToggleFloat" = "Meta+F";
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."ShowDesktopGrid" = "Meta+F8";
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";
      "kwin"."Switch to Desktop 6" = "Meta+6";
      "kwin"."Switch to Desktop 7" = "Meta+7";
      "kwin"."Switch to Desktop 8" = "Meta+8";
      "kwin"."Switch to Desktop 9" = "Meta+9";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window to Desktop 1" = "Meta+!";
      "kwin"."Window to Desktop 2" = "Meta+@";
      "kwin"."Window to Desktop 3" = "Meta+#";
      "kwin"."Window to Desktop 4" = "Meta+$";
      "kwin"."Window to Desktop 5" = "Meta+%";
      "kwin"."Window to Desktop 6" = "Meta+^";
      "kwin"."Window to Desktop 7" = "Meta+&";
      "kwin"."Window to Desktop 8" = "Meta+*";
      "kwin"."Window to Desktop 9" = "Meta+(";
      "kwin"."Window to Next Desktop" = "Ctrl+Alt+Right";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = "Ctrl+Alt+Left";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = [ "Meta++,Meta++" "Meta+=,Zoom In" ];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" =
        "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" =
        "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" =
        "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" =
        "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" =
        "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" =
        "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" =
        "Keyboard Light On/Off";
      "org_kde_powerdevil"."powerProfile" = [ "Battery" "Meta+B" ];
      "plasmashell"."activate application launcher" = [ "Meta" ];
      "services/org.kde.plasma-systemmonitor.desktop"."_launch" = "Ctrl+Esc";
      "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" =
        "Print";
      "services/org.wezfurlong.wezterm.desktop"."_launch" = "Meta+Return";
    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "baloofilerc"."General"."exclude filters" =
        "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found";
      "baloofilerc"."General"."exclude foldersx5b$ex5d" = "$HOME/";
      "baloofilerc"."General"."foldersx5b$ex5d" =
        "$HOME/Documents/College/,$HOME/Documents/Documentation/";
      "baloofilerc"."General"."only basic indexing" = false;
      "dolphinrc"."General.$i"."EditableUrl[$i]" = true;
      "dolphinrc"."General.$i"."EditableUrlx5b$ix5d" = true;
      "dolphinrc"."General.$i"."RememberOpenedTabs[$i]" = false;
      "dolphinrc"."General.$i"."RememberOpenedTabsx5b$ix5d" = false;
      "dolphinrc"."General.$i"."Version[$i]" = 202;
      "dolphinrc"."General.$i"."Versionx5b$ix5d" = 202;
      "dolphinrc"."General.$i"."ViewPropsTimestamp[$i]" =
        "2023,10,4,17,14,27.119";
      "dolphinrc"."General.$i"."ViewPropsTimestampx5b$ix5d" =
        "2023,10,4,17,14,27.119";
      "dolphinrc"."General/$i"."EditableUrl[$i]" = true;
      "dolphinrc"."General/$i"."EditableUrlx5b$ix5d" = true;
      "dolphinrc"."General/$i"."RememberOpenedTabs[$i]" = false;
      "dolphinrc"."General/$i"."RememberOpenedTabsx5b$ix5d" = false;
      "dolphinrc"."General/$i"."Version[$i]" = 202;
      "dolphinrc"."General/$i"."Versionx5b$ix5d" = 202;
      "dolphinrc"."General/$i"."ViewPropsTimestamp[$i]" =
        "2023,10,4,17,14,27.119";
      "dolphinrc"."General/$i"."ViewPropsTimestampx5b$ix5d" =
        "2023,10,4,17,14,27.119";
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."PreviewSettings"."Plugins" =
        "audiothumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,blenderthumbnail,mobithumbnail,ffmpegthumbs,rawthumbnail,gsthumbnail,directorythumbnail";
      "dolphinrc"."Search"."Location" = "Everywhere";
      "kactivitymanagerdrc"."activities"."a90bd124-d21f-41ff-b3f8-64d92ce5f9e9" =
        "Default";
      "kactivitymanagerdrc"."main"."currentActivity" =
        "a90bd124-d21f-41ff-b3f8-64d92ce5f9e9";
      "kcminputrc"."Libinput.2.14.ETPS\\/2 Elantech Touchpad"."TapToClick" =
        true;
      "kcminputrc"."Libinput/2/14/ETPS\\/2 Elantech Touchpad"."TapToClick" =
        true;
      "kcminputrc"."Mouse"."cursorTheme" = "macOS-Monterey";
      "kcminputrc"."Tmp"."update_info" =
        "delete_cursor_old_default_size.upd:DeleteCursorOldDefaultSize";
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 2;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "1879,1080";
      "kdeglobals"."General"."AllowKDEAppsToRememberWindowPositions" = true;
      "kdeglobals"."General"."BrowserApplication" =
        "mullvadbrowser-sandbox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "wezterm start --always-new-process --cwd .";
      "kdeglobals"."General"."TerminalService" =
        "org.wezfurlong.wezterm.desktop";
      "kdeglobals"."Icons"."Theme" = "Papirus-Dark";
      "kdeglobals"."KDE"."SingleClick" = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" =
        true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 141;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."KShortcutsDialog Settings"."Dialog Size" = "600,480";
      "kdeglobals"."PreviewSettings"."MaximumRemoteSize" = 0;
      "kdeglobals"."WM"."activeBackground" = "46,52,64";
      "kdeglobals"."WM"."activeBlend" = "235,203,139";
      "kdeglobals"."WM"."activeForeground" = "229,233,240";
      "kdeglobals"."WM"."inactiveBackground" = "46,52,64";
      "kdeglobals"."WM"."inactiveBlend" = "76,86,106";
      "kdeglobals"."WM"."inactiveForeground" = "229,233,240";
      "khotkeysrc"."Data"."DataCount" = 3;
      "khotkeysrc"."Data_1"."Comment" = "KMenuEdit Global Shortcuts";
      "khotkeysrc"."Data_1"."DataCount" = 1;
      "khotkeysrc"."Data_1"."Enabled" = true;
      "khotkeysrc"."Data_1"."Name" = "KMenuEdit";
      "khotkeysrc"."Data_1"."SystemGroup" = 1;
      "khotkeysrc"."Data_1"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_1_1"."Comment" = "Comment";
      "khotkeysrc"."Data_1_1"."Enabled" = true;
      "khotkeysrc"."Data_1_1"."Name" = "Search";
      "khotkeysrc"."Data_1_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_1_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_1_1Actions0"."CommandURL" = "http://google.com";
      "khotkeysrc"."Data_1_1Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_1_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_1_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_1_1Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_1_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_1_1Triggers0"."Key" = "";
      "khotkeysrc"."Data_1_1Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_1_1Triggers0"."Uuid" =
        "{d03619b6-9b3c-48cc-9d9c-a2aadb485550}";
      "khotkeysrc"."Data_2"."Comment" =
        "This group contains various examples demonstrating most of the features of KHotkeys. (Note that this group and all its actions are disabled by default.)";
      "khotkeysrc"."Data_2"."DataCount" = 8;
      "khotkeysrc"."Data_2"."Enabled" = false;
      "khotkeysrc"."Data_2"."ImportId" = "kde32b1";
      "khotkeysrc"."Data_2"."Name" = "Examples";
      "khotkeysrc"."Data_2"."SystemGroup" = 0;
      "khotkeysrc"."Data_2"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_1"."Comment" =
        "After pressing Ctrl+Alt+I, the KSIRC window will be activated, if it exists. Simple.";
      "khotkeysrc"."Data_2_1"."Enabled" = false;
      "khotkeysrc"."Data_2_1"."Name" = "Activate KSIRC Window";
      "khotkeysrc"."Data_2_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_1Actions0"."Type" = "ACTIVATE_WINDOW";
      "khotkeysrc"."Data_2_1Actions0Window"."Comment" = "KSIRC window";
      "khotkeysrc"."Data_2_1Actions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_1Actions0Window0"."Class" = "ksirc";
      "khotkeysrc"."Data_2_1Actions0Window0"."ClassType" = 1;
      "khotkeysrc"."Data_2_1Actions0Window0"."Comment" = "KSIRC";
      "khotkeysrc"."Data_2_1Actions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_1Actions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_1Actions0Window0"."Title" = "";
      "khotkeysrc"."Data_2_1Actions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_2_1Actions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_1Actions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_1Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_1Triggers0"."Key" = "Ctrl+Alt+I";
      "khotkeysrc"."Data_2_1Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_1Triggers0"."Uuid" =
        "{1b12efe7-b4cf-43e2-8669-f07d5c864cd0}";
      "khotkeysrc"."Data_2_2"."Comment" = ''
        After pressing Alt+Ctrl+H the input of 'Hello' will be simulated, as if you typed it.  This is especially useful if you have call to frequently type a word (for instance, 'unsigned').  Every keypress in the input is separated by a colon ':'. Note that the keypresses literally mean keypresses, so you have to write what you would press on the keyboard. In the table below, the left column shows the input and the right column shows what to type.

        "enter" (i.e. new line)                Enter or Return
        a (i.e. small a)                          A
        A (i.e. capital a)                       Shift+A
        : (colon)                                  Shift+;
        ' '  (space)                              Space'';
      "khotkeysrc"."Data_2_2"."Enabled" = false;
      "khotkeysrc"."Data_2_2"."Name" = "Type 'Hello'";
      "khotkeysrc"."Data_2_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_2Actions0"."Input" = ''
        Shift+H:E:L:L:O
      '';
      "khotkeysrc"."Data_2_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_2Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_2Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_2Triggers0"."Key" = "Ctrl+Alt+H";
      "khotkeysrc"."Data_2_2Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_2Triggers0"."Uuid" =
        "{611f28cc-7225-4ca1-9db7-809b5b2bae56}";
      "khotkeysrc"."Data_2_3"."Comment" =
        "This action runs Konsole, after pressing Ctrl+Alt+T.";
      "khotkeysrc"."Data_2_3"."Enabled" = false;
      "khotkeysrc"."Data_2_3"."Name" = "Run Konsole";
      "khotkeysrc"."Data_2_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_3Actions0"."CommandURL" = "konsole";
      "khotkeysrc"."Data_2_3Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_2_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_3Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_3Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_3Triggers0"."Key" = "Ctrl+Alt+T";
      "khotkeysrc"."Data_2_3Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_3Triggers0"."Uuid" =
        "{718f5c6e-2077-49c1-b978-f34a2bffb5ea}";
      "khotkeysrc"."Data_2_4"."Comment" = ''
        Read the comment on the "Type 'Hello'" action first.

        Qt Designer uses Ctrl+F4 for closing windows.  In KDE, however, Ctrl+F4 is the shortcut for going to virtual desktop 4, so this shortcut does not work in Qt Designer.  Further, Qt Designer does not use KDE's standard Ctrl+W for closing the window.

        This problem can be solved by remapping Ctrl+W to Ctrl+F4 when the active window is Qt Designer. When Qt Designer is active, every time Ctrl+W is pressed, Ctrl+F4 will be sent to Qt Designer instead. In other applications, the effect of Ctrl+W is unchanged.

        We now need to specify three things: A new shortcut trigger on 'Ctrl+W', a new keyboard input action sending Ctrl+F4, and a new condition that the active window is Qt Designer.
        Qt Designer seems to always have title 'Qt Designer by Trolltech', so the condition will check for the active window having that title.'';
      "khotkeysrc"."Data_2_4"."Enabled" = false;
      "khotkeysrc"."Data_2_4"."Name" = "Remap Ctrl+W to Ctrl+F4 in Qt Designer";
      "khotkeysrc"."Data_2_4"."Type" = "GENERIC_ACTION_DATA";
      "khotkeysrc"."Data_2_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_4Actions0"."Input" = "Ctrl+F4";
      "khotkeysrc"."Data_2_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_4Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_2_4Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_2_4Conditions0Window"."Comment" = "Qt Designer";
      "khotkeysrc"."Data_2_4Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Class" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."ClassType" = 0;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Comment" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Title" =
        "Qt Designer by Trolltech";
      "khotkeysrc"."Data_2_4Conditions0Window0"."TitleType" = 2;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_4Conditions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_4Triggers"."Comment" = "";
      "khotkeysrc"."Data_2_4Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_4Triggers0"."Key" = "Ctrl+W";
      "khotkeysrc"."Data_2_4Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_4Triggers0"."Uuid" =
        "{3c657a09-3169-4ca7-bdf9-ac0ce39da067}";
      "khotkeysrc"."Data_2_5"."Comment" =
        "By pressing Alt+Ctrl+W a D-Bus call will be performed that will show the minicli. You can use any kind of D-Bus call, just like using the command line 'qdbus' tool.";
      "khotkeysrc"."Data_2_5"."Enabled" = false;
      "khotkeysrc"."Data_2_5"."Name" =
        "Perform D-Bus call 'qdbus org.kde.krunner /App display'";
      "khotkeysrc"."Data_2_5"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_5Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_5Actions0"."Arguments" = "";
      "khotkeysrc"."Data_2_5Actions0"."Call" = "popupExecuteCommand";
      "khotkeysrc"."Data_2_5Actions0"."RemoteApp" = "org.kde.krunner";
      "khotkeysrc"."Data_2_5Actions0"."RemoteObj" = "/App";
      "khotkeysrc"."Data_2_5Actions0"."Type" = "DBUS";
      "khotkeysrc"."Data_2_5Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_5Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_5Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_5Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_5Triggers0"."Key" = "Ctrl+Alt+W";
      "khotkeysrc"."Data_2_5Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_5Triggers0"."Uuid" =
        "{689067f0-499a-411e-b64b-9ae32a84083c}";
      "khotkeysrc"."Data_2_6"."Comment" = ''
        Read the comment on the "Type 'Hello'" action first.

        Just like the "Type 'Hello'" action, this one simulates keyboard input, specifically, after pressing Ctrl+Alt+B, it sends B to XMMS (B in XMMS jumps to the next song). The 'Send to specific window' checkbox is checked and a window with its class containing 'XMMS_Player' is specified; this will make the input always be sent to this window. This way, you can control XMMS even if, for instance, it is on a different virtual desktop.

        (Run 'xprop' and click on the XMMS window and search for WM_CLASS to see 'XMMS_Player').'';
      "khotkeysrc"."Data_2_6"."Enabled" = false;
      "khotkeysrc"."Data_2_6"."Name" = "Next in XMMS";
      "khotkeysrc"."Data_2_6"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_6Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_6Actions0"."DestinationWindow" = 1;
      "khotkeysrc"."Data_2_6Actions0"."Input" = "B";
      "khotkeysrc"."Data_2_6Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow"."Comment" =
        "XMMS window";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Class" = "XMMS_Player";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."ClassType" = 1;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Comment" =
        "XMMS Player window";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Role" = "";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."RoleType" = 0;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Title" = "";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."TitleType" = 0;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_6Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_6Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_6Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_6Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_6Triggers0"."Key" = "Ctrl+Alt+B";
      "khotkeysrc"."Data_2_6Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_6Triggers0"."Uuid" =
        "{5b321459-77ef-4ed2-b137-6fc7fcf78a9b}";
      "khotkeysrc"."Data_2_7"."Comment" = ''
        Konqueror in KDE3.1 has tabs, and now you can also have gestures.

        Just press the middle mouse button and start drawing one of the gestures, and after you are finished, release the mouse button. If you only need to paste the selection, it still works, just click the middle mouse button. (You can change the mouse button to use in the global settings).

        Right now, there are the following gestures available:
        move right and back left - Forward (Alt+Right)
        move left and back right - Back (Alt+Left)
        move up and back down  - Up (Alt+Up)
        circle counterclockwise - Reload (F5)

        The gesture shapes can be entered by performing them in the configuration dialog. You can also look at your numeric pad to help you: gestures are recognized like a 3x3 grid of fields, numbered 1 to 9.

        Note that you must perform exactly the gesture to trigger the action. Because of this, it is possible to enter more gestures for the action. You should try to avoid complicated gestures where you change the direction of mouse movement more than once.  For instance, 45654 or 74123 are simple to perform, but 1236987 may be already quite difficult.

        The conditions for all gestures are defined in this group. All these gestures are active only if the active window is Konqueror (class contains 'konqueror').'';
      "khotkeysrc"."Data_2_7"."DataCount" = 4;
      "khotkeysrc"."Data_2_7"."Enabled" = false;
      "khotkeysrc"."Data_2_7"."Name" = "Konqi Gestures";
      "khotkeysrc"."Data_2_7"."SystemGroup" = 0;
      "khotkeysrc"."Data_2_7"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_2_7Conditions"."Comment" = "Konqueror window";
      "khotkeysrc"."Data_2_7Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_2_7Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_2_7Conditions0Window"."Comment" = "Konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Class" = "konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window0"."ClassType" = 1;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Comment" = "Konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_7Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Title" = "";
      "khotkeysrc"."Data_2_7Conditions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_7Conditions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_7_1"."Comment" = "";
      "khotkeysrc"."Data_2_7_1"."Enabled" = false;
      "khotkeysrc"."Data_2_7_1"."Name" = "Back";
      "khotkeysrc"."Data_2_7_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_1Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_1Actions0"."Input" = "Alt+Left";
      "khotkeysrc"."Data_2_7_1Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_1Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_1Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_1Triggers0"."GesturePointData" =
        "0,0.0625,1,1,0.5,0.0625,0.0625,1,0.875,0.5,0.125,0.0625,1,0.75,0.5,0.1875,0.0625,1,0.625,0.5,0.25,0.0625,1,0.5,0.5,0.3125,0.0625,1,0.375,0.5,0.375,0.0625,1,0.25,0.5,0.4375,0.0625,1,0.125,0.5,0.5,0.0625,0,0,0.5,0.5625,0.0625,0,0.125,0.5,0.625,0.0625,0,0.25,0.5,0.6875,0.0625,0,0.375,0.5,0.75,0.0625,0,0.5,0.5,0.8125,0.0625,0,0.625,0.5,0.875,0.0625,0,0.75,0.5,0.9375,0.0625,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_2_7_1Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_1Triggers1"."GesturePointData" =
        "0,0.0833333,1,0.5,0.5,0.0833333,0.0833333,1,0.375,0.5,0.166667,0.0833333,1,0.25,0.5,0.25,0.0833333,1,0.125,0.5,0.333333,0.0833333,0,0,0.5,0.416667,0.0833333,0,0.125,0.5,0.5,0.0833333,0,0.25,0.5,0.583333,0.0833333,0,0.375,0.5,0.666667,0.0833333,0,0.5,0.5,0.75,0.0833333,0,0.625,0.5,0.833333,0.0833333,0,0.75,0.5,0.916667,0.0833333,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_2_7_1Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_1Triggers2"."GesturePointData" =
        "0,0.0833333,1,1,0.5,0.0833333,0.0833333,1,0.875,0.5,0.166667,0.0833333,1,0.75,0.5,0.25,0.0833333,1,0.625,0.5,0.333333,0.0833333,1,0.5,0.5,0.416667,0.0833333,1,0.375,0.5,0.5,0.0833333,1,0.25,0.5,0.583333,0.0833333,1,0.125,0.5,0.666667,0.0833333,0,0,0.5,0.75,0.0833333,0,0.125,0.5,0.833333,0.0833333,0,0.25,0.5,0.916667,0.0833333,0,0.375,0.5,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_1Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2"."Comment" = "";
      "khotkeysrc"."Data_2_7_2"."Enabled" = false;
      "khotkeysrc"."Data_2_7_2"."Name" = "Forward";
      "khotkeysrc"."Data_2_7_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_2Actions0"."Input" = "Alt+Right";
      "khotkeysrc"."Data_2_7_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_2Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_2Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_2Triggers0"."GesturePointData" =
        "0,0.0625,0,0,0.5,0.0625,0.0625,0,0.125,0.5,0.125,0.0625,0,0.25,0.5,0.1875,0.0625,0,0.375,0.5,0.25,0.0625,0,0.5,0.5,0.3125,0.0625,0,0.625,0.5,0.375,0.0625,0,0.75,0.5,0.4375,0.0625,0,0.875,0.5,0.5,0.0625,1,1,0.5,0.5625,0.0625,1,0.875,0.5,0.625,0.0625,1,0.75,0.5,0.6875,0.0625,1,0.625,0.5,0.75,0.0625,1,0.5,0.5,0.8125,0.0625,1,0.375,0.5,0.875,0.0625,1,0.25,0.5,0.9375,0.0625,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_2_7_2Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2Triggers1"."GesturePointData" =
        "0,0.0833333,0,0.5,0.5,0.0833333,0.0833333,0,0.625,0.5,0.166667,0.0833333,0,0.75,0.5,0.25,0.0833333,0,0.875,0.5,0.333333,0.0833333,1,1,0.5,0.416667,0.0833333,1,0.875,0.5,0.5,0.0833333,1,0.75,0.5,0.583333,0.0833333,1,0.625,0.5,0.666667,0.0833333,1,0.5,0.5,0.75,0.0833333,1,0.375,0.5,0.833333,0.0833333,1,0.25,0.5,0.916667,0.0833333,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_2_7_2Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2Triggers2"."GesturePointData" =
        "0,0.0833333,0,0,0.5,0.0833333,0.0833333,0,0.125,0.5,0.166667,0.0833333,0,0.25,0.5,0.25,0.0833333,0,0.375,0.5,0.333333,0.0833333,0,0.5,0.5,0.416667,0.0833333,0,0.625,0.5,0.5,0.0833333,0,0.75,0.5,0.583333,0.0833333,0,0.875,0.5,0.666667,0.0833333,1,1,0.5,0.75,0.0833333,1,0.875,0.5,0.833333,0.0833333,1,0.75,0.5,0.916667,0.0833333,1,0.625,0.5,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_2Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3"."Comment" = "";
      "khotkeysrc"."Data_2_7_3"."Enabled" = false;
      "khotkeysrc"."Data_2_7_3"."Name" = "Up";
      "khotkeysrc"."Data_2_7_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_3Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_3Actions0"."Input" = "Alt+Up";
      "khotkeysrc"."Data_2_7_3Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_3Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_3Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_3Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_3Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3Triggers1"."GesturePointData" =
        "0,0.0833333,-0.5,0.5,1,0.0833333,0.0833333,-0.5,0.5,0.875,0.166667,0.0833333,-0.5,0.5,0.75,0.25,0.0833333,-0.5,0.5,0.625,0.333333,0.0833333,-0.5,0.5,0.5,0.416667,0.0833333,-0.5,0.5,0.375,0.5,0.0833333,-0.5,0.5,0.25,0.583333,0.0833333,-0.5,0.5,0.125,0.666667,0.0833333,0.5,0.5,0,0.75,0.0833333,0.5,0.5,0.125,0.833333,0.0833333,0.5,0.5,0.25,0.916667,0.0833333,0.5,0.5,0.375,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_3Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3Triggers2"."GesturePointData" =
        "0,0.0833333,-0.5,0.5,0.5,0.0833333,0.0833333,-0.5,0.5,0.375,0.166667,0.0833333,-0.5,0.5,0.25,0.25,0.0833333,-0.5,0.5,0.125,0.333333,0.0833333,0.5,0.5,0,0.416667,0.0833333,0.5,0.5,0.125,0.5,0.0833333,0.5,0.5,0.25,0.583333,0.0833333,0.5,0.5,0.375,0.666667,0.0833333,0.5,0.5,0.5,0.75,0.0833333,0.5,0.5,0.625,0.833333,0.0833333,0.5,0.5,0.75,0.916667,0.0833333,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_3Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4"."Comment" = "";
      "khotkeysrc"."Data_2_7_4"."Enabled" = false;
      "khotkeysrc"."Data_2_7_4"."Name" = "Reload";
      "khotkeysrc"."Data_2_7_4"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_4Actions0"."Input" = "F5";
      "khotkeysrc"."Data_2_7_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_4Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_4Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_4Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_4Triggers0"."GesturePointData" =
        "0,0.03125,0,0,1,0.03125,0.03125,0,0.125,1,0.0625,0.03125,0,0.25,1,0.09375,0.03125,0,0.375,1,0.125,0.03125,0,0.5,1,0.15625,0.03125,0,0.625,1,0.1875,0.03125,0,0.75,1,0.21875,0.03125,0,0.875,1,0.25,0.03125,-0.5,1,1,0.28125,0.03125,-0.5,1,0.875,0.3125,0.03125,-0.5,1,0.75,0.34375,0.03125,-0.5,1,0.625,0.375,0.03125,-0.5,1,0.5,0.40625,0.03125,-0.5,1,0.375,0.4375,0.03125,-0.5,1,0.25,0.46875,0.03125,-0.5,1,0.125,0.5,0.03125,1,1,0,0.53125,0.03125,1,0.875,0,0.5625,0.03125,1,0.75,0,0.59375,0.03125,1,0.625,0,0.625,0.03125,1,0.5,0,0.65625,0.03125,1,0.375,0,0.6875,0.03125,1,0.25,0,0.71875,0.03125,1,0.125,0,0.75,0.03125,0.5,0,0,0.78125,0.03125,0.5,0,0.125,0.8125,0.03125,0.5,0,0.25,0.84375,0.03125,0.5,0,0.375,0.875,0.03125,0.5,0,0.5,0.90625,0.03125,0.5,0,0.625,0.9375,0.03125,0.5,0,0.75,0.96875,0.03125,0.5,0,0.875,1,0,0,0,1";
      "khotkeysrc"."Data_2_7_4Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4Triggers1"."GesturePointData" =
        "0,0.0277778,0,0,1,0.0277778,0.0277778,0,0.125,1,0.0555556,0.0277778,0,0.25,1,0.0833333,0.0277778,0,0.375,1,0.111111,0.0277778,0,0.5,1,0.138889,0.0277778,0,0.625,1,0.166667,0.0277778,0,0.75,1,0.194444,0.0277778,0,0.875,1,0.222222,0.0277778,-0.5,1,1,0.25,0.0277778,-0.5,1,0.875,0.277778,0.0277778,-0.5,1,0.75,0.305556,0.0277778,-0.5,1,0.625,0.333333,0.0277778,-0.5,1,0.5,0.361111,0.0277778,-0.5,1,0.375,0.388889,0.0277778,-0.5,1,0.25,0.416667,0.0277778,-0.5,1,0.125,0.444444,0.0277778,1,1,0,0.472222,0.0277778,1,0.875,0,0.5,0.0277778,1,0.75,0,0.527778,0.0277778,1,0.625,0,0.555556,0.0277778,1,0.5,0,0.583333,0.0277778,1,0.375,0,0.611111,0.0277778,1,0.25,0,0.638889,0.0277778,1,0.125,0,0.666667,0.0277778,0.5,0,0,0.694444,0.0277778,0.5,0,0.125,0.722222,0.0277778,0.5,0,0.25,0.75,0.0277778,0.5,0,0.375,0.777778,0.0277778,0.5,0,0.5,0.805556,0.0277778,0.5,0,0.625,0.833333,0.0277778,0.5,0,0.75,0.861111,0.0277778,0.5,0,0.875,0.888889,0.0277778,0,0,1,0.916667,0.0277778,0,0.125,1,0.944444,0.0277778,0,0.25,1,0.972222,0.0277778,0,0.375,1,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_4Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4Triggers2"."GesturePointData" =
        "0,0.0277778,0.5,0,0.5,0.0277778,0.0277778,0.5,0,0.625,0.0555556,0.0277778,0.5,0,0.75,0.0833333,0.0277778,0.5,0,0.875,0.111111,0.0277778,0,0,1,0.138889,0.0277778,0,0.125,1,0.166667,0.0277778,0,0.25,1,0.194444,0.0277778,0,0.375,1,0.222222,0.0277778,0,0.5,1,0.25,0.0277778,0,0.625,1,0.277778,0.0277778,0,0.75,1,0.305556,0.0277778,0,0.875,1,0.333333,0.0277778,-0.5,1,1,0.361111,0.0277778,-0.5,1,0.875,0.388889,0.0277778,-0.5,1,0.75,0.416667,0.0277778,-0.5,1,0.625,0.444444,0.0277778,-0.5,1,0.5,0.472222,0.0277778,-0.5,1,0.375,0.5,0.0277778,-0.5,1,0.25,0.527778,0.0277778,-0.5,1,0.125,0.555556,0.0277778,1,1,0,0.583333,0.0277778,1,0.875,0,0.611111,0.0277778,1,0.75,0,0.638889,0.0277778,1,0.625,0,0.666667,0.0277778,1,0.5,0,0.694444,0.0277778,1,0.375,0,0.722222,0.0277778,1,0.25,0,0.75,0.0277778,1,0.125,0,0.777778,0.0277778,0.5,0,0,0.805556,0.0277778,0.5,0,0.125,0.833333,0.0277778,0.5,0,0.25,0.861111,0.0277778,0.5,0,0.375,0.888889,0.0277778,0.5,0,0.5,0.916667,0.0277778,0.5,0,0.625,0.944444,0.0277778,0.5,0,0.75,0.972222,0.0277778,0.5,0,0.875,1,0,0,0,1";
      "khotkeysrc"."Data_2_7_4Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_8"."Comment" =
        "After pressing Win+E (Tux+E) a WWW browser will be launched, and it will open http://www.kde.org . You may run all kind of commands you can run in minicli (Alt+F2).";
      "khotkeysrc"."Data_2_8"."Enabled" = false;
      "khotkeysrc"."Data_2_8"."Name" = "Go to KDE Website";
      "khotkeysrc"."Data_2_8"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_8Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_8Actions0"."CommandURL" = "http://www.kde.org";
      "khotkeysrc"."Data_2_8Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_2_8Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_8Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_8Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_8Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_8Triggers0"."Key" = "Meta+E";
      "khotkeysrc"."Data_2_8Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_8Triggers0"."Uuid" =
        "{b6dc2ea4-90bb-4f80-b013-8a21615dd1cf}";
      "khotkeysrc"."Data_3"."Comment" = "Basic Konqueror gestures.";
      "khotkeysrc"."Data_3"."DataCount" = 14;
      "khotkeysrc"."Data_3"."Enabled" = true;
      "khotkeysrc"."Data_3"."ImportId" = "konqueror_gestures_kde321";
      "khotkeysrc"."Data_3"."Name" = "Konqueror Gestures";
      "khotkeysrc"."Data_3"."SystemGroup" = 0;
      "khotkeysrc"."Data_3"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_3Conditions"."Comment" = "Konqueror window";
      "khotkeysrc"."Data_3Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_3Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_3Conditions0Window"."Comment" = "Konqueror";
      "khotkeysrc"."Data_3Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_3Conditions0Window0"."Class" = "^konquerors";
      "khotkeysrc"."Data_3Conditions0Window0"."ClassType" = 3;
      "khotkeysrc"."Data_3Conditions0Window0"."Comment" = "Konqueror";
      "khotkeysrc"."Data_3Conditions0Window0"."Role" = "konqueror-mainwindow#1";
      "khotkeysrc"."Data_3Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_3Conditions0Window0"."Title" = "file:/ - Konqueror";
      "khotkeysrc"."Data_3Conditions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_3Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_3Conditions0Window0"."WindowTypes" = 1;
      "khotkeysrc"."Data_3_1"."Comment" = "Press, move left, release.";
      "khotkeysrc"."Data_3_1"."Enabled" = true;
      "khotkeysrc"."Data_3_1"."Name" = "Back";
      "khotkeysrc"."Data_3_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_10"."Comment" = ''
        Opera-style: Press, move up, release.
        NOTE: Conflicts with 'New Tab', and as such is disabled by default.'';
      "khotkeysrc"."Data_3_10"."Enabled" = false;
      "khotkeysrc"."Data_3_10"."Name" = "Stop Loading";
      "khotkeysrc"."Data_3_10"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_10Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_10Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_10Actions0"."Input" = ''
        Escape
      '';
      "khotkeysrc"."Data_3_10Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_10Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_10Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_10Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_10Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_10Triggers0"."GesturePointData" =
        "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_10Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_11"."Comment" = ''
        Going up in URL/directory structure.
        Mozilla-style: Press, move up, move left, move up, release.'';
      "khotkeysrc"."Data_3_11"."Enabled" = true;
      "khotkeysrc"."Data_3_11"."Name" = "Up";
      "khotkeysrc"."Data_3_11"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_11Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_11Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_11Actions0"."Input" = "Alt+Up";
      "khotkeysrc"."Data_3_11Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_11Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_11Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_11Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_11Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_11Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,1,1,0.5,0.3125,0.0625,1,0.875,0.5,0.375,0.0625,1,0.75,0.5,0.4375,0.0625,1,0.625,0.5,0.5,0.0625,1,0.5,0.5,0.5625,0.0625,1,0.375,0.5,0.625,0.0625,1,0.25,0.5,0.6875,0.0625,1,0.125,0.5,0.75,0.0625,-0.5,0,0.5,0.8125,0.0625,-0.5,0,0.375,0.875,0.0625,-0.5,0,0.25,0.9375,0.0625,-0.5,0,0.125,1,0,0,0,0";
      "khotkeysrc"."Data_3_11Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_12"."Comment" = ''
        Going up in URL/directory structure.
        Opera-style: Press, move up, move left, move up, release.
        NOTE: Conflicts with  "Activate Previous Tab", and as such is disabled by default.'';
      "khotkeysrc"."Data_3_12"."Enabled" = false;
      "khotkeysrc"."Data_3_12"."Name" = "Up #2";
      "khotkeysrc"."Data_3_12"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_12Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_12Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_12Actions0"."Input" = ''
        Alt+Up
      '';
      "khotkeysrc"."Data_3_12Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_12Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_12Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_12Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_12Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_12Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
      "khotkeysrc"."Data_3_12Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_13"."Comment" =
        "Press, move up, move right, release.";
      "khotkeysrc"."Data_3_13"."Enabled" = true;
      "khotkeysrc"."Data_3_13"."Name" = "Activate Next Tab";
      "khotkeysrc"."Data_3_13"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_13Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_13Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_13Actions0"."Input" = ''
        Ctrl+.
      '';
      "khotkeysrc"."Data_3_13Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_13Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_13Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_13Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_13Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_13Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0,1,0.0625,0.0625,-0.5,0,0.875,0.125,0.0625,-0.5,0,0.75,0.1875,0.0625,-0.5,0,0.625,0.25,0.0625,-0.5,0,0.5,0.3125,0.0625,-0.5,0,0.375,0.375,0.0625,-0.5,0,0.25,0.4375,0.0625,-0.5,0,0.125,0.5,0.0625,0,0,0,0.5625,0.0625,0,0.125,0,0.625,0.0625,0,0.25,0,0.6875,0.0625,0,0.375,0,0.75,0.0625,0,0.5,0,0.8125,0.0625,0,0.625,0,0.875,0.0625,0,0.75,0,0.9375,0.0625,0,0.875,0,1,0,0,1,0";
      "khotkeysrc"."Data_3_13Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_14"."Comment" =
        "Press, move up, move left, release.";
      "khotkeysrc"."Data_3_14"."Enabled" = true;
      "khotkeysrc"."Data_3_14"."Name" = "Activate Previous Tab";
      "khotkeysrc"."Data_3_14"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_14Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_14Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_14Actions0"."Input" = "Ctrl+,";
      "khotkeysrc"."Data_3_14Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_14Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_14Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_14Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_14Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_14Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
      "khotkeysrc"."Data_3_14Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_1Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_1Actions0"."Input" = "Alt+Left";
      "khotkeysrc"."Data_3_1Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_1Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_1Triggers0"."GesturePointData" =
        "0,0.125,1,1,0.5,0.125,0.125,1,0.875,0.5,0.25,0.125,1,0.75,0.5,0.375,0.125,1,0.625,0.5,0.5,0.125,1,0.5,0.5,0.625,0.125,1,0.375,0.5,0.75,0.125,1,0.25,0.5,0.875,0.125,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_3_1Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_2"."Comment" =
        "Press, move down, move up, move down, release.";
      "khotkeysrc"."Data_3_2"."Enabled" = true;
      "khotkeysrc"."Data_3_2"."Name" = "Duplicate Tab";
      "khotkeysrc"."Data_3_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_2Actions0"."Input" = ''
        Ctrl+Shift+D
      '';
      "khotkeysrc"."Data_3_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_2Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_2Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_2Triggers0"."GesturePointData" =
        "0,0.0416667,0.5,0.5,0,0.0416667,0.0416667,0.5,0.5,0.125,0.0833333,0.0416667,0.5,0.5,0.25,0.125,0.0416667,0.5,0.5,0.375,0.166667,0.0416667,0.5,0.5,0.5,0.208333,0.0416667,0.5,0.5,0.625,0.25,0.0416667,0.5,0.5,0.75,0.291667,0.0416667,0.5,0.5,0.875,0.333333,0.0416667,-0.5,0.5,1,0.375,0.0416667,-0.5,0.5,0.875,0.416667,0.0416667,-0.5,0.5,0.75,0.458333,0.0416667,-0.5,0.5,0.625,0.5,0.0416667,-0.5,0.5,0.5,0.541667,0.0416667,-0.5,0.5,0.375,0.583333,0.0416667,-0.5,0.5,0.25,0.625,0.0416667,-0.5,0.5,0.125,0.666667,0.0416667,0.5,0.5,0,0.708333,0.0416667,0.5,0.5,0.125,0.75,0.0416667,0.5,0.5,0.25,0.791667,0.0416667,0.5,0.5,0.375,0.833333,0.0416667,0.5,0.5,0.5,0.875,0.0416667,0.5,0.5,0.625,0.916667,0.0416667,0.5,0.5,0.75,0.958333,0.0416667,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_2Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_3"."Comment" = "Press, move down, move up, release.";
      "khotkeysrc"."Data_3_3"."Enabled" = true;
      "khotkeysrc"."Data_3_3"."Name" = "Duplicate Window";
      "khotkeysrc"."Data_3_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_3Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_3Actions0"."Input" = ''
        Ctrl+D
      '';
      "khotkeysrc"."Data_3_3Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_3Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_3Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_3Triggers0"."GesturePointData" =
        "0,0.0625,0.5,0.5,0,0.0625,0.0625,0.5,0.5,0.125,0.125,0.0625,0.5,0.5,0.25,0.1875,0.0625,0.5,0.5,0.375,0.25,0.0625,0.5,0.5,0.5,0.3125,0.0625,0.5,0.5,0.625,0.375,0.0625,0.5,0.5,0.75,0.4375,0.0625,0.5,0.5,0.875,0.5,0.0625,-0.5,0.5,1,0.5625,0.0625,-0.5,0.5,0.875,0.625,0.0625,-0.5,0.5,0.75,0.6875,0.0625,-0.5,0.5,0.625,0.75,0.0625,-0.5,0.5,0.5,0.8125,0.0625,-0.5,0.5,0.375,0.875,0.0625,-0.5,0.5,0.25,0.9375,0.0625,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_3Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_4"."Comment" = "Press, move right, release.";
      "khotkeysrc"."Data_3_4"."Enabled" = true;
      "khotkeysrc"."Data_3_4"."Name" = "Forward";
      "khotkeysrc"."Data_3_4"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_4Actions0"."Input" = "Alt+Right";
      "khotkeysrc"."Data_3_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_4Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_4Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_4Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_4Triggers0"."GesturePointData" =
        "0,0.125,0,0,0.5,0.125,0.125,0,0.125,0.5,0.25,0.125,0,0.25,0.5,0.375,0.125,0,0.375,0.5,0.5,0.125,0,0.5,0.5,0.625,0.125,0,0.625,0.5,0.75,0.125,0,0.75,0.5,0.875,0.125,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_3_4Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_5"."Comment" = ''
        Press, move down, move half up, move right, move down, release.
        (Drawing a lowercase 'h'.)'';
      "khotkeysrc"."Data_3_5"."Enabled" = true;
      "khotkeysrc"."Data_3_5"."Name" = "Home";
      "khotkeysrc"."Data_3_5"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_5Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_5Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_5Actions0"."Input" = ''
        Alt+Home
      '';
      "khotkeysrc"."Data_3_5Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_5Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_5Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_5Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_5Triggers"."TriggersCount" = 2;
      "khotkeysrc"."Data_3_5Triggers0"."GesturePointData" =
        "0,0.0461748,0.5,0,0,0.0461748,0.0461748,0.5,0,0.125,0.0923495,0.0461748,0.5,0,0.25,0.138524,0.0461748,0.5,0,0.375,0.184699,0.0461748,0.5,0,0.5,0.230874,0.0461748,0.5,0,0.625,0.277049,0.0461748,0.5,0,0.75,0.323223,0.0461748,0.5,0,0.875,0.369398,0.065301,-0.25,0,1,0.434699,0.065301,-0.25,0.125,0.875,0.5,0.065301,-0.25,0.25,0.75,0.565301,0.065301,-0.25,0.375,0.625,0.630602,0.0461748,0,0.5,0.5,0.676777,0.0461748,0,0.625,0.5,0.722951,0.0461748,0,0.75,0.5,0.769126,0.0461748,0,0.875,0.5,0.815301,0.0461748,0.5,1,0.5,0.861476,0.0461748,0.5,1,0.625,0.90765,0.0461748,0.5,1,0.75,0.953825,0.0461748,0.5,1,0.875,1,0,0,1,1";
      "khotkeysrc"."Data_3_5Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_5Triggers1"."GesturePointData" =
        "0,0.0416667,0.5,0,0,0.0416667,0.0416667,0.5,0,0.125,0.0833333,0.0416667,0.5,0,0.25,0.125,0.0416667,0.5,0,0.375,0.166667,0.0416667,0.5,0,0.5,0.208333,0.0416667,0.5,0,0.625,0.25,0.0416667,0.5,0,0.75,0.291667,0.0416667,0.5,0,0.875,0.333333,0.0416667,-0.5,0,1,0.375,0.0416667,-0.5,0,0.875,0.416667,0.0416667,-0.5,0,0.75,0.458333,0.0416667,-0.5,0,0.625,0.5,0.0416667,0,0,0.5,0.541667,0.0416667,0,0.125,0.5,0.583333,0.0416667,0,0.25,0.5,0.625,0.0416667,0,0.375,0.5,0.666667,0.0416667,0,0.5,0.5,0.708333,0.0416667,0,0.625,0.5,0.75,0.0416667,0,0.75,0.5,0.791667,0.0416667,0,0.875,0.5,0.833333,0.0416667,0.5,1,0.5,0.875,0.0416667,0.5,1,0.625,0.916667,0.0416667,0.5,1,0.75,0.958333,0.0416667,0.5,1,0.875,1,0,0,1,1";
      "khotkeysrc"."Data_3_5Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_6"."Comment" = ''
        Press, move right, move down, move right, release.
        Mozilla-style: Press, move down, move right, release.'';
      "khotkeysrc"."Data_3_6"."Enabled" = true;
      "khotkeysrc"."Data_3_6"."Name" = "Close Tab";
      "khotkeysrc"."Data_3_6"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_6Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_6Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_6Actions0"."Input" = ''
        Ctrl+W
      '';
      "khotkeysrc"."Data_3_6Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_6Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_6Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_6Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_6Triggers"."TriggersCount" = 2;
      "khotkeysrc"."Data_3_6Triggers0"."GesturePointData" =
        "0,0.0625,0,0,0,0.0625,0.0625,0,0.125,0,0.125,0.0625,0,0.25,0,0.1875,0.0625,0,0.375,0,0.25,0.0625,0.5,0.5,0,0.3125,0.0625,0.5,0.5,0.125,0.375,0.0625,0.5,0.5,0.25,0.4375,0.0625,0.5,0.5,0.375,0.5,0.0625,0.5,0.5,0.5,0.5625,0.0625,0.5,0.5,0.625,0.625,0.0625,0.5,0.5,0.75,0.6875,0.0625,0.5,0.5,0.875,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
      "khotkeysrc"."Data_3_6Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_6Triggers1"."GesturePointData" =
        "0,0.0625,0.5,0,0,0.0625,0.0625,0.5,0,0.125,0.125,0.0625,0.5,0,0.25,0.1875,0.0625,0.5,0,0.375,0.25,0.0625,0.5,0,0.5,0.3125,0.0625,0.5,0,0.625,0.375,0.0625,0.5,0,0.75,0.4375,0.0625,0.5,0,0.875,0.5,0.0625,0,0,1,0.5625,0.0625,0,0.125,1,0.625,0.0625,0,0.25,1,0.6875,0.0625,0,0.375,1,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
      "khotkeysrc"."Data_3_6Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_7"."Comment" = ''
        Press, move up, release.
        Conflicts with Opera-style 'Up #2', which is disabled by default.'';
      "khotkeysrc"."Data_3_7"."Enabled" = true;
      "khotkeysrc"."Data_3_7"."Name" = "New Tab";
      "khotkeysrc"."Data_3_7"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_7Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_7Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_7Actions0"."Input" = "Ctrl+Shift+N";
      "khotkeysrc"."Data_3_7Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_7Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_7Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_7Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_7Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_7Triggers0"."GesturePointData" =
        "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_7Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_8"."Comment" = "Press, move down, release.";
      "khotkeysrc"."Data_3_8"."Enabled" = true;
      "khotkeysrc"."Data_3_8"."Name" = "New Window";
      "khotkeysrc"."Data_3_8"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_8Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_8Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_8Actions0"."Input" = ''
        Ctrl+N
      '';
      "khotkeysrc"."Data_3_8Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_8Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_8Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_8Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_8Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_8Triggers0"."GesturePointData" =
        "0,0.125,0.5,0.5,0,0.125,0.125,0.5,0.5,0.125,0.25,0.125,0.5,0.5,0.25,0.375,0.125,0.5,0.5,0.375,0.5,0.125,0.5,0.5,0.5,0.625,0.125,0.5,0.5,0.625,0.75,0.125,0.5,0.5,0.75,0.875,0.125,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_8Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_9"."Comment" = "Press, move up, move down, release.";
      "khotkeysrc"."Data_3_9"."Enabled" = true;
      "khotkeysrc"."Data_3_9"."Name" = "Reload";
      "khotkeysrc"."Data_3_9"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_9Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_9Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_9Actions0"."Input" = "F5";
      "khotkeysrc"."Data_3_9Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_9Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_9Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_9Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_9Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_9Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_9Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."DirSelect Dialog"."DirSelectDialog Size" = "";
      "khotkeysrc"."DirSelect Dialog"."DirSelectDialog Sizex5b$dx5d" = "";
      "khotkeysrc"."General.$i"."AllowKDEAppsToRememberWindowPositions[$i]" =
        "";
      "khotkeysrc"."General.$i"."AllowKDEAppsToRememberWindowPositionsx5b$dix5d" =
        "";
      "khotkeysrc"."General.$i"."AllowKDEAppsToRememberWindowPositionsx5b$ix5d" =
        "";
      "khotkeysrc"."General.$i"."AllowKDEAppsToRememberWindowPositionsx5b$dx5d[$i]" =
        "";
      "khotkeysrc"."General.$i"."AllowKDEAppsToRememberWindowPositionsx5b$dx5dx5b$ix5d" =
        "";
      "khotkeysrc"."General.$i"."BrowserApplication[$i]" = "";
      "khotkeysrc"."General.$i"."BrowserApplicationx5b$dix5d" = "";
      "khotkeysrc"."General.$i"."BrowserApplicationx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."BrowserApplicationx5b$dx5d[$i]" = "";
      "khotkeysrc"."General.$i"."BrowserApplicationx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."ColorSchemeHash[$i]" = "";
      "khotkeysrc"."General.$i"."ColorSchemeHashx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."ColorSchemeHashx5b$dix5d" = "";
      "khotkeysrc"."General.$i"."ColorSchemeHashx5b$dx5d[$i]" = "";
      "khotkeysrc"."General.$i"."ColorSchemeHashx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."ColorScheme[$i]" = "";
      "khotkeysrc"."General.$i"."ColorSchemex5b$ix5d" = "";
      "khotkeysrc"."General.$i"."ColorSchemex5b$dix5d" = "";
      "khotkeysrc"."General.$i"."ColorSchemex5b$dx5d[$i]" = "";
      "khotkeysrc"."General.$i"."ColorSchemex5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."TerminalApplication[$i]" = "";
      "khotkeysrc"."General.$i"."TerminalApplicationx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."TerminalApplicationx5b$dix5d" = "";
      "khotkeysrc"."General.$i"."TerminalApplicationx5b$dx5d[$i]" = "";
      "khotkeysrc"."General.$i"."TerminalApplicationx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General.$i"."TerminalService[$i]" = "";
      "khotkeysrc"."General.$i"."TerminalServicex5b$ix5d" = "";
      "khotkeysrc"."General.$i"."TerminalServicex5b$dix5d" = "";
      "khotkeysrc"."General.$i"."TerminalServicex5b$dx5d[$i]" = "";
      "khotkeysrc"."General.$i"."TerminalServicex5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."AllowKDEAppsToRememberWindowPositions[$i]" =
        "";
      "khotkeysrc"."General/$i"."AllowKDEAppsToRememberWindowPositionsx5b$ix5d" =
        "";
      "khotkeysrc"."General/$i"."AllowKDEAppsToRememberWindowPositionsx5b$dix5d" =
        "";
      "khotkeysrc"."General/$i"."AllowKDEAppsToRememberWindowPositionsx5b$dx5d[$i]" =
        "";
      "khotkeysrc"."General/$i"."AllowKDEAppsToRememberWindowPositionsx5b$dx5dx5b$ix5d" =
        "";
      "khotkeysrc"."General/$i"."BrowserApplication[$i]" = "";
      "khotkeysrc"."General/$i"."BrowserApplicationx5b$dx5d[$i]" = "";
      "khotkeysrc"."General/$i"."BrowserApplicationx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."BrowserApplicationx5b$dix5d" = "";
      "khotkeysrc"."General/$i"."BrowserApplicationx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."ColorSchemeHash[$i]" = "";
      "khotkeysrc"."General/$i"."ColorSchemeHashx5b$dix5d" = "";
      "khotkeysrc"."General/$i"."ColorSchemeHashx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."ColorSchemeHashx5b$dx5d[$i]" = "";
      "khotkeysrc"."General/$i"."ColorSchemeHashx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."ColorScheme[$i]" = "";
      "khotkeysrc"."General/$i"."ColorSchemex5b$dix5d" = "";
      "khotkeysrc"."General/$i"."ColorSchemex5b$ix5d" = "";
      "khotkeysrc"."General/$i"."ColorSchemex5b$dx5d[$i]" = "";
      "khotkeysrc"."General/$i"."ColorSchemex5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."TerminalApplication[$i]" = "";
      "khotkeysrc"."General/$i"."TerminalApplicationx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."TerminalApplicationx5b$dix5d" = "";
      "khotkeysrc"."General/$i"."TerminalApplicationx5b$dx5d[$i]" = "";
      "khotkeysrc"."General/$i"."TerminalApplicationx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."General/$i"."TerminalService[$i]" = "";
      "khotkeysrc"."General/$i"."TerminalServicex5b$dix5d" = "";
      "khotkeysrc"."General/$i"."TerminalServicex5b$ix5d" = "";
      "khotkeysrc"."General/$i"."TerminalServicex5b$dx5d[$i]" = "";
      "khotkeysrc"."General/$i"."TerminalServicex5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."Gestures"."Disabled" = true;
      "khotkeysrc"."Gestures"."MouseButton" = 2;
      "khotkeysrc"."Gestures"."Timeout" = 300;
      "khotkeysrc"."GesturesExclude"."Comment" = "";
      "khotkeysrc"."GesturesExclude"."WindowsCount" = 0;
      "khotkeysrc"."Icons"."Theme" = "";
      "khotkeysrc"."Icons"."Themex5b$dx5d" = "";
      "khotkeysrc"."KDE"."LookAndFeelPackagex5b$dx5d" = "";
      "khotkeysrc"."KDE"."SingleClick" = "";
      "khotkeysrc"."KDE"."SingleClickx5b$dx5d" = "";
      "khotkeysrc"."KDE"."widgetStyle" = "";
      "khotkeysrc"."KDE"."widgetStylex5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Allow Expansion" = "";
      "khotkeysrc"."KFileDialog Settings"."Allow Expansionx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Automatically select filename extension" =
        "";
      "khotkeysrc"."KFileDialog Settings"."Automatically select filename extensionx5b$dx5d" =
        "";
      "khotkeysrc"."KFileDialog Settings"."Breadcrumb Navigation" = "";
      "khotkeysrc"."KFileDialog Settings"."Breadcrumb Navigationx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Decoration position" = "";
      "khotkeysrc"."KFileDialog Settings"."Decoration positionx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."LocationCombo Completionmode" = "";
      "khotkeysrc"."KFileDialog Settings"."LocationCombo Completionmodex5b$dx5d" =
        "";
      "khotkeysrc"."KFileDialog Settings"."PathCombo Completionmode" = "";
      "khotkeysrc"."KFileDialog Settings"."PathCombo Completionmodex5b$dx5d" =
        "";
      "khotkeysrc"."KFileDialog Settings"."Show Bookmarks" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Bookmarksx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Full Path" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Full Pathx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Inline Previews" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Inline Previewsx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Preview" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Previewx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Speedbar" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Speedbarx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Show hidden files" = "";
      "khotkeysrc"."KFileDialog Settings"."Show hidden filesx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort by" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort byx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort directories first" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort directories firstx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort hidden files last" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort hidden files lastx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort reversed" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort reversedx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."Speedbar Width" = "";
      "khotkeysrc"."KFileDialog Settings"."Speedbar Widthx5b$dx5d" = "";
      "khotkeysrc"."KFileDialog Settings"."View Style" = "";
      "khotkeysrc"."KFileDialog Settings"."View Stylex5b$dx5d" = "";
      "khotkeysrc"."KShortcutsDialog Settings"."Dialog Size" = "";
      "khotkeysrc"."KShortcutsDialog Settings"."Dialog Sizex5b$dx5d" = "";
      "khotkeysrc"."Main"."AlreadyImported" =
        "defaults,kde32b1,konqueror_gestures_kde321";
      "khotkeysrc"."Main"."Disabled" = false;
      "khotkeysrc"."PreviewSettings"."MaximumRemoteSize" = "";
      "khotkeysrc"."PreviewSettings"."MaximumRemoteSizex5b$dx5d" = "";
      "khotkeysrc"."Voice"."Shortcut" = "";
      "khotkeysrc"."WM.$i"."activeBackground[$i]" = "";
      "khotkeysrc"."WM.$i"."activeBackgroundx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."activeBackgroundx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."activeBackgroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."activeBackgroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."activeBlend[$i]" = "";
      "khotkeysrc"."WM.$i"."activeBlendx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."activeBlendx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."activeBlendx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."activeBlendx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."activeForeground[$i]" = "";
      "khotkeysrc"."WM.$i"."activeForegroundx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."activeForegroundx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."activeForegroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."activeForegroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBackground[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveBackgroundx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBackgroundx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBackgroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveBackgroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBlend[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveBlendx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBlendx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveBlendx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveBlendx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveForeground[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveForegroundx5b$ix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveForegroundx5b$dix5d" = "";
      "khotkeysrc"."WM.$i"."inactiveForegroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM.$i"."inactiveForegroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeBackground[$i]" = "";
      "khotkeysrc"."WM/$i"."activeBackgroundx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."activeBackgroundx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeBackgroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."activeBackgroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeBlend[$i]" = "";
      "khotkeysrc"."WM/$i"."activeBlendx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."activeBlendx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."activeBlendx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeBlendx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeForeground[$i]" = "";
      "khotkeysrc"."WM/$i"."activeForegroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."activeForegroundx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."activeForegroundx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."activeForegroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBackground[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveBackgroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveBackgroundx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBackgroundx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBackgroundx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBlend[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveBlendx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveBlendx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBlendx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveBlendx5b$dx5dx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveForeground[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveForegroundx5b$dx5d[$i]" = "";
      "khotkeysrc"."WM/$i"."inactiveForegroundx5b$dix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveForegroundx5b$ix5d" = "";
      "khotkeysrc"."WM/$i"."inactiveForegroundx5b$dx5dx5b$ix5d" = "";
      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kiorc"."Confirmations"."ConfirmTrash" = false;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "alwaysAsk";
      "klipperrc"."General"."IgnoreImages" = false;
      "klipperrc"."General"."KeepClipboardContents" = false;
      "klipperrc"."General"."SyncClipboards" = true;
      "krunnerrc"."Plugins"."baloosearchEnabled" = true;
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."Image" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."PreviewImage" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."SlidePaths" =
        "/nix/store/lxj91dk79z2p9hdwwvqv3d4qqsm0pcr0-breeze-qt5-5.27.9-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/";
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."Image" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."PreviewImage" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."SlidePaths" =
        "/nix/store/lxj91dk79z2p9hdwwvqv3d4qqsm0pcr0-breeze-qt5-5.27.9-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/";
      "kscreenlockerrc"."Greeter/Wallpaper/org/kde/image/General"."Image" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter/Wallpaper/org/kde/image/General"."PreviewImage" =
        "/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png";
      "kscreenlockerrc"."Greeter/Wallpaper/org/kde/image/General"."SlidePaths" =
        "/nix/store/lxj91dk79z2p9hdwwvqv3d4qqsm0pcr0-breeze-qt5-5.27.9-bin/share/wallpapers/,/etc/profiles/per-user/gotlou/share/wallpapers/,/run/current-system/sw/share/wallpapers/";
      "ksmserverrc"."General"."loginMode" = "emptySession";
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
      "kwalletrc"."org.freedesktop.secrets"."apiEnabled" = true;
      "kwalletrc"."org/freedesktop/secrets"."apiEnabled" = true;
      "kwinrc"."Desktops"."Id_1" = "d516980a-fdeb-4550-be70-5fef9371e24c";
      "kwinrc"."Desktops"."Id_2" = "834fd96c-503a-4be4-8d14-d6a5778f142f";
      "kwinrc"."Desktops"."Id_3" = "301b91c9-7fee-48eb-9e8a-261c1098666f";
      "kwinrc"."Desktops"."Id_4" = "d835caf0-292f-4b07-ac30-3bce9fb9833c";
      "kwinrc"."Desktops"."Id_5" = "3efa55ea-d5c6-420f-a6c8-4cbe45e58565";
      "kwinrc"."Desktops"."Id_6" = "87597bac-a0f8-4abe-b12f-45f76de0507d";
      "kwinrc"."Desktops"."Name_1" = "New Desktop";
      "kwinrc"."Desktops"."Name_2" = "New Desktop";
      "kwinrc"."Desktops"."Number" = 6;
      "kwinrc"."Desktops"."Rows" = 1;
      "kwinrc"."NightColor"."Active" = true;
      "kwinrc"."NightColor"."Mode" = "Constant";
      "kwinrc"."Plugins"."desktopchangeosdEnabled" = true;
      "kwinrc"."Plugins"."krohnkiteEnabled" = true;
      "kwinrc"."Plugins"."virtual-desktops-only-on-primaryEnabled" = false;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = true;
      "kwinrc"."Script-krohnkite"."enableMonocleLayout" = false;
      "kwinrc"."Script-krohnkite"."enableSpiralLayout" = false;
      "kwinrc"."Script-krohnkite"."enableSpreadLayout" = false;
      "kwinrc"."Script-krohnkite"."enableStairLayout" = false;
      "kwinrc"."Script-krohnkite"."enableThreeColumnLayout" = false;
      "kwinrc"."Script-krohnkite"."maximizeSoleTile" = true;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling.213a9620-187e-58a6-b80b-85d8fb95dfce"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling.23d84027-6b81-5a63-91b8-8e7e614d6fad"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling.39d57435-c689-565f-9c9a-2c7ad9dd22d6"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling.3b09003e-31fd-5563-a5d0-e1df30d8aa4c"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling.5b6a9424-3221-5907-9c11-ead99d739c27"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling.7bbc8dda-5a00-51d9-85b5-6a97e711ce29"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling.bd455426-91b5-5aa4-b78c-9e21c3c810ab"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling.cc55641a-b969-52cd-87bf-88d4810033db"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/213a9620-187e-58a6-b80b-85d8fb95dfce"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/23d84027-6b81-5a63-91b8-8e7e614d6fad"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/39d57435-c689-565f-9c9a-2c7ad9dd22d6"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/3b09003e-31fd-5563-a5d0-e1df30d8aa4c"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/5b6a9424-3221-5907-9c11-ead99d739c27"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/7bbc8dda-5a00-51d9-85b5-6a97e711ce29"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/934fd03a-38ac-54f0-a2fa-61823d0ca9d3"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/af4e3df3-df4c-53b2-bbe7-d94ee2f2815c"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/b490f0ea-ff25-5743-b36a-f61f427e8cc1"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/bd455426-91b5-5aa4-b78c-9e21c3c810ab"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Tiling/cc55641a-b969-52cd-87bf-88d4810033db"."tiles" = ''
        {"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      "kwinrc"."Tiling/fed895cb-d61f-5091-bfa3-30f6fd4f0352"."tiles" =
        ''{"layoutDirection":"horizontal","tiles":[]}'';
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;
      "kwinrc"."Windows"."Placement" = "Maximizing";
      "kwinrc"."Windows"."SeparateScreenFocus" = true;
      "kwinrc"."Windows"."SnapOnlyWhenOverlapping" = true;
      "kwinrc"."Xwayland"."Scale" = 1;
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."Description" =
        "thunderbird-secondary";
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."desktops" =
        "50eb6b2e-3e74-42fb-bb0c-24645902ed0f";
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."desktopsrule" = 2;
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."wmclass" =
        "Thunderbird";
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."wmclasscomplete" =
        true;
      "kwinrulesrc"."054ebae8-c83b-4924-ac77-b00b12f6d305"."wmclassmatch" = 2;
      "kwinrulesrc"."1"."Description" = "bismuth-fix-overlapping";
      "kwinrulesrc"."1"."minsize" = "1,1";
      "kwinrulesrc"."1"."minsizerule" = 2;
      "kwinrulesrc"."1"."types" = 1;
      "kwinrulesrc"."General"."count" = 1;
      "kwinrulesrc"."General"."rules" = 1;
      "kwinrulesrc"."b06d45a7-15d1-4e78-94a1-721d729da8a9"."Description" =
        "signal-secondary";
      "kwinrulesrc"."b06d45a7-15d1-4e78-94a1-721d729da8a9"."desktops" =
        "50eb6b2e-3e74-42fb-bb0c-24645902ed0f";
      "kwinrulesrc"."b06d45a7-15d1-4e78-94a1-721d729da8a9"."desktopsrule" = 2;
      "kwinrulesrc"."b06d45a7-15d1-4e78-94a1-721d729da8a9"."wmclass" = "Signal";
      "kwinrulesrc"."b06d45a7-15d1-4e78-94a1-721d729da8a9"."wmclassmatch" = 2;
      "kwinrulesrc"."ce9e74e9-f062-49db-8996-3854f2547537"."Description" =
        "bismuth-fix-overlapping";
      "kwinrulesrc"."ce9e74e9-f062-49db-8996-3854f2547537"."minsizerule" = 2;
      "kwinrulesrc"."ce9e74e9-f062-49db-8996-3854f2547537"."types" = 1;
      "plasma-localerc"."Formats"."LANG" = "en_IN";
      "plasmanotifyrc"."Notifications"."PopupPosition" = "TopRight";
      "plasmarc"."Wallpapers"."usersWallpapers" =
        "/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129170335.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129165840.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129153219.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221129110216.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128192154.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128161858.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221128161841.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221127161512.png,/home/gotlou/Pictures/wallpaper/God of War Ragnarök_20221127144544.png,/home/gotlou/Pictures/wallpaper/PXL_20220623_195037007.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_192003680.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_191049547.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220623_184054157.jpg,/home/gotlou/Pictures/wallpaper/PXL_20220410_073123359.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_111019412.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_111016660.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_110340969.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_110306245.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211017_122655523.PORTRAIT.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_180350726.NIGHT.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_174611447.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163340872.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163125571.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163122882.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_163115778.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_161752069.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211016_161737943.jpg,/home/gotlou/Pictures/wallpaper/IMG_0760.heic,/home/gotlou/Pictures/wallpaper/PXL_20211016_163212987.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_180722093.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_180718228.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_175850636.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_114329445.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_105859260.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_105557074.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_094727526.jpg,/home/gotlou/Pictures/wallpaper/PXL_20211015_093652065.jpg,/home/gotlou/Pictures/wallpaper/IMG_9956.JPG,/home/gotlou/Pictures/wallpaper/IMG_0296.JPG,/home/gotlou/Pictures/wallpaper/IMG_0596.JPG,/home/gotlou/Pictures/wallpaper/IMG_0677.JPG,/home/gotlou/Pictures/wallpaper/IMG_0767.JPG,/home/gotlou/Pictures/wallpaper/IMG_0759.JPG,/home/gotlou/Pictures/wallpaper/IMG_0806.JPG,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200704213904.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200718131532.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20200718131521.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210307124749.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311135625.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210324130751.png,/home/gotlou/Pictures/wallpaper/The Last of Us™ Part II_20210311140559.png,/home/gotlou/Pictures/wallpaper/God of War_20200216141951.png,/home/gotlou/Pictures/wallpaper/God of War_20191231131741.png,/home/gotlou/Pictures/wallpaper/God of War_20191226151341.png,/home/gotlou/Pictures/wallpaper/God of War_20190713120728.png,/home/gotlou/Pictures/wallpaper/God of War_20190511121620.png,/home/gotlou/Pictures/wallpaper/God of War_20190430150654.png,/home/gotlou/Pictures/wallpaper/God of War_20190430150654_1.png,/home/gotlou/Pictures/wallpaper/Uncharted 4_ A Thief’s End™_20200113144917.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20200224104658.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20200222130417.png,/home/gotlou/Pictures/wallpaper/Marvel's Spider-Man_20190831111403.png";
      "systemsettingsrc"."Open-with settings"."CompletionMode" = 1;
    };
  };
}
