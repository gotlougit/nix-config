self: super: {
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
