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
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "loongphy";
    repo = "codex-auth";
    rev = "a5d8910d308a28e5ba8b6124855464f9caa16cf3";
    hash = "sha256-PXd7DboBmKDBo3kdZwnim1W3XMhyHAUV6isZXbVjA7w=";
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
