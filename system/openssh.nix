{ ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      MaxAuthTries = 10;
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  systemd.services."sshd@".serviceConfig = {
    # Protect Impermanence paths, which are full of private data
    InaccessiblePaths = [ "/persist" ];
  };
}
