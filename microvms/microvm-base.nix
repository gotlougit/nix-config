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

  # Just use systemd-networkd's built-in 99-ethernet-default-dhcp.network
  systemd.network.enable = true;

  systemd.oomd.enable = false;
  services.timesyncd.enable = false;

  # Disable firewall for faster boot and less hassle;
  # we are behind a layer of NAT anyway.
  networking.firewall.enable = false;

  # Enable resolved for DNS
  services.resolved.enable = true;

  # D-Bus + dconf for Home Manager (stylix/dconfSettings activation)
  services.dbus.enable = true;
  programs.dconf.enable = true;

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
    createHome = true;
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

  systemd.tmpfiles.rules = [
    "d /home/gotlou 0755 gotlou gotlou -"
    "d /home/gotlou/.config 0755 gotlou gotlou -"
    "d /home/gotlou/.config/dconf 0755 gotlou gotlou -"
  ];

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
    neededForBoot = true;
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    curl
    git
  ];

  system.stateVersion = "24.11";

  microvm = {
    writableStoreOverlay = "/nix/.rw-store";
    hypervisor = "qemu";
    vcpu = 8;
    mem = 8192;
    socket = "control.socket";

    shares = [
      {
        # Host's nix store for caching (read-only)
        proto = "9p";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
      {
        # Host's Code directory for development
        proto = "9p";
        tag = "code";
        source = "/home/gotlou/Code";
        mountPoint = "/home/gotlou/Code";
      }
      {
        # Claude Code config directory
        proto = "9p";
        tag = "claude-config";
        source = "/home/gotlou/.claude";
        mountPoint = "/home/gotlou/.claude";
      }
      {
        # OpenCode config directory
        proto = "9p";
        tag = "opencode-config";
        source = "/home/gotlou/.config/opencode";
        mountPoint = "/home/gotlou/.config/opencode";
      }
      {
        # Amp Code config/state directory
        proto = "9p";
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

  };
}
