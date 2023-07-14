let
  nixpkgs = import <nixpkgs> {};
  mkShell = nixpkgs.mkShell.override { stdenv = nixpkgs.stdenvAdapters.useMoldLinker nixpkgs.stdenv; };
in
mkShell {
  name = "rustdev";
  buildInputs = [
    nixpkgs.pkgconfig
    nixpkgs.wayland.dev
    nixpkgs.xorg.libX11.dev
    nixpkgs.xorg.xcbutil.dev
    nixpkgs.xorg.xcbutilimage
    nixpkgs.libxkbcommon
    nixpkgs.openssl.dev
    nixpkgs.sqlite.dev
  ];
  shellHook = ''
    alias check-sig='gpgv --keyring ./tor.keyring signature.asc download.tar.xz'
  '';
}
