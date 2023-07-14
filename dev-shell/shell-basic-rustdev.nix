let
  nixpkgs = import <nixpkgs> {};
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "rustdev";
    buildInputs = [
      pkgconfig
      openssl.dev
      sqlite.dev
      ];
    OPENSSL_DEV=openssl.dev;

    shellHook = ''
      alias check-sig='gpgv --keyring ./tor.keyring signature.asc download.tar.xz'
    '';
  }
