#!/usr/bin/env bash

# This script automates copying config to the right path and generating the config based on nix flake

# It is a separate script right now in order to better test the script and decouple it from having to run the partitioning steps again.

# Check for presence of required files
if [! -f "flake.lock"]; then
    echo "Did not find flake.lock"
    echo "Hint: did you git clone the repo?"
    exit
fi

if [! -f "flake.nix"]; then
    echo "Did not find flake.nix"
    echo "Hint: did you git clone the repo?"
    exit
fi

if [! -f "configuration.nix"]; then
    echo "Did not find configuration.nix"
    echo "Hint: did you git clone the repo?"
    exit
fi

# Copy the required files to new system
echo "Copying config to the mounted system..."
cp configuration.nix /mnt/etc/nixos/configuration.nix
cp flake.nix /mnt/etc/nixos/flake.nix
cp flake.lock /mnt/etc/nixos/flake.lock
echo "Copied configuration to right path"

# Enable nix flake
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
nix flake update

echo "Please run 'sudo nixos-install' to start the installer"
echo "ALSO: TAKE THIS TIME TO EDIT CONFIG to better suit your purposes/hardware"
echo "When you are done, you can run this script again to initiate the build step again"
