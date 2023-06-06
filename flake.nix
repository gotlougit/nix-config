{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "git+https://git.sr.ht/~gotlou/code-sandbox";

  outputs = inputs @ { self, nixpkgs, impermanence }:
    let system = "x86_64-linux"; in {
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
