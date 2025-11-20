{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, wrapGAppsHook3

# Runtime dependencies
, glib
, gtk3
, cairo
, pango
, atk
, gdk-pixbuf
, cups
, dbus
, expat
, fontconfig
, freetype
, alsa-lib
, at-spi2-atk
, at-spi2-core
, libuuid
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libXScrnSaver
, libxcb
, libdrm
, libxkbcommon
, libGL
, mesa
, nspr
, nss
, systemd
, libpulseaudio
, libnotify
, xdg-utils
, xorg
}:

stdenv.mkDerivation rec {
  pname = "antigravity";
  version = "1.11.3-6583016683339776";

  src = fetchurl {
    url = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/${version}/linux-x64/Antigravity.tar.gz";
    sha256 = "0nv1ln2cndd2kn7kgs7jmk0q44r0104vqxfcw9a736krz49aap82";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    cairo
    pango
    atk
    gdk-pixbuf
    cups
    dbus
    expat
    fontconfig
    freetype
    alsa-lib
    at-spi2-atk
    at-spi2-core
    libuuid
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libXScrnSaver
    libxcb
    libdrm
    libxkbcommon
    libGL
    mesa
    nspr
    nss
    systemd
    libpulseaudio
    libnotify
    xorg.libxshmfence
    xorg.libxkbfile
  ];

  # Gapps wrapper args will be set automatically
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $TMPDIR/antigravity
    tar -xzf $src -C $TMPDIR/antigravity
    sourceRoot=$TMPDIR/antigravity/Antigravity
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/antigravity $out/bin

    # Copy all application files
    cp -r * $out/lib/antigravity/

    # Fix permissions on chrome-sandbox for sandboxing
    chmod 4755 $out/lib/antigravity/chrome-sandbox || true

    # Create wrapper script
    makeWrapper $out/lib/antigravity/antigravity $out/bin/antigravity \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/lib/antigravity" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --set ELECTRON_IS_DEV 0 \
      --set NODE_ENV production \
      --set ANTIGRAVITY_PATH "$out/lib/antigravity" \
      "''${gappsWrapperArgs[@]}"

    # Create desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/antigravity.desktop <<EOF
    [Desktop Entry]
    Name=Antigravity
    Comment=Code Editing. Redefined.
    GenericName=Text Editor
    Exec=antigravity %F
    Icon=antigravity
    Type=Application
    StartupNotify=true
    StartupWMClass=Antigravity
    Categories=TextEditor;Development;IDE;
    MimeType=text/plain;inode/directory;
    Keywords=vscode;code;editor;antigravity;
    Actions=new-empty-window;

    [Desktop Action new-empty-window]
    Name=New Empty Window
    Exec=antigravity --new-window %F
    Icon=antigravity
    EOF

    # Install icons - check for actual icon files in the tarball
    for iconDir in $out/lib/antigravity/resources/app/resources/linux/icon \
                   $out/lib/antigravity/resources/app/resources/linux \
                   $out/lib/antigravity/resources/app/resources; do
      if [ -d "$iconDir" ]; then
        for icon in "$iconDir"/*.png "$iconDir"/*.svg; do
          if [ -f "$icon" ]; then
            size=$(basename "$icon" | grep -oE '[0-9]+x[0-9]+' || echo "scalable")
            if [ "$size" = "scalable" ] && [[ "$icon" == *.svg ]]; then
              mkdir -p $out/share/icons/hicolor/scalable/apps
              cp "$icon" $out/share/icons/hicolor/scalable/apps/antigravity.svg
            elif [ "$size" != "scalable" ]; then
              mkdir -p $out/share/icons/hicolor/$size/apps
              cp "$icon" $out/share/icons/hicolor/$size/apps/antigravity.png
            fi
          fi
        done 2>/dev/null || true
      fi
    done

    # Fallback icon if no icons found
    if [ ! -d $out/share/icons ]; then
      mkdir -p $out/share/pixmaps
      # Create a simple placeholder icon if none exists
      if [ -f $out/lib/antigravity/resources/app/resources/linux/code.png ]; then
        cp $out/lib/antigravity/resources/app/resources/linux/code.png $out/share/pixmaps/antigravity.png
      fi
    fi

    runHook postInstall
  '';

  # Add rpath for the bundled libraries
  postFixup = ''
    # Add self-reference for internal libraries
    patchelf --add-rpath $out/lib/antigravity $out/lib/antigravity/antigravity || true
    patchelf --add-rpath $out/lib/antigravity $out/lib/antigravity/*.so || true
  '';

  meta = with lib; {
    description = "Antigravity - A VSCode fork focused on simplicity";
    homepage = "https://antigravity.dev";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "antigravity";
  };
}
