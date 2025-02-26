{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  nix = {
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      # Restrict nix usage to real users
      allowed-users = lib.mkDefault [ "@users" ];
      # Hard link identical files in the nix store
      auto-optimise-store = true;
    };
    # Garbage collect generations older than 7 days
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    # Use repo version of nixpkgs for nix operations
    # This prevents downloading latest flake every time you want to do something
    # This also makes non-flake nix commands fail, though
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  programs.nix-index.enable = true;
  programs.nix-ld.enable = true;
  programs.command-not-found.enable = false;
  programs.nix-ld.libraries = lib.mkMerge [
    (with pkgs; [
      stdenv.cc.cc
      openssl
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva
      pipewire
      xorg.libxcb
      xorg.libXdamage
      xorg.libxshmfence
      xorg.libXxf86vm
      libelf

      # Required
      glib
      gtk2
      bzip2

      # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE
      gnome2.GConf
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      # Only libraries are needed from those two
      libudev0-shim

      # Verified games requirements
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libidn
      tbb

      # Other things from runtime
      flac
      freeglut
      libpulseaudio
      libjpeg
      libpng
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libdbusmenu-gtk2
      libindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsa-lib
      expat
      # Needed for electron
      libdrm
      mesa
      libxkbcommon
    ])
  ];

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "SDL_ttf-2.0.11" ];
}
