{ inputs }:
self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  hister-overlay = import ./hister/default.nix { inherit inputs; };
  codex-auth-overlay = import ./codex-auth/default.nix;
  stremio-linux-shell-overlay = import ./stremio-linux-shell/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  spotiflac = self.callPackage ./spotiflac.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  run0-sudo-shim = self.callPackage ./run0-sudo-shim.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  # } // (tokidoki-overlay self super) // (conty-overlay self super)
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (hister-overlay self super)
// (codex-auth-overlay self super)
// (stremio-linux-shell-overlay self super)
