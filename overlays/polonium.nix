{ lib, fetchFromGitHub, buildNpmPackage, kdePackages }:

# how to update:
# 1. check out the tag for the version in question
# 2. run `prefetch-npm-deps package-lock.json`
# 3. update npmDepsHash with the output of the previous step

buildNpmPackage {
  pname = "polonium-git";
  version = "1.0.0.beta1";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    rev = "56f9f1ae3a363ac12ce26e3e29086692e4dd3e50";
    hash = "sha256-AdMeIUI7ZdctpG/kblGdk1DBy31nDyolPVcTvLEHnNs=";
  };

  npmDepsHash = "sha256-kaT3Uyq+/JkmebakG9xQuR4Kjo7vk6BzI1/LffOj/eo=";

  # the installer does a bunch of stuff that fails in our sandbox, so just build here and then we
  # manually do the install
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "build install cleanall" "res src"
  '';

  nativeBuildInputs = [ kdePackages.kpackage ];

  dontNpmBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    kpackagetool6 --install pkg --packageroot $out/share/kwin/scripts

    runHook postInstall
  '';

  env.LANG = "C.UTF-8";

  meta = with lib; {
    description = "Auto-tiler that uses KWin 6+ tiling functionality";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kdePackages.kpackage.meta) platforms;
  };
}
