{ pkgs, ... }:
# This contains GUI desktop specific services/configs
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  # Enable use of KDE Plasma and SDDM login manager
  services.xserver.displayManager.sddm.enable = true;
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
