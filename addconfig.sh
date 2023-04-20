#!/usr/bin/env bash

# This script automates getting configuration.nix from a remote source, copies it to the right path and runs nixos-install.

# It is a separate script right now in order to better test the script and decouple it from having to run the partitioning steps again.

curl -LO https://raw.githubusercontent.com/gotlougit/nix-config/main/configuration.nix
cp configuration.nix /mnt/etc/nixos/configuration.nix

echo "Copied configuration to right path"
echo "Please run 'sudo nixos-install' to start the installer"
