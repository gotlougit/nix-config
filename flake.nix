{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "sourcehut:~gotlou/code-sandbox";
  inputs.archiver.url = "sourcehut:~gotlou/archiveurl";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox, archiver }:
    let
      system = "x86_64-linux";
      aarch64System = "aarch64-linux";
    in {
      nixpkgs.config = {
        allowUnfree = true;
      };
      nixpkgs.overlays = [
        import (inputs.code-sandbox)
        import (inputs.archiver)
      ];
      images = {
        mimir = (self.nixosConfigurations.mimir.extendModules {
          modules = [ "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix" ];
        }).config.system.build.sdImage;
      };
      nixosConfigurations = {
        kratos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/kratos/impermanence.nix
            ./hosts/kratos/hardware-configuration.nix
            ./hosts/kratos/configuration.nix
            ./hosts/kratos/user.nix
            ./hosts/kratos/services.nix
            ./hosts/kratos/opensnitch.nix
            ./hosts/kratos/networking.nix
            ./hosts/kratos/systemprograms.nix
            ./hosts/kratos/shell.nix
          ];
        };
        mimir = nixpkgs.lib.nixosSystem {
          system = aarch64System;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/mimir/base.nix
            ./hosts/mimir/configuration.nix
            ./hosts/mimir/systemprograms.nix
            ./hosts/kratos/shell.nix
            ./hosts/kratos/networking.nix
          ];
        };
      };
    };
}

