{
  hostName,
  ipAddress,
  tapId,
  mac,
  workspace,
  inputs,
}:
{
  pkgs,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # Basic system settings
  networking.hostName = hostName;

  # Use systemd-networkd for network configuration
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.tempAddresses = "disabled";

  # Static IP configuration
  systemd.network.enable = true;
  systemd.network.networks."10-e" = {
    matchConfig.Name = "e*";
    addresses = [ { Address = "${ipAddress}/24"; } ];
    routes = [ { Gateway = "192.168.83.1"; } ];
  };
  networking.nameservers = [
    "192.168.83.1"
    "8.8.8.8"
    "1.1.1.1"
  ];

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

  # User setup
  users.users.gotlou = {
    isNormalUser = true;
    home = "/home/gotlou";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  # Enable fish
  programs.fish.enable = true;

  # Enable ssh
  services.openssh.enable = true;

  # Use SSH host keys mounted from outside the VM (remain identical).
  services.openssh.hostKeys = [
    {
      path = "/etc/ssh/host-keys/microvm_ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

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

    hypervisor = "cloud-hypervisor";
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
        # SSH host keys
        proto = "virtiofs";
        tag = "ssh-keys";
        source = "${workspace}/ssh-host-keys";
        mountPoint = "/etc/ssh/host-keys";
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
        type = "tap";
        id = tapId;
        mac = mac;
      }
    ];
  };
}
