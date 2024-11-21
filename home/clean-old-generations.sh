 #!/usr/bin/env bash

 # Find all home-manager profile links except the newest one
 latest=$(nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)" |
   rg --only-matching "$HOME/.local/state/nix/profiles/home-manager-[0-9]*-link" | \
   sort --field-separator=- --key=3n | tail -n1)

 # Delete all except the latest
 nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)" | \
   rg --only-matching "$HOME/.local/state/nix/profiles/home-manager-[0-9]*-link" | \
   grep -v "$latest" | xargs -r rm
