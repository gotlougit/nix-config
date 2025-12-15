{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  name = "run0-sudo-shim";
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  inherit name version;
  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    rev = "84b51f45909a281158538813a1e684cbb5c7d51c";
    hash = "sha256-Uobq7AbuyijTh3Frf+89KnWrcLjUZwai+c8LwV+wM1k=";
  };
  cargoHash = "sha256-S20tIf/eGiUwTSbwfFCPbNltv2zthMXIZpGRsKTKv2Q=";

  postInstall = ''
    mv $out/bin/${name} $out/bin/sudo
  '';

  meta = {
    description = "a shim imitating sudo, but using run0 in the background";
    mainProgram = name;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ grimmauld ];
  };
}
