self: super: {
  guerrilla = self.callPackage ./guerrilla.nix {};
  linux-firmware = self.callPackage ./linux-firmware.nix {};
}
