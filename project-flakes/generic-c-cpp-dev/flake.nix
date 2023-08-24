{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv; };
    in {
       devShells.${system}.default = mkShell {
        name = "c_cpp_dev";
        buildInputs = [
          pkgs.pkgconfig
          pkgs.openssl.dev
          pkgs.sqlite.dev
          pkgs.gcc
          pkgs.gnumake
          pkgs.zig # Useful for cross compilation
          pkgs.llvmPackages_15.libclang
          pkgs.gdb
          pkgs.rr
          pkgs.tree-sitter
        ];
      };
    };
}

