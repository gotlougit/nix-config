# Overlay to add tokidoki package to nixpkgs
final: prev: {
  tokidoki = prev.callPackage ./tokidoki.nix { };
}
