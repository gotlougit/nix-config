self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  zed-editor-new = self.callPackage ./zed/zed.nix { };
} // (tokidoki-overlay self super)
