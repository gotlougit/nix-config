{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv; };
    in {
       devShells.${system}.default = mkShell {
        name = "rustdev";
        buildInputs = [
          pkgs.pkgconfig
          pkgs.openssl.dev
          pkgs.sqlite.dev
        ];
      };
    };
}

