{ ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 150;

  boot.kernel.sysctl = {
    "vm.swappiness" = 200;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}
