# Overlay to add litert-lm package to nixpkgs
final: prev:

{
  litert-lm = prev.callPackage ./litert-lm.nix { };
}
