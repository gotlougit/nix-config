{
  # Description, write anything or even nothing
  description = "gotlou's NixOS Flake";

  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Directly pull hardware info from NixOS repos
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    # Define a system called "nixos"
    nixosConfigurations."kratos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.thinkpad-e14-amd
        ./configuration.nix
      ];
    };

    # You can define many systems in one Flake file.
    # NixOS will choose one based on your hostname.
    #
    # nixosConfigurations."nixos2" = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ./configuration2.nix
    #   ];
    # };
  };
}
