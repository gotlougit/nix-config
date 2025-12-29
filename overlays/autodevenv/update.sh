#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix-prefetch-git gnused
set -euo pipefail

# Update script for autodevenv package
# Fetches latest commit, updates hashes, and commits changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/autodevenv.nix"

WORK_DIR=$(mktemp -d /tmp/autodevenv-update.XXXXXX)

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

REPO_URL="https://git.sr.ht/~gotlou/autodevenv"
OWNER="~gotlou"
REPO="autodevenv"

echo "==> Fetching latest commit from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" HEAD | cut -f1)
echo "    Latest commit: $LATEST_REV"

# Extract current revision from autodevenv.nix
CURRENT_REV=$(grep -oP 'rev = "\K[^" ]+' "$PKG_FILE")
echo "    Current commit: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
    echo "==> Already up to date!"
    exit 0
fi

echo "==> Calculating source hash..."
SRC_HASH=$(nix-prefetch-git --url "$REPO_URL" --rev "$LATEST_REV" --quiet | jq -r '.hash')
echo "    Source hash: $SRC_HASH"

echo "==> Cloning repository to calculate cargo hash..."
git clone --quiet --depth 1 "$REPO_URL" "$WORK_DIR/repo"
cd "$WORK_DIR/repo"

echo "==> Calculating cargo hash..."
# Use nix to compute the cargo hash by building with a dummy hash and extracting the correct one
CARGO_HASH=$(nix build --impure --expr "
  let
    pkgs = import <nixpkgs> {};
  in pkgs.rustPlatform.buildRustPackage {
    pname = \"autodevenv\";
    version = \"0.1.0\";
    src = $WORK_DIR/repo;
    cargoHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
  }
" 2>&1 | grep -oP 'got:\s+\K\S+' || echo "")

if [[ -z "$CARGO_HASH" ]]; then
    echo "ERROR: Could not calculate cargo hash"
    exit 1
fi

echo "    Cargo hash: $CARGO_HASH"

# Generate version string based on date
VERSION_DATE=$(date +%Y-%m-%d)
NEW_VERSION="0.1.0-unstable-$VERSION_DATE"
echo "==> New version: $NEW_VERSION"

echo "==> Updating $PKG_FILE..."
cd "$SCRIPT_DIR"

# Update version
sed -i "s|version = \"[^\"]*\";|version = \"$NEW_VERSION\";|" "$PKG_FILE"

# Update rev
sed -i "s|rev = \"[^\"]*\";|rev = \"$LATEST_REV\";|" "$PKG_FILE"

# Update hash (source hash)
sed -i "s|hash = \"[^\"]*\";|hash = \"$SRC_HASH\";|" "$PKG_FILE"

# Update cargoHash
sed -i "s|cargoHash = \"[^\"]*\";|cargoHash = \"$CARGO_HASH\";|" "$PKG_FILE"


echo "==> Done! autodevenv updated to $LATEST_REV. Note: Please verify build!"

