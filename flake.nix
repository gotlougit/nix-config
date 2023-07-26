{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "sourcehut:~gotlou/code-sandbox";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox }:
    let
      system = "x86_64-linux";
      aarch64System = "aarch64-linux";

      code-sandbox-override = pkgs: {
        code-sandbox = import (inputs.code-sandbox) {
          inherit pkgs;
        };
      };
    in {
      nixpkgs.config = {
        packageOverrides = pkgs: if pkgs.lib.equalLists pkgs.system.system "x86_64-linux" then code-sandbox-override pkgs else pkgs;
        allowUnfree = true;
      };
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
            ./kratos/impermanence.nix
            ./kratos/hardware-configuration.nix
            ./kratos/configuration.nix
            ./kratos/user.nix
            ./kratos/services.nix
            ./kratos/opensnitch.nix
            ./kratos/networking.nix
            ./kratos/systemprograms.nix
            ./kratos/shell.nix
          ];
        };
        mimir = nixpkgs.lib.nixosSystem {
          system = aarch64System;
          specialArgs = { inherit inputs; };
          modules = [
            ./mimir/base.nix
            ./mimir/configuration.nix
            ./mimir/systemprograms.nix
            ./kratos/shell.nix
            ./kratos/networking.nix
          ];
        };
      };
    };
}

