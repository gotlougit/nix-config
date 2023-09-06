{ ... }:
{
  # Enable earlyoom to manage memory better and prevent freezes
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 15;
  };
}
