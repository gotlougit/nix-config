{ inputs }:
self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  hister-overlay = import ./hister/default.nix { inherit inputs; };
  codex-auth-overlay = import ./codex-auth/default.nix;
  litert-lm-overlay = import ./litert-lm/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  run0-sudo-shim = self.callPackage ./run0-sudo-shim.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  nsproxy = self.callPackage ./nsproxy.nix { };
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (hister-overlay self super)
// (codex-auth-overlay self super)
// (litert-lm-overlay self super)
