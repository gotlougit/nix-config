{
  description = "Generic Rust Dev Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          mkShell = pkgs.mkShell.override {
            stdenv = if pkgs.stdenv.isLinux then pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv else pkgs.stdenv;
          };
        in
        {
          default = mkShell {
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
              pkgs.tree-sitter
              pkgs.gdb
            ]
            ++ pkgs.lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [ pkgs.cargo-rr ];
          };
        }
      );
    };
}
