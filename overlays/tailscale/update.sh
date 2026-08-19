#!/usr/bin/env bash
# Update script for the tailscale overlay (gotlougit fork)
# Fetches the latest commit of the fork, recomputes the src and vendor
# hashes, and rewrites overlays/tailscale/tailscale.nix in place.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/tailscale.nix"
OWNER="gotlougit"
REPO="tailscale"
REPO_URL="https://github.com/$OWNER/$REPO"

tmp_dir="$(mktemp -d /tmp/tailscale-update.XXXXXX)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

git clone --quiet --depth 1 "$REPO_URL" "$tmp_dir/repo"

commit="$(git -C "$tmp_dir/repo" rev-parse HEAD)"
date="$(git -C "$tmp_dir/repo" log -1 --format=%cs)"
version="$(cat "$tmp_dir/repo/VERSION.txt")"

echo "Latest commit: $commit ($date)"
echo "VERSION.txt:   $version"

# Source hash (matches fetchFromGitHub's fetchzip of the commit archive)
src_hash="$(
  nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$commit.tar.gz" \
    | tail -n1
)"
src_hash="$(nix hash to-sri --type sha256 "$src_hash")"
echo "Source hash:   $src_hash"

# Vendor hash: build the go-modules FOD with a dummy hash and read the real one
vendor_hash="$(
  nix build --impure --no-link \
    --expr "
      let
        pkgs = import <nixpkgs> { };
        bgo = pkgs.buildGoModule.override { go = pkgs.go_1_27; };
      in
      bgo (finalAttrs: {
        pname = \"tailscale\";
        version = \"$version-unstable-$date\";
        src = pkgs.fetchFromGitHub {
          owner = \"$OWNER\";
          repo = \"$REPO\";
          rev = \"$commit\";
          hash = \"$src_hash\";
        };
        vendorHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";
        env.CGO_ENABLED = 0;
        subPackages = [ \"cmd/tailscaled\" ];
        tags = [ \"ts_include_cli\" ];
      })
    " 2>&1 \
  | grep -oE 'got:\s+sha256-[A-Za-z0-9+/=]+' | head -n1 | awk '{print $2}'
)"
if [[ -z "$vendor_hash" ]]; then
  echo "ERROR: could not compute vendor hash" >&2
  exit 1
fi
echo "Vendor hash:   $vendor_hash"

sed -i \
  -e "s/version = \".*\";/version = \"$version-unstable-$date\";/" \
  -e "s/rev = \".*\";/rev = \"$commit\";/" \
  -e "s|hash = \".*\";|hash = \"$src_hash\";|" \
  -e "s|vendorHash = \".*\";|vendorHash = \"$vendor_hash\";|" \
  "$PKG_FILE"

echo "Updated $PKG_FILE to $commit ($date)"