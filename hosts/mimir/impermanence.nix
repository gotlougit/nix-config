{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist/system" = {
    directories = [
      "/var/lib/dnscrypt-proxy2"
      "/var/lib/nixos"
      "/var/lib/private"
      "/var/lib/systemd"
      "/var/lib/tailscale"
      "/var/log"
    ];
  };
}
