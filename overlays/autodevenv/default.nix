# Overlay to add autodevenv package to nixpkgs
final: prev: {
  autodevenv = prev.callPackage ./autodevenv.nix { };
}
