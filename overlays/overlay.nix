self: super: {
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  chiaki-ng = self.kdePackages.callPackage ./chiaki-ng.nix {
    libplacebo = super.libplacebo.overrideAttrs (old: {
      src = old.src.override {
        # broken with latest -- pinning to rev used by upstream per https://github.com/streetpea/chiaki-ng/blob/96d535db41bb9c3b37fbffcf2402d51e891ff960/scripts/build-libplacebo.sh#L9
        rev = "c320f61e601caef2be081ce61138e5d51c1be21d";
        hash = "sha256-ZlKYgWz/Rkp4IPt6cJ+KNnzBB2s8jGZEamSAOIGyDuE=";
      };
    });
  };
  magit = self.callPackage ./magit/default.nix { };
}
