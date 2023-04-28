# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Configure systemd-boot

- Configure DNS resolving using dnscrypt-proxy2

- Add various packages that will be useful for the user

- Add a user to the system

Nice-to-haves:

- Erase root partition and reconstruct system from first boot based on the data of a few persistent directories (a-la [erase your darlings](https://grahamc.com/blog/erase-your-darlings))

- Manage many program configurations using home manager and Nix; this will require a time investment on my part to figure out how to gradually do so

- Automate secure boot setup

Most of these will be my personal preferences

## Usage

Since it is a bit difficult to find a comprehensive NixOS tutorial, I'll give you some of the steps needed to use this repo:

- Download NixOS from [the official website](https://nixos.org)

- Install it as usual (but take care to setup btrfs file system with encryption)

- Reboot into your shiny, new NixOS install

- Paste in [configuration.nix](https://raw.githubusercontent.com/gotlougit/nix-config/main/configuration.nix) into `/etc/nixos/`

- Run `sudo nixos-rebuild switch` to get my system

## Credits

- [mt-caret's blog on such a setup](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html), which I merely tried to automate into one single shell script and some Nix configurations of my own

- [Lan Tian's Intro to Flakes](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) helped migrate the repo to flakes
