{
  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "nixos_pool" ];
    requestEncryptionCredentials = true;
  };
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
}
