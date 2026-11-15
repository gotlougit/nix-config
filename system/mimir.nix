{ inputs, ... }:
{
  nixpkgs.overlays = [
    (import ../overlays/overlay.nix { inherit inputs; })
  ];

  imports = [
    ./dns-resolver.nix
    ./oom.nix
    ./openssh.nix
    ./sudo.nix

    ./mitmproxy.nix
    ./snowflake.nix
    ./warp.nix
    ./mimir-hotspot.nix

    ./cyberchef.nix
    ./hitman-ps5.nix
    ./kittygram.nix
    # ./redlib.nix
  ];

  # Same tailscaled sandbox as kratos.
  users.extraUsers.tailscaled = {
    isNormalUser = false;
    isSystemUser = true;
    group = "tailscaled";
  };
  users.groups.tailscaled = { };

  systemd.services.tailscaled = {
    enable = true;
    serviceConfig = {
      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 755;
      StateDirectory = "tailscale";
      StateDirectoryMode = 700;
      CacheDirectory = "tailscale";
      CacheDirectoryMode = 750;
      Type = "notify";

      # TODO: get Tailscale to run as non-root user
      # Till then it runs as root, but with some capabilities dropped
      # User = "tailscaled";
      Group = "tailscaled";

      # Prevent leakage via Impermanence
      InaccessiblePaths = [ "/persist" ];

      DeviceAllow = [
        "/dev/tun"
        "/dev/net/tun"
      ];
      CapabilityBoundingSet = [
        ""
        "CAP_NET_RAW"
        "CAP_NET_ADMIN"
        "CAP_SYS_MODULE"
      ];
      ProtectKernelModules = false;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateMounts = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      ProtectHome = true;
      ProtectControlGroups = true;
      ProtectKernelLogs = true;
      ProtectSystem = true;
      ProtectProc = "noaccess";
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
}
