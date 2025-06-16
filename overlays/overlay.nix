self: super: {
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  zed-editor-new = self.callPackage ./zed/zed.nix { };
}
