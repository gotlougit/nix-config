# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Impermanence
    inputs.impermanence.nixosModules.impermanence
  ];

  # Files and folders that are saved by Impermanence from deletion
  # Symlinks will be created automatically at boot
  environment.persistence."/persist/system" = {
    directories = [
      "/etc/NetworkManager"
      "/var/log/cloudflare-warp"
      "/var/log/libvirt"
      "/var/log/private"
      "/var/lib"
    ];
    files = [
    ];
  };
  environment.persistence."/persist/dotfiles" = {
    directories = [
      "/home/gotlou/.config/gh"
      "/home/gotlou/.config/hut"
      "/home/gotlou/.config/nvim"
      "/home/gotlou/.config/neofetch"
      "/home/gotlou/.config/syncthing"
      "/home/gotlou/.config/rpcs3"
      "/home/gotlou/.config/PCSX2"
      "/home/gotlou/.pcsxr"
      "/home/gotlou/.ssh"
      "/home/gotlou/.leetcode"
      "/home/gotlou/.local/share/kwalletd"
      "/home/gotlou/.local/share/dolphin"
      "/home/gotlou/.local/share/rhythmbox"
      "/home/gotlou/.mullvad"
      "/home/gotlou/.mozilla"
      "/home/gotlou/.thunderbird"
      "/home/gotlou/.config/Signal"
      "/home/gotlou/.config/helix"
      "/home/gotlou/.config/lazygit"
    ];
    files = [ "/home/gotlou/.gitconfig" ];
  };

  # Persist path for nix-direnv
  environment.pathsToLink = [
    "/persist/nix-direnv"
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

  # Setup networking
  networking = {
    hostName = "kratos"; # Define your hostname.
    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.
    nameservers = [ "127.0.0.1" "::1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    # TODO: figure out firewall rules
    firewall.enable = true;
    firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
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
        minisign_key =
          "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Ideally add one or two more here
      server_names = [
        "cloudflare"
        "mullvad-adblock-doh"
        "quad9-dnscrypt-ip4-nofilter-ecs-pri"
      ];
    };
  };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  services.pipewire.wireplumber.enable = true;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text =
      "	bluez_monitor.properties = {\n		[\"bluez5.enable-sbc-xq\"] = true,\n		[\"bluez5.enable-msbc\"] = true,\n		[\"bluez5.enable-hw-volume\"] = true,\n		[\"bluez5.headset-roles\"] = \"[ hsp_hs hsp_ag hfp_hf hfp_ag ]\"\n	}\n";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Change user name according to your preference
  users.mutableUsers = false;
  users.users.gotlou = {
    isNormalUser = true;
    # CHANGE THIS ASAP
    initialPassword = "hellofriend";
    extraGroups = [ "wheel" "networkmanager" ];
    # TODO: make this even more comprehensive
    # Add whatever you want
    # I mainly add GUI programs in here
    packages = with pkgs; [
      inputs.code-sandbox.packages.x86_64-linux.default # Installs sandboxes
      firefox # Just plain Firefox
      thunderbird # Email client
      ark # KDE archiving program
      arc-theme # Preferred theme for KDE
      arc-icon-theme # Preferred theme for KDE
      arc-kde-theme # Preferred theme for KDE
      gnome.adwaita-icon-theme # GTK apps default icons
      bottles # Easily manage Wine prefixes
      cemu # Wii U emulator
      chiaki # PS4 Remote Play client
      filelight # View disk usage in pie chart form
      frida-tools # For Android reverse engineering
      ghidra # Decompiler
      inkscape # Vector images
      krita # Raster image editor
      keepassxc # Password manager
      legendary-gl # Epic Games Store client
      libreoffice-qt # Document editor
      libsForQt5.ksshaskpass # Ask password in GUI from CLI
      mangohud # Overlay while playing games
      mullvad-browser # Browser for private browsing
      nixpkgs-fmt # Format nix code effectively
      otpclient # TOTP client
      pcsxr # PS1 emulator
      pcsx2 # PS2 emulator
      qbittorrent # Best torrent client
      rpcs3 # PS3 emulator
      rhythmbox # Preferred music player
      songrec # Shazam on Linux
      signal-desktop # Secure and easy messaging
      tdesktop # Telegram desktop client
      tor-browser-bundle-bin # Needs no intro
      vlc # Easiest media player
      wl-clipboard # CLI util for copying and pasting in Wayland

      # Development Stuff
      pkgconfig
      openssl.dev
      sqlite.dev
      leetcode-cli
      shellcheck
      gcc
      gcc-unwrapped.lib
      pkg-config
      gnumake
      glibc
      glibc_multi
      binutils
      libgccjit
      libstdcxx5
      llvmPackages_15.libclang
      zig
      rustup # Use rustup since I may need to cross compile
      rust-analyzer
      go
      nodejs
      nil
      tree-sitter
      nodePackages_latest.pyright
      python310Packages.python-lsp-server
      nodePackages.bash-language-server
      gopls
      nodePackages_latest.coc-tsserver
      python310Full
      tk
      python310Packages.tkinter
      python310Packages.pip
    ];
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
    glances # htop alternative
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
    make = "build-sandbox make";
    gcc = "build-sandbox gcc";
    rustc = "build-sandbox rustc";
    "g++" = "build-sandbox g++";
  };
  # Hook direnv
  programs.bash.interactiveShellInit = ''
    neofetch
    source /run/current-system/sw/share/nix-direnv/direnvrc
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

  # OpenSnitch stuff
  systemd.user.services."opensnitch-ui" = {
    enable = true;
    description = "OpenSnitch UI";
    after = [ "graphical-session-pre.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      #Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.opensnitch-ui}/bin/opensnitch-ui";
      Restart = "on-failure";
    };

    #Install = { WantedBy = [ "graphical-session.target" ]; };
  };
  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };
      dnscrypt-proxy2 = {
        name = "dnscrypt-proxy2";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
        };
      };
      nsncd = {
        name = "nsncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.nsncd}/bin/nsncd";
          };
        };
      NetworkManager = {
        name = "NetworkManager";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.networkmanager}/bin/NetworkManager";
          };
        };
      syncthing = {
        name = "syncthing";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.syncthing}/bin/syncthing";
          };
        };
      };
  };

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
