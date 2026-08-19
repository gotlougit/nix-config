# Overlay: build tailscale from the gotlougit fork
# (upstream tailscale + Cloudflare WARP/MASQUE support).
#
# The fork's go.mod requires go >= 1.26.6 while nixpkgs' default go is 1.26.5,
# so we rebind buildGoModule to go_1_27 for this package only.
final: prev: {
  tailscale = final.callPackage ./tailscale.nix {
    buildGoModule = final.buildGoModule.override { go = final.go_1_27; };
  };
}