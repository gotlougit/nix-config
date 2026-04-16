# Overlay to add codex-auth package to nixpkgs
final: prev: {
  codex-auth = prev.callPackage ./codex-auth.nix { };
}
