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
  # Allow normal users to use unprivileged namespaces
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
  # Use pstate to lower idle clocks even lower
  # Also limit ZFS ARC to 512MB
  boot.kernelParams = [
    "amd_pstate=active"
    "zfs.zfs_arc_min=${toString (1024 * 1024 * 100)}"
    "zfs.zfs_arc_max=${toString (1024 * 1024 * 512)}"
    # AMD iGPU (Vega 8, Ryzen 5700U): pin exposed VRAM to 4GiB.
    # NOTE: on APUs the actual 4GiB carve-out must also be set in
    # BIOS/UEFI (UMA Frame Buffer Size >= 4GB); this flag only caps the
    # driver's reported VRAM and cannot increase the firmware allocation.
    "amdgpu.vramlimit=4096"
    # Let the iGPU use ~90% of system RAM via the GTT. Default TTM limit
    # is 50%; 3,178,000 * 4KiB pages = 12.1GiB of the 13.5GiB the OS sees.
    "ttm.pages_limit=3178000"
  ];
  # Add more filesystems here as and when needed
  boot.supportedFilesystems = [
    "btrfs"
    "zfs"
  ];
}
