{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    { appId = "com.stremio.Stremio"; origin = "flathub";  }
  ];
}
