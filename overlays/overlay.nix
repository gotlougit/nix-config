self: super: {
  guerrilla = self.callPackage ./guerrilla.nix { };
  polonium = self.callPackage ./polonium.nix { };
  krohnkite = self.callPackage ./krohnkite.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
