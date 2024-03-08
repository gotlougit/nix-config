{ pkgs, lib, ... }:
# This contains GUI desktop specific services/configs
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable use of KDE Plasma and SDDM login manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  # Extra SDDM config
  services.xserver.displayManager.sddm.settings = {
    Theme = {
      FacesDir = "/persist/system/icons";
    };
  };

  # Remove some KDE defaults that are never needed
  environment.plasma6.excludePackages = lib.mkForce [
    pkgs.libsForQt5.oxygen
    pkgs.libsForQt5.khelpcenter
    pkgs.libsForQt5.konsole
    pkgs.libsForQt5.plasma-browser-integration
    pkgs.libsForQt5.elisa
    pkgs.libsForQt5.baloo
    pkgs.libsForQt5.kate
    pkgs.kdePackages.kate
  ];

  # Allow KDE connect through firewall
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];

  environment.systemPackages = with pkgs; [
    ark # KDE archiving program
    gocryptfs # For plasma-vault
    plasma-vault # Encrypted folders in KDE
    ntfs3g # NTFS FUSE implementation
    libsForQt5.polonium
    libsForQt5.ksshaskpass # Ask password in GUI from CLI
    libsForQt5.kdeconnect-kde # KDE Connect
  ];

  # Disable baloo indexer
  environment.etc."xdg/baloofilerc".source = (pkgs.formats.ini { }).generate "baloorc" {
    "Basic Settings" = {
      "Indexing-Enabled" = false;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

}
