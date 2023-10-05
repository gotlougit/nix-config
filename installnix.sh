#!/usr/bin/env bash

# Set the device name of the disk to install on
DISK=/dev/nvme0n1
BOOTPART=${DISK}p1
DATAPART=${DISK}p2

# Set the passphrase for the encryption
PASSPHRASE="secret"

# Set ZFS pool and datasets
ZFS_POOL="nixos_pool"
ZFS_HOME_DATASET="$ZFS_POOL/home"
ZFS_NIX_DATASET="$ZFS_POOL/nix"
ZFS_PERSIST_DATASET="$ZFS_POOL/persist"

# Wipe anything that was left behind
echo "WARNING: wiping ${DISK}"
wipefs --all --force ${DISK}*

# Create the EFI partition
echo "Creating EFI partition..."
parted -s $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 1024MiB
parted -s $DISK set 1 esp on

# Create the boot partition
echo "Formatting boot partition..."
mkfs.fat -F 32 -n boot $BOOTPART

# Create the ZFS pool
echo "Creating ZFS pool with native encryption..."
echo $PASSPHRASE | zpool create -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt $ZFS_POOL $DATAPART

# Create ZFS datasets
echo "Creating ZFS datasets..."
# Stores persistent data
zfs create $ZFS_PERSIST_DATASET -o atime=off -o compression=zstd
# Stores required packages etc
zfs create $ZFS_NIX_DATASET-o atime=off -o compression=zstd
# Home directory for system
zfs create $ZFS_HOME_DATASET -o atime=off -o compression=zstd

mkdir -p /mnt

# Mount datasets
mkdir /mnt/home
mount -t zfs $ZFS_HOME_DATASET /mnt/home

mkdir /mnt/nix
mount -t zfs $ZFS_NIX_DATASET /mnt/nix

mkdir /mnt/persist
mount -t zfs $ZFS_PERSIST_DATASET /mnt/persist

# Mount the EFI partition
echo "Mounting /boot..."
mkdir -p /mnt/boot/efi
mount $BOOTPART /mnt/boot/efi

# Generate a basic NixOS configuration
echo "Generating config..."
nixos-generate-config --root /mnt

# Create the necessary subdirs in /persist
echo "Creating /persist subdirectories..."
mkdir -p /mnt/persist/communication /mnt/persist/gaming /mnt/persist/sensitive /mnt/persist/system /mnt/persist/dotfiles
echo "Done, paste in configuration"
