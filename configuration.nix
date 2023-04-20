# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Configure filesystem manually
  fileSystems."/" =
    {
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      options = [ "subvol=home" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  fileSystems."/nix" =
    {
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  fileSystems."/persist" =
    {
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  # Enable firmware and use nonfree software
  hardware.enableAllFirmware = true;
  # Add support to add packages from nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
        unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Use the systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Use latest Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];

  # Setup networking
  networking = {
    hostName = "kratos"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    nameservers = [ "127.0.0.1" "::1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    # TODO: figure out firewall rules
    firewall.enable = false;
  };

  # Disable resolved, we won't be using it
  services.resolved.enable = false;
  # dnscrypt-proxy2 specific config
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Ideally add one or two more here
      server_names = ["cloudflare"];
      };
    };

    systemd.services.dnscrypt-proxy2 = {
        after = [ "systemd-sysusers.target" ];
        before = [ "sysinit.target" "network.target" "nss-lookup.target" "shutdown.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.StateDirectory = "dnscrypt-proxy";
    };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Some WirePlumber stuff to handle bluetooth correctly
  services.pipewire  = {
  media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
    }
     ];
   };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Change user name according to your preference
  users.users.gotlou = {
    isNormalUser = true;
    # CHANGE THIS ASAP
    initialPassword = "gotlou";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # TODO: make this even more comprehensive
    # Add whatever you want
    # I mainly add GUI programs in here
    packages = with pkgs; [
        firefox # Just plain Firefox
        ark # KDE archiving program
        arc-theme # Preferred theme for KDE
        chiaki # PS4 Remote Play client
        filelight # View disk usage in pie chart form
        ghidra # Decompiler
        inkscape # Vector images
        krita # Raster image editor
        keepassxc # Password manager
        legendary-gl # Epic Games Store client
        libreoffice-qt # Document editor
        mangohud # Overlay while playing games
        otpclient # TOTP client
        pcsxr # PS1 emulator
        pcsx2 # PS2 emulator
        qbittorrent # Best torrent client
        rpcs3 # PS3 emulator
        rhythmbox # Preferred music player
        signal-desktop # Secure and easy messaging
        steam # Games client
        tdesktop # Telegram desktop client
        tor-browser-bundle-bin # Needs no intro
        vlc # Easiest media player
        wl-clipboard # CLI util for copying and pasting in Wayland
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # This mainly has CLI tools and stuff that likely won't work as a user install
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    tealdeer # Rust implementation of tldr
    android-tools # adb, fastboot etc
    aria # download manager
    bandwhich # view what programs are making network requests
    bear # Generate autocomplete for large projects
    curl # no intro needed
    cloudflare-warp # A good quality VPN
    ffmpeg # Swiss Army Knife of
    flatpak # Used to isolate certain programs
    gocryptfs # For plasma-vault
    gh # Github CLI
    gdb
    gitFull # For git-send-email
    glances # htop alternative
    hut # Sourcehut CLI
    libsForQt5.kdeconnect-kde # KDE Connect
    neofetch # Nice startup screen for terminal
    pandoc # Convert docs
    picard # Tag music files
    plasma-vault # Encrypted folders in KDE
    postgresql_15 # Database
    rr # Record and replay while debugging
    radeontop # AMD GPU monitoring
    syncthing # Sync all files
    tailscale # Create a mesh network
    virt-manager # Easy KVM based VMs
    vnstat # View total data usage
    wget # Another, simpler download manager
    winePackages.stagingFull # Latest Wine to run Windows programs
    wireshark # View real time network traffic across multiple interfaces

    # Packages that have to be installed via unstable
    # TODO: fix mullvad browser install
    # unstable.mullvad-browser # Hardened Firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Set useful shell aliases
  programs.bash.shellAliases = {
      vi = "nvim";
      open = "xdg-open";
  };

  # Set session variables
  environment.variables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";

    # TODO: maybe figure out if this is required or not
    # LD_LIBRARY_PATH = "/usr/local/lib:$LD_LIBRARY_PATH";
    GIT_ASKPASS = "/usr/bin/ksshaskpass";
    GTK_THEME = "Arc-Dark";
    EDITOR = "nvim";
    # TODO: fix setting GTK_USE_PORTAL
    #GTK_USE_PORTAL = 1;
  };

  # List services that you want to enable:
  # Enable warp-svc to allow connections to the Cloudflare VPN
  systemd.services.warp-svc = {
    enable = true;
    after = [ "network-online.target"  "dnscrypt-proxy.target" ];
    wantedBy = [ "multi-user.target" ];
  };
  # Enable vnstatd to monitor total net usage
  services.vnstat.enable = true;
  # Enable tailscaled to be able to connect to mesh network
  services.tailscale.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable firmware updates
  services.fwupd.enable = true;

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
