{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "island";
  version = "0-unstable-2025-12-11";

  src = fetchFromGitHub {
    owner = "landlock-lsm";
    repo = "island";
    rev = "11072fc6a8c2325a8a04600b4b89c3478fa5a468";
    hash = "sha256-1pSLaVGVvDbYEEzgCqwEhdDnksPpYEpg/61RSnC/wyk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "landlockconfig-0.1.0" = "sha256-4LOauaC3eTLvERp9E7HIcunzkJ7HHcLkLAmaSbisr/c=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "A sandboxing tool using Landlock for secure command execution";
    homepage = "https://github.com/landlock-lsm/island";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "island";
  };
})
