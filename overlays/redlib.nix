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
  stdenv,
  llvmPackages,
}:

rustPlatform.buildRustPackage {
  pname = "redlib";
  version = "0.36.0-bleeding";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "a4d36e954cf1bd64f209cd8868c5a29edc81b374";
    hash = "sha256-siyD6A12UALQIV7BMd7zu1TaojleTEYtpxPszuhx1/Y=";
  };

  cargoHash = "sha256-eO3c7rlFna3DuO31etJ6S4c7NmcvgvIWZ1KVkNIuUqQ=";

  postInstall = ''
    install --mode=444 -D contrib/redlib.service $out/lib/systemd/system/redlib.service
    substituteInPlace $out/lib/systemd/system/redlib.service \
      --replace-fail "/usr/bin/redlib" "$out/bin/redlib"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl # needed by boring-sys/BoringSSL
    gitMinimal # needed by boring-sys build script
  ];

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
    description = "Private front-end for Reddit (Continued fork of Libreddit)";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    mainProgram = "redlib";
    maintainers = with lib.maintainers; [
      bpeetz
      Guanran928
    ];
  };
}
