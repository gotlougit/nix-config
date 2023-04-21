# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Auto-partition a btrfs + LUKS encrypted system with UEFI boot, with zstd compression

WARNING: this is designed for a system with ONLY NixOS! It WILL wipe any and all previous partition info on the drive you select! You may or may NOT be able to recover the stored data!

- Configure systemd-boot

- Configure DNS resolving using dnscrypt-proxy2

- Add various packages that will be useful for the user

- Add a user to the system

- Configure a 16GB swap partition

Nice-to-haves:

- Erase root partition and reconstruct system from first boot based on the data of a few persistent directories (a-la [erase your darlings](https://grahamc.com/blog/erase-your-darlings))

- Manage many program configurations using home manager and Nix; this will require a time investment on my part to figure out how to gradually do so

Most of these will be my personal preferences

## Usage

Since it is a bit difficult to find a comprehensive NixOS tutorial, I'll give you some of the steps needed to use this repo:

- Boot into NixOS live CD

- Get git: `nix-env -iA git`

- Clone this repo with git:

`git clone https://github.com/gotlougit/nix-config`

or

`git clone https://git.sr.ht/~gotlou/nix-config`

- `cd nix-config`

- Now, the first script to run is `installnix.sh`. It mainly deals with partitioning and setting up the NixOS install with a `configuration.nix`

You have to CHANGE the following values based on your hardware:

    - DISK: this is the variable which tells the script which drive to install NixOS on

    - BOOTPART: the partition to install /boot on.

    - SWAPPART: the partition to install swap on.

    - DATAPART: the partition to install / on.

    - PASSPHRASE: the password you use to encrypt your drive with. Make this a good password so that it is hard to brute-force or guess it

Note: for a VM install, you should probably run

`sed -i s/17/2/g installnix.sh`

to configure 1GB swap instead of 16GB

- After doing so, run `sudo bash installnix.sh`. It will do all the steps by itself, and hopefully should partition and run `addconfig.sh`, which copies over the \*.nix files by itself into the right locations.

- You should then run `sudo nixos-install` and if all goes right, you can then reboot into a fresh NixOS install!

Note: I use my Thinkpad E14 AMD's config from [nix-hardware](https://github.com/NixOS/nixos-hardware), if you have a different machine, you should use the generated `hardware-configuration.nix` instead. More instructions for this will be posted here.

## Credits

- [mt-caret's blog on such a setup](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html), which I merely tried to automate into one single shell script and some Nix configurations of my own

- [Lan Tian's Intro to Flakes](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) helped migrate the repo to flakes
