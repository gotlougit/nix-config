#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git nix-prefetch-url gnused
set -euo pipefail

# Update script for mullvad-tailscale package
# Fetches latest commit, updates hash, and commits changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/mullvad-tailscale.nix"

REPO_URL="https://github.com/r3nor/mullvad-tailscale"
OWNER="r3nor"
REPO="mullvad-tailscale"

echo "==> Fetching latest commit from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" HEAD | cut -f1)
echo "    Latest commit: $LATEST_REV"

# Extract current revision from mullvad-tailscale.nix
CURRENT_REV=$(grep -oP 'rev = "\K[^"].+' "$PKG_FILE")
echo "    Current commit: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
    echo "==> Already up to date!"
    exit 0
fi

echo "==> Calculating source hash..."
TARBALL_URL="https://github.com/$OWNER/$REPO/archive/$LATEST_REV.tar.gz"
SRC_HASH=$(nix-prefetch-url --type sha256 --unpack "$TARBALL_URL" 2>/dev/null | tail -1)
echo "    Source hash (base32): $SRC_HASH"

# Convert to SRI format
SRC_HASH_SRI=$(nix hash to-sri --type sha256 "$SRC_HASH")
echo "    Source hash (SRI): $SRC_HASH_SRI"

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

# Update hash
sed -i "s|hash = \"[^\"]*\";|hash = \"$SRC_HASH_SRI\";|" "$PKG_FILE"

echo "==> Done! mullvad-tailscale updated to $LATEST_REV."
