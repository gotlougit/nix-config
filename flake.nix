{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.code-sandbox.url = "sourcehut:~gotlou/code-sandbox";
  inputs.archiver.url = "sourcehut:~gotlou/archiveurl";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox, archiver, home-manager }:
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gotlou = import ./home/home.nix;
            }
            ./hosts/kratos/impermanence.nix
            ./hosts/kratos/hardware-configuration.nix
            ./hosts/kratos/boot.nix
            ./hosts/kratos/configuration.nix
            ./hosts/kratos/user.nix
            ./hosts/kratos/desktop.nix
            ./hosts/kratos/sound.nix
            ./hosts/shared/nix.nix
            ./hosts/shared/services/standard-services.nix
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

