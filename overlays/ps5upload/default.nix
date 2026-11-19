{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  stdenvNoCC,
  unzip,
}:

let
  pname = "ps5upload";
  version = "12.6.8";

  cpu = stdenvNoCC.hostPlatform.parsed.cpu.name;

  arch =
    {
      x86_64 = "x64";
      aarch64 = "arm64";
    }
    .${cpu} or (throw "ps5upload: unsupported cpu ${cpu}");

  release = fetchurl {
    url = "https://github.com/phantomptr/ps5upload/releases/download/v${version}/PS5Upload-${version}-linux-${arch}.zip";
    hash =
      {
        x86_64 = "sha256-m/JALu0y/znjqr7fwv/mffamRzMnrkW+4fOO3efgwQ4=";
        aarch64 = "sha256-7bWI+xzEw9ACaEmPAWPOtXO3YDPafi6aujAFR4SB63U=";
      }
      .${cpu} or (throw "ps5upload: unsupported cpu ${cpu}");
  };

  appimage = stdenvNoCC.mkDerivation {
    name = "${pname}-${version}-appimage";

    src = release;

    nativeBuildInputs = [ unzip ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      unzip -q $src PS5Upload.AppImage
      install -Dm755 PS5Upload.AppImage $out/PS5Upload.AppImage

      runHook postInstall
    '';
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = "${appimage}/PS5Upload.AppImage";

    postExtract = ''
      # AppRun puts the bundled libraries first in LD_LIBRARY_PATH. Its older
      # readline then shadows the Nix readline used by bash, so any shell the
      # app spawns dies with an undefined rl_completion_rewrite_hook.
      rm -f $out/usr/lib/libreadline.so.8

      # Use the Wayland libraries from the FHS, matching the Mesa/EGL stack
      # selected below instead of the older libraries bundled in the AppImage.
      rm -f \
        $out/usr/lib/libwayland-cursor.so.0 \
        $out/usr/lib/libwayland-egl.so.1 \
        $out/usr/lib/libwayland-server.so.0
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs =
    pkgs: with pkgs; [
      mesa
      libglvnd
      libgpg-error
      libva
      vulkan-loader
    ];

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/PS5Upload.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=ps5upload-desktop' 'Exec=${pname}' \
      --replace-fail 'Icon=ps5upload-desktop' 'Icon=${pname}'

    for size in 32x32 128x128 256x256@2; do
      install -Dm644 ${appimageContents}/usr/share/icons/hicolor/$size/apps/ps5upload-desktop.png \
        $out/share/icons/hicolor/$size/apps/${pname}.png
    done

    wrapProgram "$out/bin/${pname}" \
      --set QT_PLUGIN_PATH "" \
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --set-default __EGL_VENDOR_LIBRARY_FILENAMES /usr/share/glvnd/egl_vendor.d/50_mesa.json \
      --set-default LIBGL_DRIVERS_PATH /usr/lib/dri \
      --set-default GBM_BACKENDS_PATH /usr/lib/gbm \
      --set-default LIBVA_DRIVERS_PATH /usr/lib/dri
  '';

  meta = {
    description = "All-in-one PS5 companion app to transfer, install and manage games, saves and homebrew";
    homepage = "https://github.com/phantomptr/ps5upload";
    license = with lib.licenses; [
      gpl3Only
      unfree
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = pname;
  };
}
