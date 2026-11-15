{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

  inputs.flossDesktop.url = "github:gotlougit/floss-desktop";
  inputs.flossDesktop.inputs.nixpkgs.follows = "nixpkgs";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.plasma-manager.url = "github:pjones/plasma-manager";
  inputs.plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.plasma-manager.inputs.home-manager.follows = "home-manager";

  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.impermanence.inputs.nixpkgs.follows = "nixpkgs";

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

  inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  inputs.hister.url = "github:asciimoo/hister";
  inputs.hister.inputs.nixpkgs.follows = "nixpkgs";

  inputs.llm-agents.url = "github:numtide/llm-agents.nix";
  inputs.llm-agents.inputs.nixpkgs.follows = "nixpkgs";

  inputs.run0-sudo-shim.url = "sourcehut:~gotlou/run0-sudo-shim";
  inputs.run0-sudo-shim.inputs.nixpkgs.follows = "nixpkgs";

  inputs.lightpanda.url = "github:gotlougit/lightpanda-browser";
  inputs.lightpanda.inputs.nixpkgs.follows = "nixpkgs";

  inputs.warp-re.url = "github:gotlougit/warp-re";
  inputs.warp-re.inputs.nixpkgs.follows = "nixpkgs";

  inputs.omega.url = "sourcehut:~gotlou/pi-omega";
  inputs.omega.inputs.nixpkgs.follows = "nixpkgs";
  inputs.omega.inputs.home-manager.follows = "home-manager";

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      mimir = inputs.nixos-raspberrypi.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/mimir ];
      };
    in
    {
      overlays.default = final: prev: (import ./overlays/overlay.nix { inherit inputs; } final prev);

      images.mimir =
        (mimir.extendModules {
          modules = [
            inputs.nixos-raspberrypi.nixosModules.sd-image
            ./hosts/mimir/sd-image.nix
          ];
        }).config.system.build.sdImage;

      nixosConfigurations = {
        mimir = mimir;
        kratos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.flossDesktop.nixosModules.default
            {
              nixpkgs.overlays = [
                self.overlays.default
              ];
            }
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
      };
    };
}
