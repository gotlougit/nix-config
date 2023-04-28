#!/usr/bin/env bash

# This script automates copying config to the right path and generating the system

echo "Downloading config..."
curl -O https://raw.githubusercontent.com/gotlougit/nix-config/main/configuration.nix

cp configuration.nix /etc/nixos/configuration.nix
echo "Copied config to /etc/nixos"

echo "Running rebuild command..."
nixos-rebuild switch
