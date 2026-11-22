{ inputs, ... }:
self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  codex-auth-overlay = import ./codex-auth/default.nix;
  litert-lm-overlay = import ./litert-lm/default.nix;
  kittygram-overlay = import ./kittygram/default.nix;
  shitter-overlay = import ./shitter/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  # Redlib needs a newer Rust than the nixos-raspberrypi nixpkgs pin.
  redlib = inputs.nixpkgs.legacyPackages.${self.stdenv.hostPlatform.system}.callPackage ./redlib.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  nsproxy = self.callPackage ./nsproxy.nix { };
  wiiudownloader = self.callPackage ./wiiudownloader { };
  ps5upload = self.callPackage ./ps5upload { };
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (codex-auth-overlay self super)
// (litert-lm-overlay self super)
// (kittygram-overlay self super)
// (shitter-overlay self super)
