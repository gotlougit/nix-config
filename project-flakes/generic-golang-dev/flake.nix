{
  description = "Generic Golang Dev Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          mkShell = pkgs.mkShell.override {
            stdenv = if pkgs.stdenv.isLinux then
              pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv
            else
              pkgs.stdenv;
          };
        in {
          default = mkShell {
            name = "go_dev";
            shellHook = ''
              export GOHOME="$(realpath ./.localgohome)"
              export GOMODCACHE="$(realpath ./.localgomod)"
              export GOCACHE="$(realpath ./.localgocache)"
              export _ZO_DATA_DIR="$(realpath ./.localzoxide)"
            '';
            buildInputs =
              [ pkgs.pkg-config pkgs.go pkgs.gopls pkgs.gdb pkgs.tree-sitter ]
              ++ pkgs.lib.optionals
              (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [ pkgs.rr ];
          };
        });
    };
}
