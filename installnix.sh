#!/usr/bin/env bash

# This is a script to automate the nixos manual installation with a fully disk encrypted btrfs root file system setup

# Set the device name of the disk to install on
DISK=/dev/nvme0n1
BOOTPART=${DISK}p1
DATAPART=${DISK}p2

# Set the passphrase for the encryption
PASSPHRASE="secret"

# Wipe anything that was left behind
echo "WARNING: wiping ${DISK}"
wipefs --all --force ${DISK}*

# Create the EFI partition
echo "Creating EFI partition..."
parted -s $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 1024MiB
parted -s $DISK set 1 esp on

# Create the Btrfs partition with Zstd compression enabled
echo "Creating btrfs partition..."
parted -s $DISK mkpart primary 1GB 100%

echo "Encrypting root partition..."
# Encrypt the root partition using LUKS
echo -n "$PASSPHRASE" | cryptsetup luksFormat $DATAPART
echo -n "$PASSPHRASE" | cryptsetup luksOpen $DATAPART cryptroot

# Format the partitions
echo "Formatting encrypted / as btrfs..."
mkfs.btrfs -L nixos /dev/mapper/cryptroot
echo "Formatting boot partition..."
mkfs.fat -F 32 -n boot $BOOTPART

# Create subvolumes for nixos and home
echo "Creating btrfs subvolumes..."
mount -t btrfs /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
umount /mnt

echo "Mounting the filesystem to /mnt..."
# Mount the subvolumes with appropriate options
mount -o subvol=root,compress=zstd,noatime /dev/mapper/cryptroot /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/cryptroot /mnt/persist

# don't forget this!
echo "Mounting /boot..."
mkdir -p /mnt/boot/efi
mount $BOOTPART /mnt/boot/efi

# Generate a basic NixOS configuration
echo "Generating config..."
nixos-generate-config --root /mnt
echo "Done, paste in configuration"
