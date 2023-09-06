{ pkgs, ...}:

{
  
  # Use the systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;
  # Save 20 generations just in case
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Enable systemd in initrd
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = true;
  # Allow emulation of aarch64 for building mimir images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # For rr to work nicely
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
  # Use latest Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
}
