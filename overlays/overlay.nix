self: super:
let
  radicale-decsync-overlay = import ./radicale-decsync/default.nix;
  tokidoki-overlay = import ./tokidoki/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  zed-editor-new = self.callPackage ./zed/zed.nix { };
} // (radicale-decsync-overlay self super) // (tokidoki-overlay self super)
