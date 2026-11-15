{ lib, ... }:
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

  # We are only enabling root user here, no sudo* required
  security.sudo.enable = lib.mkForce false;
  security.doas.enable = lib.mkForce false;
  security.sudo-rs.enable = lib.mkForce false;

  system.stateVersion = "26.05";
}
