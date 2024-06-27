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
        name = "go_dev";
        shellHook = ''
          export GOHOME="$(realpath ./.localgohome)"
          export GOMODCACHE="$(realpath ./.localgomod)"
          export GOCACHE="$(realpath ./.localgocache)"
          export _ZO_DATA_DIR="$(realpath ./.localzoxide)"
        '';
        buildInputs = [
          pkgs.pkg-config
          pkgs.go
          pkgs.gopls
          pkgs.gdb
          pkgs.rr
          pkgs.tree-sitter
        ];
      };
    };
}

