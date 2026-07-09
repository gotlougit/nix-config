{ inputs }:
self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  codex-auth-overlay = import ./codex-auth/default.nix;
  litert-lm-overlay = import ./litert-lm/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  redlib = self.callPackage ./redlib.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  nsproxy = self.callPackage ./nsproxy.nix { };
  wiiudownloader = self.callPackage ./wiiudownloader { };
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (codex-auth-overlay self super)
// (litert-lm-overlay self super)
