{ pkgs, ... }:
{
  # Enable warp-svc to allow connections to the Cloudflare VPN
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.services.warp-svc = {
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
      CapabilityBoundingSet = "~CAP_SYS_PTRACE";
      InaccessiblePaths = "/persist";
      AmbientCapabilities = [ "CAP_NET_RAW" "CAP_NET_ADMIN" "CAP_SYS_MODULE" ];
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
      ProtectHome = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@known" "~@clock" "~@cpu-emulation" "~@raw-io" "~@reboot" "~@mount" "~@obsolete" "~@swap" "~@debug" "~@keyring" "~@pkey" ];
    };
  };
}
