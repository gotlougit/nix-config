{ pkgs, lib, inputs, ... }:
let
  # tor-browser = pkgs.callPackage ./legacy.nix { inherit inputs; };
  ff-addons = import ./addons.nix {
    ff-addons = inputs.ff-addons.packages.${pkgs.system};
    inherit (inputs.ff-addons.lib.${pkgs.system}) buildFirefoxXpiAddon;
  };
  profile = import ./profile.nix { inherit ff-addons pkgs; };
in
lib.mkMerge [
  {
    programs.tor-browser = {
      enable = true;
      # package = tor-browser;
      profiles.main = profile;
    };
  }
  (lib.mkIf (!pkgs.stdenv.isDarwin) {
    programs.firefox.profiles.new-ff = profile // { isDefault = false; id = 2; };
  })
]
