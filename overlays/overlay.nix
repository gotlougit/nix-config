self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
# } // (tokidoki-overlay self super) // (conty-overlay self super)
} // (tokidoki-overlay self super)
