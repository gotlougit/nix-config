- DO NOT WRITE DOCUMENTATION AT ALL UNLESS EXPLICITLY STATED BY THE USER!

- This is a flakes based repo with impermanence on the / path, so making any
nix changes outside this repo are ephemeral. Solutions involving these approaches
are to be immediately disregarded.

- Try to use tools like ldd and your expert knowledge of nixpkgs, nix language, nixos
and linux to figure out what libs packages might require and what might be missing

- Use the Internet to help guide your solution. The nixpkgs repo at https://github.com/nixos/nixpkgs
for source of every single package in nixpkgs and search.nixos.org to find both packages and
nixos options are good starts.

- Whenever you need to try building a new overlay you have added to the system,
it might be helpful to use the "switch-config" alias in fish shell to do so,
but since this is a flake.nix you will also have to stage the new files you have created
so that the build will find them

- Use nix prefetch github (or suitable equivalent command) to prefetch hashes for
new packages created in overlays rather than just simply running switch-config to generate
the hashes via build failure

- Whenever you create an overlay, ideally you should create it in a subdirectory
inside of overlays/, and this should comprise of a default.nix and an update.sh script.
The update.sh script helps update the hashes and commit revision/tag based on the
state of the remote repo at that time. For reference, look at how tokidoki does it
