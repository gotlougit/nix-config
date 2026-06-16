{ pkgs, inputs, ... }:

{
  imports = [ inputs.tau.homeManagerModules.tau ];

  # Misc packages for dev work that come in handy
  home.packages = [
    inputs.tau.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.tau-overseer = {
    enable = true;
    package = inputs.tau.packages.${pkgs.stdenv.hostPlatform.system}.default;
    allowedRoots = [
      "/home/gotlou/Code"
      "/home/gotlou/nixos"
    ];
  };

}
