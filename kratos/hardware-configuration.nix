# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/1046-8921";
    fsType = "vfat";
  };

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=1G" "mode=755" ];
    };
  
  fileSystems."/tmp" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=5G" "mode=755" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/434e510a-b269-4f83-a0b6-0a8532a8ff07";

  fileSystems."/home" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=nix" ];
    };

  fileSystems."/persist" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=persist" ];
      neededForBoot = true;
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}