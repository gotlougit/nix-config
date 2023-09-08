{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.plasma-manager.url = "github:pjones/plasma-manager";
  inputs.plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.plasma-manager.inputs.home-manager.follows = "home-manager";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "sourcehut:~gotlou/code-sandbox";
  inputs.code-sandbox.inputs.nixpkgs.follows = "nixpkgs";
  inputs.archiver.url = "sourcehut:~gotlou/archiveurl";
  inputs.archiver.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox, archiver, home-manager, plasma-manager }:
    let
      system = "x86_64-linux";
      aarch64System = "aarch64-linux";
    in
    {
      nixpkgs.config = {
        allowUnfree = true;
      };
      nixpkgs.overlays = [
        import
        (inputs.code-sandbox)
        import
        (inputs.archiver)
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
            home-manager.nixosModules.home-manager
            {
              # Pass flake input to home-manager
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Ref: https://github.com/pjones/plasma-manager/issues/14
              # This is the way to import "plasma-manager" in home-manager
              # in such a config
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              home-manager.users.gotlou = import ./home/home.nix;
            }
            ./hosts/kratos/impermanence.nix
            ./hosts/kratos/hardware-configuration.nix
            ./hosts/kratos/boot.nix
            ./hosts/kratos/configuration.nix
            ./hosts/kratos/user.nix
            ./hosts/kratos/services/desktop.nix
            ./hosts/kratos/services/sound.nix
            ./hosts/shared/nix.nix
            ./hosts/shared/services/standard-services.nix
            ./hosts/kratos/services/tailscale-custom.nix
            ./hosts/shared/services/bluetooth.nix
            ./hosts/shared/services/opensnitch.nix
            ./hosts/shared/services/warp.nix
            ./hosts/shared/services/waydroid.nix
            ./hosts/shared/services/virt.nix
            ./hosts/shared/services/dns-resolver.nix
            ./hosts/shared/services/oom.nix
            ./hosts/shared/networking.nix
            ./hosts/kratos/systemprograms.nix
            ./hosts/shared/shell.nix
          ];
        };
        mimir = nixpkgs.lib.nixosSystem {
          system = aarch64System;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/mimir/base.nix
            ./hosts/mimir/configuration.nix
            ./hosts/mimir/systemprograms.nix
            ./hosts/shared/shell.nix
            ./hosts/shared/networking.nix
            ./hosts/shared/services/dns-resolver.nix
            ./hosts/shared/services/oom.nix
            ./hosts/shared/services/standard-services.nix
            ./hosts/shared/nix.nix
          ];
        };
      };
    };
}

