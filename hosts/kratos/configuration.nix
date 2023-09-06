# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
{
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  # Set hostname
  networking.hostName = "kratos";

  nixpkgs.overlays = [
    # Allow nix-direnv to use flakes
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
    # Import overlays
    (import ../../overlays/overlay.nix)
  ];

  programs.dconf.enable = true;

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

  # Just don't touch this except for a very good, no bad reason
  system.stateVersion = "22.11";

}
