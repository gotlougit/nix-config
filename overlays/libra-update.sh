#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix-prefetch-git prefetch-npm-deps gnused
set -euo pipefail

# Update script for libra-cli package
# Fetches latest commit, updates hashes, and commits changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/libra.nix"

# Use /tmp for all temporary files
WORK_DIR=$(mktemp -d /tmp/libra-update.XXXXXX)

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

REPO_URL="https://git.sr.ht/~gotlou/antigravity-cli"
OWNER="~gotlou"
REPO="antigravity-cli"

echo "==> Fetching latest commit from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" HEAD | cut -f1)
echo "    Latest commit: $LATEST_REV"

echo "==> Calculating source hash..."
SRC_HASH=$(nix-prefetch-git --url "$REPO_URL" --rev "$LATEST_REV" --quiet | jq -r '.hash')
echo "    Source hash: $SRC_HASH"

echo "==> Cloning repository to calculate npm deps hash..."
git clone --quiet --depth 1 "$REPO_URL" "$WORK_DIR/repo"
cd "$WORK_DIR/repo"

echo "==> Calculating npm deps hash..."
if [[ ! -f "package-lock.json" ]]; then
    echo "ERROR: package-lock.json not found"
    exit 1
fi

NPM_DEPS_HASH=$(prefetch-npm-deps package-lock.json 2>/dev/null)

if [[ -z "$NPM_DEPS_HASH" ]]; then
    echo "ERROR: Could not calculate npm deps hash"
    exit 1
fi

echo "    npm deps hash: $NPM_DEPS_HASH"

echo "==> Updating $PKG_FILE..."
cd "$SCRIPT_DIR"

# Update rev
sed -i "s|rev = \"[^\"]*\";|rev = \"$LATEST_REV\";|" "$PKG_FILE"

# Update source hash
sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$SRC_HASH\";|" "$PKG_FILE"

# Update npmDepsHash
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"$NPM_DEPS_HASH\";|" "$PKG_FILE"

echo "==> Done! libra-cli updated to $LATEST_REV. Note: Please verify build!"
