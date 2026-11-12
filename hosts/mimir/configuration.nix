{ pkgs, ... }:
{
  time.timeZone = "Asia/Kolkata";
  networking.hostName = "mimir";

  i18n.defaultLocale = "C.UTF-8";

  # Fixed, public machine-id (Kicksecure/Whonix generic value) so /etc remains
  # fully ephemeral and does not need a persisted machine-id.
  environment.etc.machine-id = {
    text = "b08dfa6083e7567a1921a715000001fb";
    mode = "0444";
  };

  users.mutableUsers = false;
  users.users.gotlou = {
    isNormalUser = true;
    home = "/home/gotlou";
    hashedPassword = "$y$j9T$rw1wMForHIg1XuK9HWnCD0$j.19g/PKjzKFPgEF/X2.lMOLIrXLfgGAQ9m9zz85Bc5";
    extraGroups = [ "wheel" "wpa_supplicant" ];
  };

  # system/sudo.nix disables sudo/sudo-rs and installs the shim; enable the
  # shim module so run0/polkit is wired up as well.
  security.run0-sudo-shim.enable = true;

  system.stateVersion = "26.05";
}
