{ lib, stdenv, fetchurl, autoPatchelfHook, alsa-lib, libGL, libxkbcommon, mesa
, vulkan-loader, wayland, xorg, zlib, }:

stdenv.mkDerivation rec {
  pname = "zed-editor";
  version = "0.190.6";

  src = fetchurl {
    url =
      "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz";
    hash = "sha256-2cZOGgFk/GVJksidk1MsiS0tyvelhB9ZUCVKzabFACc=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    libGL
    libxkbcommon
    mesa
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libxcb
    zlib
  ];

  dontStrip = true;

  appendRunpaths = lib.makeLibraryPath [ wayland vulkan-loader libGL ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec $out/share

    cp bin/zed $out/bin/zed
    cp bin/zed $out/bin/zeditor
    cp libexec/zed-editor $out/libexec/zed-editor

    cp -a share $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zed";
  };
}
