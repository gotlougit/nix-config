# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports = with inputs; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Impermanence
    ./impermanence.nix
    # User specific config
    ./user.nix
    # Basic services
    ./services.nix
    # OpenSnitch
    ./opensnitch.nix
    # Networking
    ./networking.nix
    # System programs
    ./systemprograms.nix
    # Shell settings
    ./shell.nix
  ];

  # kratos-specific rules for networking
  networking.hostName = "kratos";
  # Enable networkmanager
  networking.networkmanager.enable = true;
  # Randomize MAC address
  networking.networkmanager.wifi.macAddress = "stable";
  networking.networkmanager.ethernet.macAddress = "stable";
  # Allow KDE connect
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  # Allow Syncthing
  networking.firewall.allowedUDPPorts = [ 22000 ];

  # Use the systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = true;
  # Allow emulation of aarch64 for building mimir images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # For rr to work nicely
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  # Enable hardware acceleration
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = [ pkgs.amdvlk ];

  # To enable Vulkan support for 32-bit applications, also add:
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  nixpkgs.config.allowUnfree = true; # Allow proprietary software
  # Support flakes
  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
    (import ../overlays/overlay.nix)
  ];
  hardware.enableAllFirmware = true;

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  # Enable podman
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  virtualisation.lxd.enable = true;
  virtualisation.waydroid.enable = true;
  programs.dconf.enable = true;

  # Use latest Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  nix = {
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
    # Garbage collect generations older than 7 days
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Enable library and dev documentation
  documentation.dev.enable = true;
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.ssh.startAgent = false;

  # List services that you want to enable:
  # Enable warp-svc to allow connections to the Cloudflare VPN
  systemd.packages = [ pkgs.cloudflare-warp pkgs.syncthing ];
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
      CapabilityBoundingSet="~CAP_SYS_PTRACE";
      # ProcSubset = "pid";
      # InaccessiblePaths = "/data";
    };
  };
  # Enable vnstatd to monitor total net usage
  services.vnstat.enable = true;
  # Enable tailscaled to be able to connect to mesh network
  services.tailscale.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable firmware updates
  services.fwupd.enable = true;

  # AppArmor Stuff
  security.apparmor = {
    enable = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
