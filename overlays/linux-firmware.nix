{
  stdenvNoCC,
  fetchzip,
  lib,
}:
let
  source = {
    version = "59fbffa9ec8e4b0b31d2d13e715cf6580ad0e99c";
    sourceHash = "sha256-WyO/+fxQljfo6OXLC8/BomGmKtUQaJ1Lt9V5Fdv172g=";
    outputHash = "sha256-wHWPSyqxP+MGmerbc2v/hclFFJ7qKCDsupK5GASjp8s=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = source.version;

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
    hash = source.sourceHash;
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = source.outputHash;

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = {
    inherit version;
    updateScript = ./update.sh;
  };
}