{ ... }:
{
  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    # Use exit nodes and subnet routers
    useRoutingFeatures = "client";
  };

  # Create tailscaled user and group
  users.extraUsers.tailscaled = {
    isNormalUser = false;
    isSystemUser = true;
    group = "tailscaled";
  };
  users.groups.tailscaled = { };
  security.polkit.enable = true;

  # Add polkit rule to allow tailscale to change DNS config
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (subject.isInGroup("tailscaled") && (
            action.id == "org.freedesktop.resolve1.register-service" ||
            action.id == "org.freedesktop.resolve1.revert" ||
            action.id == "org.freedesktop.resolve1.set-default-route" ||
            action.id == "org.freedesktop.resolve1.set-dns-over-tls" ||
            action.id == "org.freedesktop.resolve1.set-dns-servers" ||
            action.id == "org.freedesktop.resolve1.set-dnssec" ||
            action.id == "org.freedesktop.resolve1.set-dnssec-negative-trust-anchors" ||
            action.id == "org.freedesktop.resolve1.set-domains" ||
            action.id == "org.freedesktop.resolve1.set-llmnr" ||
            action.id == "org.freedesktop.resolve1.set-mdns" ||
            action.id == "org.freedesktop.resolve1.unregister-service"
        )) {
            return polkit.Result.YES;
        }
    });
  '';

  # Custom preferences in order to harden the tailscaled daemon
  systemd.services.tailscaled = {
    enable = true;
    serviceConfig = {
      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 0755;
      StateDirectory = "tailscale";
      StateDirectoryMode = 0700;
      CacheDirectory = "tailscale";
      CacheDirectoryMode = 0750;
      Type = "notify";

      # TODO: get Tailscale to run as non-root user
      # Till then it runs as root, but with some capabilities dropped
      # User = "tailscaled";
      Group = "tailscaled";

      # Prevent leakage via Impermanence
      InaccessiblePaths = [ "/persist" ];

      DeviceAllow = [ "/dev/tun" "/dev/net/tun" ];
      AmbientCapabilities = [ "CAP_NET_RAW" "CAP_NET_ADMIN" "CAP_SYS_MODULE" ];
      ProtectKernelModules = false;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
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
      SystemCallFilter = [ "@known" "~@clock" "@cpu-emulation" "@raw-io" "@reboot" "@mount" "@obsolete" "@swap" "@debug" "@keyring" "@mount" "@pkey" ];
    };
  };
}
