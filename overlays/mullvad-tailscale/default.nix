# Overlay to add mullvad-tailscale package to nixpkgs
final: prev: {
  mullvad-tailscale = prev.callPackage ./mullvad-tailscale.nix { };
}
