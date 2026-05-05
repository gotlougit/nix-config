# Overlay to add litert-lm package to nixpkgs
final: prev:

let
  litert-lm-api = prev.callPackage ./litert-lm-api.nix { };
in
{
  litert-lm = prev.callPackage ./litert-lm.nix {
    inherit litert-lm-api;
  };
}
