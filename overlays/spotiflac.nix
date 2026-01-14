{
  lib,
  autoPatchelfHook,
  buildGoModule,
  fetchFromGitHub,
  wails,
  pkg-config,
  gtk3,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  webkitgtk_4_1,
  makeDesktopItem,
}:
buildGoModule rec {
  pname = "spotiflac";
  version = "7.0.4";

  src = fetchFromGitHub {
    owner = "afkarxyz";
    repo = "SpotiFLAC";
    rev = "0f2174bf802e90dfef420245f306785dac539a92";
    hash = "sha256-hhVtOEq54yHqat+ZeTOJfytfeMrE9u0M9XAzAFBr6tM=";
  };

  vendorHash = "sha256-EffQyXBMre65h+k/vN56Lvm9dJmtUV9YQRhdoqd+pbU=";

  # Go modules derivation doesn't need pnpm
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: !(lib.hasPrefix "pnpm" (drv.pname or drv.name or ""))) (
      oldAttrs.nativeBuildInputs or [ ]
    );
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/frontend";
    fetcherVersion = 1;
    hash = "sha256-F2DM3xoElOE0ZS+b2DC66thqLKNZPYcYz1wW10WBVU8=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = "audio-x-flac";
    desktopName = "SpotiFLAC";
    comment = "Get Spotify tracks in true FLAC from Tidal, Qobuz & Amazon Music";
    categories = [
      "Audio"
      "AudioVideo"
    ];
    terminal = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pnpmConfigHook
    pkg-config
    wails
    nodejs
    pnpm
    webkitgtk_4_1
  ];

  buildInputs = [
    pkg-config
    gtk3
    webkitgtk_4_1
  ];

  pnpmRoot = "frontend";

  # Patch go.mod to accept available Go version
  # Delete vendor directory since it's out of sync with go.mod
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.5" "go 1.25"
    rm -rf vendor
  '';

  # Wails needs a writable home directory
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  buildPhase = ''
    runHook preBuild
    wails build -tags webkit2_41 -m -o ${pname}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/applications
    cp build/bin/${pname} $out/bin/
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    chmod +x $out/share/applications/*.desktop
    runHook postInstall
  '';

  meta = with lib; {
    description = "Get Spotify tracks in true FLAC from Tidal, Qobuz & Amazon Music";
    homepage = "https://github.com/afkarxyz/SpotiFLAC";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "spotiflac";
  };
}
