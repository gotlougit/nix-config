# Overlay for the Kittygram Instagram frontend.
final: prev: {
  kittygram = final.callPackage ./kittygram.nix { };
}