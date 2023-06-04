#!/usr/bin/env bash

# This script automates copying config to the right path and generating the system

echo "Downloading config..."
mkdir nixos-config
cd nixos-config
curl -O https://raw.githubusercontent.com/gotlougit/nix-config/main/configuration.nix
curl -O https://raw.githubusercontent.com/gotlougit/nix-config/main/hardware-configuration.nix
curl -O https://raw.githubusercontent.com/gotlougit/nix-config/main/flake.nix
curl -O https://raw.githubusercontent.com/gotlougit/nix-config/main/flake.lock
cp *.nix flake.lock /etc/nixos/
echo "Copied config to /etc/nixos"

echo "Running rebuild command..."
nixos-rebuild switch --flake .#kratos
