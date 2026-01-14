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

  inputs.sshield.url = "sourcehut:~gotlou/sshield";
  inputs.sshield.inputs.nixpkgs.follows = "nixpkgs";

  inputs.stylix.url = "github:danth/stylix";
  inputs.stylix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

  inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  inputs.claus.url = "sourcehut:~maan2003/claus";
  inputs.claus.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      # Systems are defined in the host configurations
    in
    {
      overlays.default =
        final: prev:
        (import ./overlays/overlay.nix final prev)
        // {
          claus = inputs.claus.packages.${final.system}.default.overrideAttrs (prevAttrs: {
            doCheck = false;
          });
        };
      images = {
        mimir =
          (self.nixosConfigurations.mimir.extendModules {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ];
          }).config.system.build.sdImage;
      };
      nixosConfigurations = {
        kratos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ self.overlays.default ]; }
            home-manager.nixosModules.home-manager
            {
              # Pass flake input to home-manager
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              home-manager.users.gotlou = import ./home;
            }
            ./hosts/kratos
            ./system
          ];
        };
        mimir = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/mimir/base.nix
            ./hosts/mimir/configuration.nix
            ./hosts/mimir/systemprograms.nix
            ./hosts/mimir/services/tailscale.nix
            ./system/networking.nix
            ./system/zram.nix
            ./system/dns-resolver.nix
            ./system/oom.nix
            ./system/standard-services.nix
            ./system/nix.nix
          ];
        };
      };
    };
}
