{
  lib,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  perl,
  gitMinimal,
  go,
  zstd,
  stdenv,
  llvmPackages,
}:

rustPlatform.buildRustPackage {
  pname = "redlib";
  version = "0.36.0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "Nachtalb";
    repo = "redlib";
    rev = "99fadfd286d3d80692354f598ab0e85fdaece8b5";
    hash = "sha256-Bw8CKM/mb0Uf3J8bfvp7BygNVmpfL7AcBjMhXAnEK8A=";
  };

  cargoHash = "sha256-FonBAl9QqAVVxzSDq1OCENnsIkM5j5V3uDU5hr9YEmQ=";

  postInstall = ''
    install --mode=444 -D contrib/redlib.service $out/lib/systemd/system/redlib.service
    substituteInPlace $out/lib/systemd/system/redlib.service \
      --replace-fail "/usr/bin/redlib" "$out/bin/redlib"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl # needed by btls-sys/BoringSSL
    gitMinimal # needed by btls-sys build script
    go # needed by BoringSSL's assembly generation
  ];

  buildInputs = [ zstd ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # bindgen needs to find C headers (stdlib.h etc.)
  # On Linux, libc headers are in a separate .dev output; on Darwin they
  # come from the SDK and libclang already knows where to find them.
  BINDGEN_EXTRA_CLANG_ARGS =
    if stdenv.hostPlatform.isDarwin then
      "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.versions.major llvmPackages.libclang.version}/include"
    else
      "-isystem ${stdenv.cc.libc.dev}/include -isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.versions.major llvmPackages.libclang.version}/include";

  doCheck = false;

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  passthru = {
    tests = nixosTests.redlib;
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Private front-end for Reddit (Nachtalb fork)";
    homepage = "https://github.com/Nachtalb/redlib";
    license = lib.licenses.agpl3Only;
    mainProgram = "redlib";
  };
}
