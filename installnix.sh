#!/usr/bin/env bash

# This is a script to automate the nixos manual installation with a fully disk encrypted btrfs root file system setup

# Set the device name of the disk to install on
DISK=/dev/sda
BOOTPART=${DISK}1
DATAPART=${DISK}2

# Set the passphrase for the encryption
PASSPHRASE="secret"

# Wipe anything that was left behind
echo "WARNING: wiping ${DISK}"
wipefs --all --force ${DISK}*

# Create the EFI partition
echo "Creating EFI partition and LVM partition..."
parted -a opt --script "${DISK}" \
    mklabel gpt \
    mkpart primary fat32 0% 1024MiB \
    mkpart primary 1024MiB 100% \
    set 1 esp on \
    name 1 boot \
    set 2 lvm on \
    name 2 root

# Encrypt the root partition using LUKS
echo -n "$PASSPHRASE" | cryptsetup luksFormat $DATAPART
echo -n "$PASSPHRASE" | cryptsetup luksOpen $DATAPART cryptroot

# Create logical volume off of LUKS encryption
pvcreate /dev/mapper/cryptroot
vgcreate vg /dev/mapper/cryptroot
lvcreate -L 4G -n swap vg
lvcreate -l '100%FREE' -n root vg

# Format the partitions
mkfs.btrfs -L root /dev/vg/root
mkswap -L swap /dev/vg/swap
mkfs.fat -F 32 -n boot $BOOTPART

# Create subvolumes for nixos and home
mount -t btrfs /dev/disk/by-label/root /mnt
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
mount /dev/disk/by-label/boot /mnt/boot

# Generate a basic NixOS configuration
nixos-generate-config --root /mnt
echo "Done, paste in configuration.nix now"
