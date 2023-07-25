# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Configure systemd-boot

- Configure DNS resolving using dnscrypt-proxy2

- Add various packages that will be useful for the user

- Add a user to the system

- Erase root partition and reconstruct system from first boot based on the data of a few persistent directories (a-la [erase your darlings](https://grahamc.com/blog/erase-your-darlings))

- Set up a dev shell which severely restricts personal files and private SSH/GPG keys from any processes running under the ~/Code directory

- Add [OpenSnitch](https://github.com/evilsocket/opensnitch) to manage applications making network requests with some sane whitelists

Nice-to-haves:

- Manage many program configurations using home manager and Nix; this will require a time investment on my part to figure out how to gradually do so

- Automate secure boot setup

Most of these will be my personal preferences

It also houses my NeoVim and Helix configs, as well as any non-sensitive configs I deem good enough to post online

## Usage

Since it is a bit difficult to find a comprehensive NixOS tutorial, I'll give you some of the steps needed to use this repo:

- Download NixOS from [the official website](https://nixos.org)

- Install it as usual (but take care to setup btrfs file system with encryption)

Optionally, use the `installnix.sh` script: it WILL erase your entire partition table, so BEWARE!!!

- Reboot into your shiny, new NixOS install

- Run

`sudo nixos-rebuild switch --flake github:gotlougit/nix-config#kratos`

This will automatically get the latest configuration from this repo, apply it and build the system. This will take some time to get the packages from the NixOS cache, so feel free to get a coffee break!

- Reboot ideally, then change your password

- Use Impermanence to manage your config files

- Run `syncthing --reset-database` to force rescan the Syncthing files

- For setting up a dev environment with isolated file access, you can place the contents of `dev-shell` inside wherever you code (I have source code in `~/Code` for example)
 and swap out the paths wherever you see them accordingly

Note: this is still a WIP and may not prevent all attacks, the profile itself is being worked on a bit to have a decent balance of usability and security, although the current config is more private than no profile at all

## Raspberry Pi server config

There is also a config for a server running on a Raspberry Pi (nicknamed "mimir")

For this, it is recommended to build the image directly on a different computer and
directly flash the generated image onto an SD card. 

You can do this by running:

`nix build github:gotlougit/nix-config.#images.mimir`

## Credits

- [mt-caret's blog on such a setup](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html), which I merely tried to automate into one single shell script and some Nix configurations of my own

- [Lan Tian's Intro to Flakes](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) helped migrate the repo to flakes

- [Config used for neovim](https://github.com/brainfucksec/neovim-lua)

- [Example config used as starting point for Raspberry Pi setup](https://github.com/MatthewCroughan/raspberrypi-nixos-example/)
