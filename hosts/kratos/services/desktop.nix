{ pkgs, lib, ... }:
# This contains GUI desktop specific services/configs
{
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

  # Remove some KDE defaults that are never needed
  environment.plasma6.excludePackages = lib.mkForce [
    pkgs.kdePackages.oxygen
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.konsole
    pkgs.kdePackages.plasma-browser-integration
    pkgs.kdePackages.elisa
    pkgs.kdePackages.baloo
    pkgs.kdePackages.kate
    pkgs.libsForQt5.oxygen
    pkgs.libsForQt5.khelpcenter
    pkgs.libsForQt5.konsole
    pkgs.libsForQt5.plasma-browser-integration
    pkgs.libsForQt5.elisa
    pkgs.libsForQt5.baloo
    pkgs.libsForQt5.kate
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
    ark # KDE archiving program
    gocryptfs # For plasma-vault
    kdePackages.plasma-vault # Encrypted folders in KDE
    ntfs3g # NTFS FUSE implementation
    kdePackages.ksshaskpass # Ask password in GUI from CLI
    kdePackages.kdeconnect-kde # KDE Connect
    kdePackages.krohnkite # Tiling extension for Plasma 6
  ];

  # Disable baloo indexer
  environment.etc."xdg/baloofilerc".source =
    (pkgs.formats.ini { }).generate "baloorc" {
      "Basic Settings" = { "Indexing-Enabled" = false; };
    };

  # Enable CUPS to print documents.
  services.printing.enable = false;

}
