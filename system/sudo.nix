{ pkgs, ... }:
{
  security.sudo-rs.enable = false;
  security.sudo.enable = false;

  environment.systemPackages = [ pkgs.run0-sudo-shim ];
}
