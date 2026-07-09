# sometimes I ask myself:
# "Do I really have build this from source?".
# Yes, yes I fucking do.
# NOTE fuck go compile times for gtk
{
  lib,
  callPackage,
  buildGoModule,
  pkg-config,
  glib,
  wrapGAppsHook3,
  gtk3,
  fetchFromGitHub,
}:
buildGoModule (final: {
  pname = "WiiUDownloader";
  version = "v2.93";

  src = fetchFromGitHub {
    owner = "Xpl0itU";
    repo = "WiiUDownloader";
    rev = "a31ed6486acb0a06a61aed5cfca87821c0258573";
    sha256 = "sha256-/n2QybBTx63atGr04CdkYWgVgDOF3GE45R2nrwAO7sU=";
  };

  titles-db = callPackage ./titles.nix { };

  postPatch = ''
    cp ${final.titles-db} db.go
  '';

  modRoot = "./cmd/WiiUDownloader";

  subPackages = [
    "."
  ];

  vendorHash = "sha256-LG9hdXFbCBlQ/hIvO1yj8kVZTodjQVPfkv4sjtmi6SA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  passthru.titles-db = final.titles-db;

  meta = {
    mainProgram = "WiiUDownloader";
    description = "Application for downloading wiiu files";
    licenses = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.rexies ];
    platforms = lib.platforms.all;
  };
})
