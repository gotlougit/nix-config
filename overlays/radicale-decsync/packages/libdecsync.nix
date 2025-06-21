{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdecsync";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "39aldo39";
    repo = "libdecsync";
    rev = "v${version}";
    sha256 = "16fqq8inhf9ssb6sjayr1pa47xvpfkiykdmzhyy0kw2bpzr2jwih";
  };

  # For now, use precompiled binaries since the build process for Kotlin native is complex
  libdecsync_so = fetchurl {
    url = "https://github.com/39aldo39/libdecsync/releases/download/v${version}/libdecsync_amd64.so";
    sha256 = "0gmv1g0zwvdrch2hgvpzjmfp831h125dz9n01xs620fgbr8ggk0l";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp ${libdecsync_so} $out/lib/libdecsync.so

    # Install headers if they exist in the source
    if [ -d src/nativeInterop/cinterop ]; then
      mkdir -p $out/include
      cp -r src/nativeInterop/cinterop/*.h $out/include/ || true
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Native library for DecSync synchronization";
    longDescription = ''
      libdecsync is a native library that provides DecSync functionality for
      synchronizing data across devices using a shared directory approach.
      DecSync allows synchronization of contacts, calendars, and other data
      without requiring a central server.
    '';
    homepage = "https://github.com/39aldo39/libdecsync";
    license = licenses.lgpl2Plus;
    # maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
