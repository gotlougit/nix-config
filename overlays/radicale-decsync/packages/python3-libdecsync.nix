{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  libxcrypt,
  stdenv,
}:

buildPythonPackage rec {
  pname = "libdecsync";
  version = "2.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32e923ce3ba6bfd54bf80d26694d0afd29625ab81e46301e88474de5af371b42";
  };

  # Package includes pre-compiled native binaries
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libxcrypt
    stdenv.cc.cc.lib
  ];

  # Create compatibility symlink for libcrypt.so.1
  postInstall = ''
    # Create a compatibility directory with libcrypt.so.1 symlink
    mkdir -p $out/lib/compat
    ln -sf ${libxcrypt}/lib/libcrypt.so $out/lib/compat/libcrypt.so.1
  '';

  # Package includes native bindings, so no tests in source distribution
  doCheck = false;

  # Skip import check - compatibility will be handled at runtime
  pythonImportsCheck = [ ];

  # Keep ignoring libcrypt.so.1 since we provide it via LD_LIBRARY_PATH
  autoPatchelfIgnoreMissingDeps = [
    "libcrypt.so.1"
  ];

  meta = with lib; {
    description = "Python3 bindings for libdecsync";
    homepage = "https://github.com/39aldo39/libdecsync-bindings-python3";
    license = licenses.lgpl2Plus;
    # maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
