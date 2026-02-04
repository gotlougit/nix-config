self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  autodevenv-overlay = import ./autodevenv/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  spotiflac = self.callPackage ./spotiflac.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  stremio-new = self.callPackage ./stremio-new.nix { };
  libra = self.callPackage ./libra.nix { };
  run0-sudo-shim = self.callPackage ./run0-sudo-shim.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  # } // (tokidoki-overlay self super) // (conty-overlay self super)
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (autodevenv-overlay self super)
