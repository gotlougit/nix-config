{ pkgs, config, ... }:

{
  # Use the systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;
  # Save 20 generations just in case
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Allow emulation of aarch64 for building mimir images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # For rr to work nicely
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
  # Use latest Linux Kernel
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # Allow normal users to use unprivileged namespaces
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
  # Use pstate to lower idle clocks even lower
  # Also limit ZFS ARC to 512MB
  boot.kernelParams = [ "amd_pstate=active" "zfs.zfs_arc_min=${toString (1024 * 1024 * 100)}" "zfs.zfs_arc_max=${toString (1024 * 1024 * 512)}" ];
  # Add more filesystems here as and when needed
  boot.supportedFilesystems = [ "btrfs" "zfs" ];
}
