self: super: {
  guerrilla = self.callPackage ./guerrilla.nix { };
  aider = self.callPackage ./aider.nix { };
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  polonium = self.callPackage ./polonium.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
