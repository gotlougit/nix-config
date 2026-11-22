{
  lib,
  buildNimPackage,
  fetchFromCodeberg,
  openssl,
  pcre,
}:

buildNimPackage (finalAttrs: {
  pname = "shitter";
  version = "0-unstable-2026-11-22";

  src = fetchFromCodeberg {
    owner = "shitter";
    repo = "shitter";
    rev = "52ed1599b8baff97df51b3ca827e508dafbf60b7";
    hash = "sha256-LAljPJAho/x5CgcVIA0QRzeXpevjd3fp1TLyBfiUeIo=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    openssl
    pcre
  ];

  nimFlags = [
    "-d:release"
    "-d:danger"
    "-d:strip"
    "--mm:refc"
  ];

  postBuild = ''
    nim compile ${toString finalAttrs.nimFlags} -r tools/gencss
    nim compile ${toString finalAttrs.nimFlags} -r tools/rendermd
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Alternative Twitter front-end (Nitter fork)";
    homepage = "https://codeberg.org/shitter/shitter";
    license = lib.licenses.agpl3Only;
    mainProgram = "nitter";
  };
})
