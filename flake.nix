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

  inputs.stylix.url = "github:danth/stylix";
  inputs.stylix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

  inputs.microvm = {
    url = "github:astro/microvm.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, impermanence, code-sandbox, archiver
    , home-manager, plasma-manager, sshield, stylix, nix-index-database
    , nixos-cosmic, microvm }:
    let
      system = "x86_64-linux";
      aarch64System = "aarch64-linux";
    in {
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
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
          ];
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
              home-manager.sharedModules =
                [ plasma-manager.homeManagerModules.plasma-manager ];
              home-manager.users.gotlou = import ./home;
            }
            ./hosts/kratos
            ./system
          ];
        };
        zed-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ 
            microvm.nixosModules.microvm 
            ./vm/zed.nix
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

      # Define the runner as a package to avoid circular dependency
      packages.x86_64-linux.zed-vm-runner = nixpkgs.legacyPackages.x86_64-linux.writeShellScriptBin "zed-vm" ''
        #!/bin/bash
        echo "Starting Zed VM with access to /home/gotlou/Code"
        
        if systemctl --user is-active --quiet microvm@zed-vm 2>/dev/null; then
          echo "Zed VM is already running"
          exit 0
        fi
        nix run "${self}#nixosConfigurations.zed-vm.config.microvm.declaredRunner"
      '';
    };
}

