# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }: {
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  # Set hostname
  networking.hostName = "kratos";

  nixpkgs.overlays = [
    # Import overlays
    (import ../../overlays/overlay.nix)
    (import ../../overlays/keepassxc.nix)
    (import ../../overlays/appvm.nix)
    (import ../../overlays/llama-cpp.nix)
  ];

  # following configuration is added only when building VM with build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable library and dev documentation
  documentation.dev.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.ssh.startAgent = false;

  # Required for ZFS
  networking.hostId = "ffbe00b9";

  # Just don't touch this except for a very good, no bad reason
  system.stateVersion = "22.11";

}
