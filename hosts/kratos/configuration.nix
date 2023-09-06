# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
{
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

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
