{ pkgs, ... }:

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
  boot.kernelPackages = pkgs.linuxPackages_hardened;
  # Allow normal users to use unprivileged namespaces
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
  # Use pstate to lower idle clocks even lower
  boot.kernelParams = [ "amd_pstate=active" ];
  # Add more filesystems here as and when needed
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
}
