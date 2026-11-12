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
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "ba116c1186f6b0f9d45f0ae50c827e13eb2f5ea2";
    hash = "sha256-qv7vIls9BwgwDQuKEQU72J10MpaMfcLvIGfzl628eNU=";
  };

  cargoHash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";

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
