{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "nsproxy";
  version = "0-unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "nlzy";
    repo = "nsproxy";
    rev = "69a171dcfa5444ba88602eaf5c5457b48dc86f64";
    hash = "sha256-IOLY/J85OQg0vIMwkLYMyMAXBVZOh7OIADjXGLVUwgs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Linux tool to force applications to use a SOCKS5 or HTTP proxy using network namespaces";
    homepage = "https://github.com/nlzy/nsproxy";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "nsproxy";
  };
}
