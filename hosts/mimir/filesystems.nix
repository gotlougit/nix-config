{ lib, ... }:
{
  # Everything lives in RAM except the SD card partition.  The SD card is
  # mounted at /mnt and its subdirectories are bind-mounted where NixOS
  # expects them, so / itself can stay a tmpfs.
  fileSystems = {
    "/" = {
      device = lib.mkForce "none";
      fsType = lib.mkForce "tmpfs";
      options = lib.mkForce [
        "mode=755"
        "size=512M"
        "noatime"
      ];
    };

    "/mnt" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/mnt/boot";
      fsType = "none";
      options = [ "bind" "noatime" ];
    };

    "/nix" = {
      device = "/mnt/nix";
      fsType = "none";
      options = [ "bind" "noatime" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/mnt/persist";
      fsType = "none";
      options = [ "bind" "noatime" ];
      neededForBoot = true;
    };

    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [
        "noatime"
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "128M";
  };
}
