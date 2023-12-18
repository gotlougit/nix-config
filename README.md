# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Configure systemd-boot

- Use ZFS, a tried-and-tested and reliable CoW filesystem for storing files.
NixOS is one of the only Linux distros where ZFS is a first-class citizen, so we
might as well take advantage of it.

- Configure DNS resolving using dnscrypt-proxy2

- Configure secure NTP using chrony

- Add various packages that will be useful for the user

- Set up certain overlays, such as KeepassXC compiled without X11 and networking code

- Add a user to the system

- Use [plasma-manager](https://github.com/pjones/plasma-manager) to declare a KDE plasma config for a consistent, reproducible look and behaviour, including
key bindings and extensions.

- Use [home-manager](https://github.com/nix-community/home-manager) to manage user configs in a declarative manner, such as for git, text editors, terminal emulators etc.

- Mount root partition on tmpfs. This means apart from some specified directories bind-mounted by [Impermanence](https://github.com/nix-community/impermanence), your home directory, /nix and /boot,
the rest of your system is contained in RAM and not saved to disk. This forces you to write a completely declarative NixOS configuration and helps maintain
reproducibility and allows you to get to a "safe state" or a "clean install" simply by rebooting.

- Use [code-sandbox](https://git.sr.ht/~gotlou/code-sandbox) to create sandboxes for certain programs that prevent sensitive file access or Internet access
as well as set up a dev shell which severely restricts personal files and private SSH/GPG keys from any processes running under the present working directory

- Sandbox various system services in order to make sure they have the least amount of privileges to do their job effectively.

- Use [OpenSnitch](https://github.com/evilsocket/opensnitch) in order to only allow certain programs to be marked as trusted in order for them to get Internet access.
Everything else has to go through OpenSnitch to get permission.

- Configure the shell so it is full of useful aliases and capabilities, and use [starship](https://starship.rs/) as a prompt.

This includes using [zoxide](https://github.com/ajeetdsouza/zoxide) to make `cd` smarter, and other standard tooling aliased to Rust replacements for
faster runtimes and better defaults.

- Use [stylix](https://danth.github.io/stylix/index.html) to configure the look and feel of all the programs on the system, down to the console output on boot

Nice-to-haves:

- Automate secure boot setup

Most of these will be my personal preferences

It also houses any non-sensitive configs I deem good enough to post online

## Usage

Since it is a bit difficult to find a comprehensive NixOS tutorial, I'll give you some of the steps needed to use this repo:

- Download NixOS from [the official website](https://nixos.org)

- Use the `installnix.sh` script: it WILL erase your entire partition table, so BEWARE!!!

It will also set up ZFS native encryption, so double check the disk it will install NixOS on,
as well as set up the password you will use to decrypt the drive.

- Merge the NixOS-generated `hardware-configuration.nix` (we really need the UUID of the boot partition)
with the `hardware-configuration.nix` contained in this repo

- Run

`sudo nixos-install --flake github:gotlougit/nix-config#kratos`

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

`nix build github:gotlougit/nix-config#images.mimir`

## Credits

- [mt-caret's blog on such a setup](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html), which I merely tried to automate into one single shell script and some Nix configurations of my own

- [Lan Tian's Intro to Flakes](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) helped migrate the repo to flakes

- [Config used for neovim](https://github.com/brainfucksec/neovim-lua)

- [Example config used as starting point for Raspberry Pi setup](https://github.com/MatthewCroughan/raspberrypi-nixos-example/)
