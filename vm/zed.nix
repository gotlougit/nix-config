{ pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "24.05";
  networking.hostName = "zed-vm";

  microvm = {
    graphics.enable = true;
    hypervisor = "qemu";

    # Resource allocation
    vcpu = 8;
    mem = 8192;
    # balloon = true;

    # Shares
    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        proto = "9p";
      }
      # {
      #   tag = "persistent";
      #   source = "/home/gotlou/Code";
      #   mountPoint = "/home/user/Code";
      #   proto = "virtiofs";
      # }
    ];

    socket = "/tmp/microvm-zed.sock";
  };

  # Minimal graphics
  hardware.graphics.enable = true;

  # Auto-login user
  services.getty.autologinUser = "user";

  # Create user
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "";
  };

  nix.enable = true;
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "user" ];
  };
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
  };
  systemd.services.loadnixdb = {
    description = "import hosts nix database";
    path = [ pkgs.nix ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "nix-daemon.service" ];
    script = "cat /persist/nix-store-db-dump|nix-store --load-db";
  };

  systemd.user.services.wayland-proxy = {
    enable = true;
    description = "Wayland Proxy";
    serviceConfig = with pkgs; {
      # Environment = "WAYLAND_DISPLAY=wayland-1";
      ExecStart =
        "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = [ "default.target" ];
  };

  # Add user-specific packages here directly
  environment.systemPackages = with pkgs;
    [
      zed-editor
      virtualglLib
      weston
    ];

  # Environment for graphics
  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-1";
    DISPLAY = ":0";
    QT_QPA_PLATFORM = "wayland"; # Qt Applications
    GDK_BACKEND = "wayland"; # GTK Applications
    XDG_SESSION_TYPE = "wayland"; # Electron Applications
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}

