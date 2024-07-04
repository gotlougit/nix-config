{ ... }: {
  # Setup networking
  networking = {
    # Enable networkmanager
    networkmanager.enable = true;
    # Randomize MAC address
    networkmanager.wifi.macAddress = "stable";
    networkmanager.ethernet.macAddress = "stable";

    nameservers = [ "127.0.0.1" "::1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    # Use IWD backend
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.settings = { Settings = { AutoConnect = true; }; };
    # Enable firewall by default

    # Note that services like tailscale and SSH will have their ports opened
    # if they are enabled, so we don't need to declare that here
    firewall.enable = true;
  };

  # Make boot faster
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # systemd.services.NetworkManager = {
  #   enable = true;
  #   serviceConfig = {
  #     ProtectProc = false;
  #     LockPersonality = true;
  #     MemoryDenyWriteExecute = true;
  #     NoNewPrivileges = true;
  #     PrivateMounts = true;
  #     PrivateTmp = true;
  #     ProtectClock = true;
  #     ProtectControlGroups = true;
  #     ProtectHome = true;
  #     ProtectHostname = true;
  #     ProtectKernelLogs = true;
  #     ProtectKernelModules = true;
  #     ProtectKernelTunables = true;
  #     RestrictRealtime = true;
  #     RestrictSUIDSGID = true;
  #     SystemCallArchitectures = "native";
  #     # SystemCallFilter = [ "@known" "~@clock" "~@cpu-emulation" "~@raw-io" "~@reboot" "~@mount" "~@obsolete" "~@swap" "~@debug" "~@keyring" "~@pkey" "~@chown" ];
  #     UMask = "0077";
  #     InaccessiblePaths = "/persist";
  #   };
  # };
  systemd.services.NetworkManager-dispatcher = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
  systemd.services.iwd = {
    enable = true;
    serviceConfig = {
      InaccessiblePaths = "/persist";
      ProtectClock = true;
      ProtectKernelLogs = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
  };
  systemd.services.ModemManager = {
    enable = true;
    serviceConfig = (import ./hardening-base.nix);
  };
}
