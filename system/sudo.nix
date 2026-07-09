{ pkgs, inputs, ... }:
{
  imports = [ inputs.run0-sudo-shim.nixosModules.default ];
  
  security.sudo-rs.enable = false;
  security.sudo.enable = false;

  environment.systemPackages = [ pkgs.run0-sudo-shim ];
}
