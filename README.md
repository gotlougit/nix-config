# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Auto-partition a btrfs + LUKS encrypted system with UEFI boot, with zstd compression

- Configure systemd-boot

- Configure DNS resolving using dnscrypt-proxy2

- Add various packages that will be useful for the user

- Add users to the system

- Configure a 16GB swap partition

Nice-to-haves:

- Erase root partition and reconstruct system from first boot based on the data of a few persistent directories (a-la [erase your darlings](https://grahamc.com/blog/erase-your-darlings))

- Manage many program configurations using home manager and Nix; this will require a time investment on my part to figure out how to gradually do so

Most of these will be my personal preferences

## Credits

- [mt-caret's blog on such a setup](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html), which I merely tried to automate into one single shell script and some Nix configurations of my own

- [Lan Tian's Intro to Flakes](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) helped migrate the repo to flakes
