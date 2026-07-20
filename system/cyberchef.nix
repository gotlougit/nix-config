{ pkgs, ... }:
let
  servicePort = 5080;
in
{
  systemd.services.cyberchef = {
    description = "Self-hosted CyberChef - Cyber Swiss Army Knife";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.miniserve}/bin/miniserve ${pkgs.cyberchef}/share/cyberchef --port ${toString servicePort} --index index.html";
      Restart = "on-failure";
      DynamicUser = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ servicePort ];
    tailscale0.allowedTCPPorts = [ servicePort ];
  };
}
