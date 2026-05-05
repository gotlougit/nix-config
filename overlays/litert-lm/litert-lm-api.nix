{ lib
, stdenv
, autoPatchelfHook
, fetchurl
, libGL
, unzip
, vulkan-loader
, zlib
}:

let
  version = "0.11.0";

  # Map system to wheel tag (v0.11.0 uses py3-none-* tags)
  wheelTag = if stdenv.hostPlatform.isLinux then "manylinux_2_27_x86_64"
    else if stdenv.hostPlatform.isDarwin then "macosx_12_0_arm64"
    else throw "Unsupported platform for litert-lm-api";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/0b/e0/468888d42e55dfcd14874d6673b61d6e23bc78b4cbfaf7a6d870945f04e5/litert_lm_api-${version}-py3-none-${wheelTag}.whl";
    hash = "sha256-HlhwKl6BY2AH+hkET+DGlzJ3scvU9xP+bSLfQ7O6p/g=";
  };

in
stdenv.mkDerivation {
  pname = "litert-lm-api";
  inherit version;

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    stdenv.cc.cc.lib   # for libstdc++
    libGL              # for libEGL, libGLESv2 (GPU support)
    vulkan-loader      # for libvulkan (GPU support)
    zlib
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/lib/python3/site-packages
    unzip -o "${src}" -d $out/lib/python3/site-packages

    # Remove dist-info that came with the wheel
    rm -rf $out/lib/python3/site-packages/litert_lm_api-*.dist-info
  '';

  # Add the package directory to RPATH so bundled .so files can find each other
  preFixup = ''
    addAutoPatchelfSearchPath "$out/lib/python3/site-packages/litert_lm"
  '';

  meta = with lib; {
    description = "LiteRT-LM native inference library (prebuilt)";
    homepage = "https://github.com/google-ai-edge/litert-lm";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    maintainers = [ ];
  };
}
