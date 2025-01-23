self: super: {
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  magit = self.callPackage ./magit/default.nix { };
}
