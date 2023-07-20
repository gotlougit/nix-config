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
  ];

  # Use the systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    bubblewrap
    minijail
    minijail-tools
    slirp4netns
    gparted
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    tealdeer # Rust implementation of tldr
    apparmor-profiles # Enable AppArmor in NixOS
    android-tools # adb, fastboot etc
    aria # download manager
    azure-cli # Microsoft Azure CLI
    aspell # CLI spell check
    bandwhich # view what programs are making network requests
    bear # Generate autocomplete for large projects
    compsize # View btrfs compression info
    curl # no intro needed
    dig # for DNS testing
    direnv # Effortless dev environment setup
    cloudflare-warp # A good quality VPN
    file # To show type of file
    ffmpeg # Multimedia Swiss Army Knife
    gocryptfs # For plasma-vault
    gh # Github CLI
    gdb
    gitFull # For git-send-email
    htop
    hut # Sourcehut CLI
    helix # New Rust-based modal editor
    jq # JSON manipulator
    lazygit # Nice wrapper around git to maintain sanity
    libsForQt5.kdeconnect-kde # KDE Connect
    lm_sensors # For temperatures and fan speeds
    man-pages
    man-pages-posix # Provide more man docs for syscalls etc
    neofetch # Nice startup screen for terminal
    nix-direnv # Direnv + Nix
    opensnitch # Application firewall
    opensnitch-ui # Application firewall UI
    obfs4 # Pluggable transport for tor
    pandoc # Convert docs
    picard # Tag music files
    poppler_utils # PDF conversion and misc utils
    plasma-vault # Encrypted folders in KDE
    pinentry # Enter gpg password securely
    postgresql_15 # Database
    rr # Record and replay while debugging
    radeontop # AMD GPU monitoring
    syncthing # Sync all files
    snowflake # Pluggable transport for tor
    tailscale # Create a mesh network
    tetex # LaTEX related tooling
    trash-cli # Send file to trash instead of permanently deleting
    tor # The Onion Router
    unrar # Useful for decompressing
    virt-manager # Easy KVM based VMs
    vnstat # View total data usage
    vulkan-tools # Manage vulkan
    wget # Another, simpler download manager
    winePackages.stagingFull # Latest Wine to run Windows programs
    whois # Useful utility
    wireshark # View real time network traffic across multiple interfaces
    wireguard-tools # Use kernel Wireguard
    yt-dlp # Useful video download utility
  ];

  # Enable library and dev documentation
  documentation.dev.enable = true;
  
  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  programs.ssh.startAgent = true;

  # Set useful shell aliases
  programs.bash.shellAliases = {
    vi = "hx";
    open = "xdg-open";
    switch-config = "sudo nixos-rebuild switch --flake /home/gotlou/nixos#kratos";
    update-config = "sudo nix flake update /home/gotlou/nixos && sudo nixos-rebuild switch --flake /home/gotlou/nixos#kratos";
    switch-config-boot = "sudo nixos-rebuild boot --flake /home/gotlou/nixos#kratos";
    mullvad-browser = "mullvad-browser-sandbox";
  };
  # Hook direnv
  programs.bash.interactiveShellInit = ''
    neofetch
    source /run/current-system/sw/share/nix-direnv/direnvrc
    source $(blesh-share)/ble.sh
    eval "$(direnv hook bash)"
  '';

  # Set session variables
  environment.variables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";

    # TODO: maybe figure out if this is required or not
    # LD_LIBRARY_PATH = "/usr/local/lib:$LD_LIBRARY_PATH";
    GIT_ASKPASS = "/usr/bin/ksshaskpass";
    GTK_THEME = "Arc:dark";
    EDITOR = "hx";
    # TODO: fix setting GTK_USE_PORTAL
    #GTK_USE_PORTAL = 1;
  };

  # List services that you want to enable:
  # Enable warp-svc to allow connections to the Cloudflare VPN
  systemd.packages = [ pkgs.cloudflare-warp pkgs.syncthing ];
  systemd.services.warp-svc = {
    enable = true;
    after = [ "network-online.target" "systemd-resolved.service" ];
    wantedBy = [ "multi-user.target" ];
  };
  # Enable syncthing
  services.syncthing.enable = true;
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
