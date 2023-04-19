#!/usr/bin/env bash

# This is a script to automate the nixos manual installation with a fully disk encrypted btrfs root file system setup

# Set the device name of the disk to install on
DISK=/dev/sda

# Set the passphrase for the encryption
PASSPHRASE="secret"

# Create the EFI partition
echo "Creating EFI partition..."
parted -s $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 1024MiB
parted -s $DISK set 1 esp on

# Create the swap partition
echo "Creating swap partition..."
parted -s $DISK mkpart primary linux-swap 1024MiB 17GB

# Create the Btrfs partition with Zstd compression enabled
echo "Creating btrfs partition..."
parted -s $DISK mkpart primary 17GB 100%

# Encrypt the root partition using LUKS
echo -n "$PASSPHRASE" | cryptsetup luksFormat ${DISK}3
echo -n "$PASSPHRASE" | cryptsetup luksOpen ${DISK}3 cryptroot

# Format the partitions
mkfs.btrfs -L nixos /dev/mapper/cryptroot
mkswap -L swap ${DISK}2
swapon ${DISK}2
mkfs.fat -F 32 -n boot ${DISK}1

# Create subvolumes for nixos and home
mount -t btrfs /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# Mount the subvolumes with appropriate options
mount -o subvol=root,compress=zstd,noatime /dev/mapper/cryptroot /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/cryptroot /mnt/persist

# don't forget this!
mkdir /mnt/boot
mount {$DISK}1 /mnt/boot

# Generate a basic NixOS configuration
nixos-generate-config --root /mnt
echo "Done, paste in configuration.nix now"
