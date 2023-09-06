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
      NoNewPrevilleges = true;
      LockPersonality = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      # ProtectSystem = "full";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      CapabilityBoundingSet = "~CAP_SYS_PTRACE";
      # ProcSubset = "pid";
      # InaccessiblePaths = "/data";
    };
  };
}
