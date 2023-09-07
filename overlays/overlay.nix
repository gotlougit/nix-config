self: super: {
  guerrilla = self.callPackage ./guerrilla.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
