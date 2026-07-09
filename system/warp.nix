{ pkgs, ... }:
{
  # Enable warp-svc to allow connections to the Cloudflare VPN
  systemd.packages = [ pkgs.cloudflare-warp ];
  services.cloudflare-warp.enable = true;
  services.cloudflare-warp.openFirewall = true;
  systemd.services.cloudflare-warp = {
    enable = true;
    after = [ ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      StateDirectory = "cloudflare-warp";
      # DynamicUser = true;
      # User = "warp";
      UMask = "0077";
      # Hardening
      NoNewPrivileges = true;
      LockPersonality = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "noaccess";
      ProtectSystem = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      InaccessiblePaths = "/persist";
      CapabilityBoundingSet = [
        ""
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_ADMIN"
      ];
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      ProtectHome = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@known"
        "~@clock"
        "~@cpu-emulation"
        "~@raw-io"
        "~@reboot"
        "~@mount"
        "~@obsolete"
        "~@swap"
        "~@debug"
        "~@keyring"
        "~@pkey"
      ];
    };
  };
  environment.systemPackages = with pkgs; [ cloudflare-warp socat ];

  # Convenience service to start warp in proxy mode and register on boot
  systemd.services.warp-cli-proxy-setup = {
    enable = true;
    after = [
      "network-online.target"
      "cloudflare-warp.service"
    ];
    wants = [
      "network-online.target"
      "cloudflare-warp.service"
    ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos registration delete || true
      ${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos registration new || true
      ${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos mode proxy
      ${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos proxy port 6667
      ${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos connect
    '';
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
    };
  };

  networking.firewall.interfaces = {
    lo.allowedTCPPorts = [ 6666 ];
    tailscale0.allowedTCPPorts = [ 6666 ];
  };

  # Relay warp proxy (bound to 127.0.0.1:6667) to all interfaces on port 6666
  # so it can be reached over Tailscale or LAN
  systemd.services.warp-socat-relay = {
    enable = true;
    after = [ "cloudflare-warp.service" "warp-cli-proxy-setup.service" ];
    wants = [ "cloudflare-warp.service" "warp-cli-proxy-setup.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.socat}/bin/socat TCP-LISTEN:6666,reuseaddr,fork TCP:127.0.0.1:6667
    '';
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
      DynamicUser = true;
    };
  };

}
