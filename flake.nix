{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "git+https://git.sr.ht/~gotlou/code-sandbox";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox }:
    let
      system = "x86_64-linux"; 
    in {
      nixpkgs.config.packageOverrides = pkgs: {
        code-sandbox = import (inputs.code-sandbox) {
          inherit pkgs;
        };
      };
      nixosConfigurations = {
        kratos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
          ];
        };
      };
    };
}
