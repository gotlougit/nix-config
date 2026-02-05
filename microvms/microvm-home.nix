{ pkgs, ... }:
{
  imports = [ ../home/minimal.nix ];

  # Microvm-specific additional packages
  home.packages = with pkgs; [
  ];
}
