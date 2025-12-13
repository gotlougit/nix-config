# { pkgs, lib, inputs, ... }:
{ pkgs, lib, ... }:
# This contains GUI desktop specific services/configs
{
  # imports = [ inputs.nixos-cosmic.nixosModules.default ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable use of KDE Plasma and SDDM login manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Extra SDDM config
  services.displayManager.sddm.settings = {
    Theme = { FacesDir = "/persist/system/icons"; };
  };
  security.pam.services.gotlou.kwallet.enable = true;

  # Disable baloo service completely
  systemd.user.services.plasma-baloorunner = { enable = lib.mkForce false; };

  # EXPERIMENTAL: enable COSMIC desktop
  # services.desktopManager.cosmic.enable = true;
  # COSMIC greeter disabled since this isn't my primary desktop
  # services.displayManager.cosmic-greeter.enable = true;
  # environment.cosmic.excludePackages = lib.mkForce [
  #   pkgs.cosmic-edit
  #   pkgs.cosmic-term
  #   pkgs.cosmic-player
  #   pkgs.pop-icon-theme
  # ];

  # Remove some KDE defaults that are never needed
  environment.plasma6.excludePackages = lib.mkForce [
    pkgs.kdePackages.oxygen
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.konsole
    pkgs.kdePackages.plasma-browser-integration
    pkgs.kdePackages.elisa
    pkgs.kdePackages.baloo
    pkgs.kdePackages.kate
    # pkgs.libsForQt5.oxygen
    # pkgs.libsForQt5.khelpcenter
    # pkgs.libsForQt5.konsole
    # pkgs.libsForQt5.plasma-browser-integration
    # pkgs.libsForQt5.elisa
    # pkgs.libsForQt5.baloo
    # pkgs.libsForQt5.kate
  ];

  # Allow KDE connect through firewall
  networking.firewall.allowedTCPPortRanges = [{
    from = 1714;
    to = 1764;
  }];
  networking.firewall.allowedUDPPortRanges = [{
    from = 1714;
    to = 1764;
  }];

  environment.systemPackages = with pkgs; [
    kdePackages.ark # KDE archiving program
    gocryptfs # For plasma-vault
    kdePackages.plasma-vault # Encrypted folders in KDE
    ntfs3g # NTFS FUSE implementation
    kdePackages.ksshaskpass # Ask password in GUI from CLI
    kdePackages.kdeconnect-kde # KDE Connect
    kdePackages.krohnkite # Tiling extension for Plasma 6

    # cosmic-ext-tweaks # Tweak COSMIC even more
    # cosmic-ext-ctl # CLI for COSMIC config
  ];

  # Disable baloo indexer
  environment.etc."xdg/baloofilerc".source =
    (pkgs.formats.ini { }).generate "baloorc" {
      "Basic Settings" = { "Indexing-Enabled" = false; };
    };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Extra XDG portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
