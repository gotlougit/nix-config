# Small config to boot into NixOS just to alter it to use the real config
{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Configure filesystem manually
  fileSystems."/" =
    {
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      options = [ "subvol=home" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  fileSystems."/nix" =
    {
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  fileSystems."/persist" =
    {
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      fsType = "btrfs";
    };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "kratos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gotlou = {
    isNormalUser = true;
    initialPassword = "gotlou";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
        git
    ];
  };

  system.stateVersion = "22.11";
}
