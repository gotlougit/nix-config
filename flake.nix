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

  inputs.sshield.url = "github:gotlougit/sshield";
  inputs.sshield.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ { self, nixpkgs, impermanence, code-sandbox, archiver, home-manager, plasma-manager, sshield }:
    let
      system = "x86_64-linux";
      aarch64System = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
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
        import
        (inputs.sshield)
      ];
      images = {
        mimir = (self.nixosConfigurations.mimir.extendModules {
          modules = [ "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix" ];
        }).config.system.build.sdImage;
      };
      devShells.${system}.default = pkgs.mkShell {
        name = "nix-dev";
        buildInputs = with pkgs; [
          nil
          nixpkgs-fmt
          nodePackages.bash-language-server
        ];
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
              home-manager.users.gotlou = import ./home;
            }
            ./hosts/kratos
            ./system
          ];
        };
        mimir = nixpkgs.lib.nixosSystem {
          system = aarch64System;
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

