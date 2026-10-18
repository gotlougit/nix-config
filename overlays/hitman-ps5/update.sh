#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix gnused unzip yarn-berry_4.yarn-berry-fetcher
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
release=$(curl -fsSL https://api.github.com/repos/theghostonline/Hitman-PS5/releases/latest)
tag=$(jq -er '.tag_name' <<< "$release")
version=${tag#v}
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
asset="hitman-ps5-backend-src-$version.zip"
url=$(jq -er --arg name "$asset" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$release")
hash=$(nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --unpack "$url")")
work_dir=$(mktemp -d /tmp/hitman-ps5-update.XXXXXX)
trap 'rm -rf -- "$work_dir"' EXIT
curl -fsSL "$url" -o "$work_dir/source.zip"
unzip -q "$work_dir/source.zip" -d "$work_dir/source"
lockfile="$work_dir/source/hitman-ps5-backend-src-$version/yarn.lock"
yarn-berry-fetcher missing-hashes "$lockfile" > "$work_dir/missing-hashes.json"
deps_hash=$(yarn-berry-fetcher prefetch "$lockfile" "$work_dir/missing-hashes.json")
install -m 0644 "$work_dir/missing-hashes.json" "$script_dir/missing-hashes.json"
sed -i -E \
  -e "s|version = \"[^\"]+\";|version = \"$version\";|" \
  -e "/src = fetchzip/,/^  };/ s|hash = \"[^\"]+\";|hash = \"$hash\";|" \
  -e "/offlineCache =/,/^  };/ s|hash = \"[^\"]+\";|hash = \"$deps_hash\";|" \
  "$script_dir/package.nix"
printf 'Updated hitman-ps5 to %s (source %s, dependencies %s)\n' "$version" "$hash" "$deps_hash"
