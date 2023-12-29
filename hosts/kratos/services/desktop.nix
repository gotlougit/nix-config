{ pkgs, ... }:
# This contains GUI desktop specific services/configs
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  # Enable use of KDE Plasma and SDDM login manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Set wayland as default
  services.xserver.displayManager.defaultSession = "plasmawayland";
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  # Disable touchpad while typing
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  # Extra SDDM config
  services.xserver.displayManager.sddm.settings = {
    Theme = {
      FacesDir = "/persist/system/icons";
    };
  };

  # Remove some KDE defaults that are never needed
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    elisa
    baloo
  ];

  # Allow KDE connect through firewall
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];

  environment.systemPackages = with pkgs; [
    ark # KDE archiving program
    colord # ICC color profiles management
    libsForQt5.colord-kde
    libsForQt5.kirigami-addons
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

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

}
