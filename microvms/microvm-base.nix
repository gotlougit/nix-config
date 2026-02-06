{
  hostName,
  tapId,
  mac,
  inputs,
}:
{
  pkgs,
  lib,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # Basic system settings
  networking.hostName = hostName;

  # Use systemd-networkd for network configuration
  networking.useNetworkd = true;
  networking.useDHCP = true;
  networking.tempAddresses = "disabled";

  # DHCP configuration for user-mode networking (slirp)
  systemd.network.enable = true;
  systemd.network.networks."10-eth" = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "yes";
    };
    linkConfig.RequiredForOnline = "routable";
  };

  systemd.oomd.enable = false;
  services.timesyncd.enable = false;

  # Disable firewall for faster boot and less hassle;
  # we are behind a layer of NAT anyway.
  networking.firewall.enable = false;

  # Enable resolved for DNS
  services.resolved.enable = true;

  # Fast shutdowns/reboots
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "5s";
  };

  # Fix for microvm shutdown hang (issue #170):
  # Without this, systemd tries to unmount /nix/store during shutdown,
  # but umount lives in /nix/store, causing a deadlock.
  systemd.mounts = [
    {
      what = "store";
      where = "/nix/store";
      overrideStrategy = "asDropin";
      unitConfig.DefaultDependencies = false;
    }
  ];

  users.users.gotlou = {
    isNormalUser = true;
    home = "/home/gotlou";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    initialPassword = "";
    group = "gotlou";
  };
  users.groups.gotlou = {
    gid = 1000;
  };

  # Enable fish
  programs.fish.enable = true;

  # Enable ssh with permissive auth for isolated VM
  services.openssh.enable = true;
  services.openssh.settings = {
    # Allow empty passwords for passwordless login (VM is isolated)
    PasswordAuthentication = true;
    PermitEmptyPasswords = true;
    PubkeyAuthentication = false;
    PermitRootLogin = "no";
    AllowUsers = [ "gotlou" ];
  };

  # Sudo without password for wheel
  security.sudo.wheelNeedsPassword = false;

  # Home manager setup
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.gotlou = {
    imports = [ ./microvm-home.nix ];
  };

  # Timezone
  time.timeZone = "Asia/Kolkata";

  # Tmpfs for systemd state (networkd, resolved, etc.)
  # This avoids disk usage while satisfying systemd's persistent storage requirements
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "mode=0755"
      "size=100M"
    ];
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    curl
    git
  ];

  system.stateVersion = "24.11";

  microvm = {
    # Enable writable nix store overlay so nix-daemon works.
    # This is required for home-manager activation.
    writableStoreOverlay = "/nix/.rw-store";

    hypervisor = "qemu";
    vcpu = 8;
    mem = 8192;
    socket = "control.socket";

    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 8192;
      }
    ];

    shares = [
      {
        # Host's nix store for caching (read-only)
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
      {
        # Host's Code directory for development
        proto = "virtiofs";
        tag = "code";
        source = "/home/gotlou/Code";
        mountPoint = "/home/gotlou/Code";
      }
      {
        # Claude Code config directory
        proto = "virtiofs";
        tag = "claude-config";
        source = "/home/gotlou/.claude";
        mountPoint = "/home/gotlou/.claude";
      }
      {
        # OpenCode config directory
        proto = "virtiofs";
        tag = "opencode-config";
        source = "/home/gotlou/.config/opencode";
        mountPoint = "/home/gotlou/.config/opencode";
      }
      {
        # Amp Code config/state directory
        proto = "virtiofs";
        tag = "amp-config";
        source = "/home/gotlou/.config/amp";
        mountPoint = "/home/gotlou/.config/amp";
      }
    ];

    interfaces = [
      {
        type = "user";
        id = tapId;
        mac = mac;
      }
    ];

    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };
}
