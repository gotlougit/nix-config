#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix-prefetch-git go gnused
set -euo pipefail

# Update script for tokidoki package
# Fetches latest commit, updates hashes, and commits changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/tokidoki.nix"

# Use /tmp for all temporary files and Go caches
WORK_DIR=$(mktemp -d /tmp/tokidoki-update.XXXXXX)
export GOHOME="$WORK_DIR/go-home"
export GOMODCACHE="$WORK_DIR/go-mod-cache"
export GOCACHE="$WORK_DIR/go-cache"
mkdir -p "$GOHOME" "$GOMODCACHE" "$GOCACHE"

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

REPO_URL="https://git.sr.ht/~sircmpwn/tokidoki"
OWNER="~sircmpwn"
REPO="tokidoki"

echo "==> Fetching latest commit from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" HEAD | cut -f1)
echo "    Latest commit: $LATEST_REV"

# Extract current revision from tokidoki.nix
CURRENT_REV=$(grep -oP 'rev = "\K[^"].+' "$PKG_FILE")
echo "    Current commit: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
    echo "==> Already up to date!"
    exit 0
fi

echo "==> Calculating source hash..."
SRC_HASH=$(nix-prefetch-git --url "$REPO_URL" --rev "$LATEST_REV" --quiet | jq -r '.hash')
echo "    Source hash: $SRC_HASH"

echo "==> Cloning repository to calculate vendor hash..."
git clone --quiet --depth 1 "$REPO_URL" "$WORK_DIR/repo"
cd "$WORK_DIR/repo"

echo "==> Calculating vendor hash..."
# Use nix to compute the vendor hash by building a FOD with an empty hash
VENDOR_HASH=$(nix-prefetch -E "{ sha256 }: ((import <nixpkgs> {}).buildGoModule {
  pname = \"tokidoki\";
  version = \"0-unstable\";
  src = $WORK_DIR/repo;
  vendorHash = sha256;
  subPackages = [ \"cmd/tokidoki\" ];
}).goModules" 2>/dev/null || true)

# If nix-prefetch fails, try alternative method
if [[ -z "$VENDOR_HASH" ]]; then
    echo "    Trying alternative vendor hash calculation..."
    # Download modules and hash them
    go mod download -x 2>/dev/null
    VENDOR_HASH=$(nix hash path "$GOMODCACHE" 2>/dev/null || echo "")
fi

# If still empty, use nix-prefetch-url with go mod vendor approach
if [[ -z "$VENDOR_HASH" ]]; then
    echo "    Trying go mod vendor approach..."
    go mod vendor 2>/dev/null
    VENDOR_HASH=$(nix hash path vendor)
fi

if [[ -z "$VENDOR_HASH" ]]; then
    echo "ERROR: Could not calculate vendor hash"
    exit 1
fi

echo "    Vendor hash: $VENDOR_HASH"

# Generate version string based on date
VERSION_DATE=$(date +%Y-%m-%d)
NEW_VERSION="0-unstable-$VERSION_DATE"
echo "==> New version: $NEW_VERSION"

echo "==> Updating $PKG_FILE..."
cd "$SCRIPT_DIR"

# Update version
sed -i "s|version = \"[^\"]*\";|version = \"$NEW_VERSION\";|" "$PKG_FILE"

# Update rev
sed -i "s|rev = \"[^\"]*\";|rev = \"$LATEST_REV\";|" "$PKG_FILE"

# Update sha256 (source hash)
sed -i "s|sha256 = \"[^\"]*\";|sha256 = \"$SRC_HASH\";|" "$PKG_FILE"

# Update vendorHash
sed -i "s|vendorHash = \"[^\"]*\";|vendorHash = \"$VENDOR_HASH\";|" "$PKG_FILE"

echo "==> Done! tokidoki updated to $LATEST_REV. Note: Please verify build!"
