self: super: {
  guerrilla = self.callPackage ./guerrilla.nix { };
  polonium = self.callPackage ./polonium.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
