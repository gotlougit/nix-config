# NixOS Config

This repo aims to create as much an automated, reproducible install of NixOS as possible.

It will:

- Auto-partition a btrfs + LUKS encrypted system with UEFI boot, with zstd compression

- Configure systemd-boot

- Configure DNS resolving using dnscrypt-proxy2

- Add various packages that will be useful for the user

- Add users to the system

Nice-to-haves:

- Erase root partition and reconstruct system from first boot based on the data of a few persistent directories (a-la [erase your darlings](https://grahamc.com/blog/erase-your-darlings))

- Manage many program configurations using home manager and Nix; this will require a time investment on my part to figure out how to gradually do so

Most of these will be my personal preferences
