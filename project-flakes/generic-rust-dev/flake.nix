{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkShell = pkgs.mkShell.override {
        stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv;
      };
    in {
      devShells.${system}.default = mkShell {
        name = "rustdev";
        shellHook = ''
          export CARGO_HOME="$(realpath ./.localcargo)"
          export _ZO_DATA_DIR="$(realpath ./.localzoxide)"
        '';
        buildInputs = [
          pkgs.pkg-config
          pkgs.openssl.dev
          pkgs.sqlite.dev
          pkgs.rustc
          pkgs.cargo
          pkgs.rustfmt
          pkgs.clippy
          pkgs.rust-analyzer
          pkgs.cargo-rr
          pkgs.tree-sitter
          pkgs.gdb
        ];
      };
    };
}

