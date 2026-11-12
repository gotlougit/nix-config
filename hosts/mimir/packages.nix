{ pkgs, ... }:
{
  # Keep this tiny.  Nix is only here so the host can receive store paths
  # over SSH; there is deliberately no nix-daemon.
  environment.systemPackages = with pkgs; [
    curl
    ghostty.terminfo
    nix
    rsync
    tailscale
  ];
}
