{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  version = "v2.93";

  src = fetchFromGitHub {
    owner = "Xpl0itU";
    repo = "WiiUDownloader";
    rev = "a31ed6486acb0a06a61aed5cfca87821c0258573";
    sha256 = "sha256-/n2QybBTx63atGr04CdkYWgVgDOF3GE45R2nrwAO7sU=";
  };

  pname = "WiiuDownloader-db.go";

  buildPhase = ''
    ${lib.getExe python3} grabTitles.py
    cp db.go $out
  '';

  outputHash = "sha256-WPj3itOh2nVKaUk6sGBnuaf4SZpCdCO2OgG2hB8rMyQ=";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = {
    description = "db.go file containing titles for WiiUDownloader";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.rexies ];
    platforms = lib.platforms.all;
  };
}
