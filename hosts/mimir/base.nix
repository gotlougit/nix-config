{ nixos-raspberrypi, lib, pkgs, ... }:
{
  imports = [ nixos-raspberrypi.nixosModules.raspberry-pi-3.base ];

  # The generic install image turns this on and pulls in firmware and initrd
  # modules for every board.  A 3B+ booting from its SD card needs none of it;
  # the Raspberry Pi boot firmware is supplied separately by the RPi module.
  hardware.enableAllHardware = lib.mkForce false;
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.bluetooth.enable = lib.mkForce false;

  # Keep the wireless firmware available so WiFi can be configured
  # imperatively after boot.  Bluetooth remains disabled.
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];

  # This is a headless 3B+; don't waste RAM on firmware graphics, audio,
  # Wi-Fi or Bluetooth.
  hardware.raspberry-pi.config.all = {
    options = {
      gpu_mem = {
        enable = true;
        value = 16;
      };
      camera_auto_detect.enable = lib.mkForce false;
      display_auto_detect.enable = lib.mkForce false;
      max_framebuffers.enable = lib.mkForce false;
    };
    base-dt-params = {
      audio = lib.mkForce {
        enable = true;
        value = "off";
      };
    };
    dt-overlays = {
      vc4-kms-v3d.enable = lib.mkForce false;
      disable-bt.enable = true;
    };
  };

  boot = {
    # We don't use ZFS on this host.
    zfs.forceImportRoot = false;

    # The ext4 partition is mounted from the SD card, so make sure the
    # initrd can find the SD host controller and ext4.
    initrd.availableKernelModules = [
      "ext4"
      "mmc_block"
      "sdhci"
      "sdhci_iproc"
      "bcm2835_sdhost"
    ];
    blacklistedKernelModules = [
      "snd_bcm2835"
      "vc4"
      "v3d"
      "bluetooth"
      "btusb"
      "btrtl"
      "btbcm"
      "btintel"
      "btmtk"
      "btqca"
      "btsdio"
      "hci_uart"
    ];
  };

  system.nixos.tags = [
    "raspberry-pi-3"
    "uboot"
  ];
}
