{ inputs }:
self: super:
let
  tokidoki-overlay = import ./tokidoki/default.nix;
  island-overlay = import ./island/default.nix;
  codex-auth-overlay = import ./codex-auth/default.nix;
  litert-lm-overlay = import ./litert-lm/default.nix;
  mullvad-tailscale-overlay = import ./mullvad-tailscale/default.nix;
in
{
  llama-cpp = self.callPackage ./llama-cpp.nix { };
  redlib = self.callPackage ./redlib.nix { };
  cloudflare-warp-old = self.callPackage ./cloudflare-warp-old.nix { };
  run0-sudo-shim = self.callPackage ./run0-sudo-shim.nix { };
  cliproxyapi = self.callPackage ./cliproxyapi.nix { };
  nsproxy = self.callPackage ./nsproxy.nix { };
  wiiudownloader = self.callPackage ./wiiudownloader { };
}
// (tokidoki-overlay self super)
// (island-overlay self super)
// (codex-auth-overlay self super)
// (litert-lm-overlay self super)
// (mullvad-tailscale-overlay self super)
