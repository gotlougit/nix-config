{ lib, inputs, ... }: {
  nix = {
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      # Restrict nix usage to real users
      allowed-users = lib.mkDefault [ "@users" ];
      # Hard link identical files in the nix store
      auto-optimise-store = true;
    };
    # Garbage collect generations older than 7 days
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    # Use repo version of nixpkgs for nix operations
    # This prevents downloading latest flake every time you want to do something
    # This also makes non-flake nix commands fail, though
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];
}
