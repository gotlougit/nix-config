{ ... }:
{
  # Enable earlyoom to manage memory better and prevent freezes
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 15;
  };
  systemd.oomd.enable = false;
  # Harden earlyoom
  systemd.services.earlyoom = {
    enable = true;
    serviceConfig = {
      PrivateNetwork = true;
      MemoryDenyWriteExecute = true;
      InaccessiblePaths = "/persist";
      ProtectHome = true;
    };
  };
}
