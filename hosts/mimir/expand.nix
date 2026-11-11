{ pkgs, ... }:
{
  systemd.services.expand-persist-partition = {
    description = "Grow the NIXOS_SD partition and filesystem to fill the SD card";
    unitConfig = {
      DefaultDependencies = false;
    };
    wantedBy = [ "sysinit.target" ];
    before = [
      "sysinit.target"
      "shutdown.target"
      "register-nix-paths.service"
    ];
    after = [ "local-fs.target" ];
    conflicts = [ "shutdown.target" ];
    restartIfChanged = false;
    path = with pkgs; [
      e2fsprogs
      util-linux
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      rootPart=$(readlink -f "$(findmnt -n -o SOURCE /mnt)")
      bootDevice=$(lsblk -npo PKNAME "$rootPart")
      partName=$(basename "$rootPart")
      partNum=$(cat "/sys/class/block/$partName/partition")

      partStart=$(cat "/sys/class/block/$partName/start")
      partSize=$(cat "/sys/class/block/$partName/size")
      diskSize=$(cat "/sys/class/block/$(basename "$bootDevice")/size")

      if (( partStart + partSize < diskSize )); then
        echo ",+," | sfdisk -N"$partNum" --no-reread "$bootDevice"
        partx -u "$bootDevice" || true
      fi

      resize2fs "$rootPart"
    '';
  };
}
