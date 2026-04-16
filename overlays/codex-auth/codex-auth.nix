{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation {
  pname = "codex-auth";
  version = "0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "loongphy";
    repo = "codex-auth";
    rev = "0612f819e3d817995b4930a9ca6611fa7310d18a";
    hash = "sha256-lS1M9/lKlyNVsZAYgg40FDkKaVOAT0U2m5Vpl4HdfUk=";
  };

  nativeBuildInputs = [
    zig
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-global-cache"
    export ZIG_LOCAL_CACHE_DIR="$PWD/.zig-cache"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR" "$ZIG_LOCAL_CACHE_DIR"
    zig build -Doptimize=ReleaseSafe
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp zig-out/bin/codex-auth $out/bin/
    wrapProgram $out/bin/codex-auth \
      --set CODEX_AUTH_NODE_EXECUTABLE ${lib.getExe nodejs}
    runHook postInstall
  '';

  meta = {
    description = "CLI for switching Codex accounts";
    homepage = "https://github.com/Loongphy/codex-auth";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "codex-auth";
  };
}
