{ lib, pkgs, inputs, ... }:
let
  unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  # mitmweb 12 always requires authentication.  Caddy injects this token
  # for browser requests so the UI can be opened without a token in the URL.
  webToken = "mimir-a40ae3e342f409fd";
  # argon2 hash for the mitmweb UI token.
  webPasswordHash = "$argon2id$v=19$m=65536,t=3,p=4$vEvOyYcKlOHxK7+ai0AFlA$7m+wxzL3gGSH4cn0xKzyO+jtLu5kjlvoYD3qJwB6kjY";
  # systemd expands $VAR in ExecStart, so escape the hash's dollar signs.
  webPassword = lib.replaceStrings [ "$" ] [ "$$" ] webPasswordHash;
in
{
  systemd.services.mitmproxy = {
    description = "mitmproxy with the eMudhra CA";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "mitmproxy";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/mitmproxy";

      ExecStart = lib.concatStringsSep " " [
        "${unstable.mitmproxy}/bin/mitmweb"
        "--emudhra"
        "--set block_global=false"
        "--ssl-insecure"
        "--set web_open_browser=false"
        "--set web_password=${webPassword}"
        "--set confdir=%S/mitmproxy"
        "--listen-host 0.0.0.0"
        "--mode regular@28081"
        "--mode socks5@28082"
        "--mode transparent@28083"
        "--web-host 127.0.0.1"
        "--web-port 28089"
      ];

      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077";

      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts.":28080" = {
      logFormat = "output stderr";
      extraConfig = ''
        reverse_proxy 127.0.0.1:28089 {
          header_up Authorization "Bearer ${webToken}"
        }
      '';
    };
  };

  networking.firewall = {
    # Proxy ports are reachable from the LAN.
    allowedTCPPorts = [
      28081
      28082
    ];

    # The web UI is only reachable over Tailscale or from localhost.
    interfaces = {
      lo.allowedTCPPorts = [ 28080 ];
      tailscale0.allowedTCPPorts = [ 28080 ];
    };
  };
}
