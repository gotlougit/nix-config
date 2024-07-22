{ lib
, stdenv
, fetchFromGitHub
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "krohnkite";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = version;
    hash = "sha256-8A3zW5tK8jK9fSxYx28b8uXGsvxEoUYybU0GaMD2LNw=";
  };

  nativeBuildInputs = [
    kdePackages.kpackage
  ];

  dontBuild = true;
  env.LANG = "C.UTF-8";

  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall

    kpackagetool6 --install ${src}/res/ --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/res/metadata.desktop $out/share/kservices5/krohnkite.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynamic tiling extension for KWin";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
    # inherit (src.meta) homepage;
    # inherit (kwindowsystem.meta) platforms;
  };
}
