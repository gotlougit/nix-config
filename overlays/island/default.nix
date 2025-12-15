# Overlay to add island package to nixpkgs
final: prev: {
  island = prev.callPackage ./island.nix { };
}
