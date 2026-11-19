#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq unzip gnused nix
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/default.nix"

REPO="phantomptr/ps5upload"

current_version="$(sed -n 's/^  version = "\(.*\)";/\1/p' "$PKG_FILE")"
latest_version="$(
  curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
    | jq -r '.tag_name | sub("^v"; "")'
)"

echo "current: $current_version"
echo "latest:  $latest_version"

if [[ "$current_version" == "$latest_version" ]]; then
  echo "Already up to date."
  exit 0
fi

workdir="$(mktemp -d /tmp/ps5upload-update.XXXXXX)"
trap 'rm -rf "$workdir"' EXIT

for pair in "x64:x86_64" "arm64:aarch64"; do
  arch="${pair%%:*}"
  attr="${pair#*:}"
  url="https://github.com/${REPO}/releases/download/v${latest_version}/PS5Upload-${latest_version}-linux-${arch}.zip"
  zip="$workdir/ps5upload-${arch}.zip"

  echo "Fetching $url"
  curl -fsSL -o "$zip" "$url"
  unzip -l "$zip" | grep -q 'PS5Upload.AppImage' || {
    echo "error: ${arch} archive does not contain PS5Upload.AppImage" >&2
    exit 1
  }

  hash="$(nix hash file --type sha256 --sri "$zip")"
  echo "$attr: $hash"

  sed -i "s@\(${attr} = \)\"sha256-[^\"]*\"@\1\"${hash}\"@" "$PKG_FILE"
done

sed -i "s@^  version = \"${current_version}\";@  version = \"${latest_version}\";@" "$PKG_FILE"

echo "Updated ps5upload to ${latest_version}."
