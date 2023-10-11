{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv; };
    in
    {
      devShells.${system}.default = mkShell {
        name = "go_dev";
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

