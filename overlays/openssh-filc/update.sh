#!/usr/bin/env bash
# Update script for openssh-filc package
#
# Refreshes the pinned fil-c rev (and the corresponding GitHub archive hash)
# in overlays/openssh-filc/openssh-filc.nix. The `deluge` branch of
# pizlonator/fil-c moves frequently and tracks OpenSSH closely, so the HEAD
# of `deluge` is normally the right pin.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/openssh-filc.nix"

# Use a tmpdir for any scratch work and clean up on exit.
WORK_DIR=$(mktemp -d /tmp/openssh-filc-update.XXXXXX)
cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

REPO_URL="https://github.com/pizlonator/fil-c"
OWNER="pizlonator"
REPO="fil-c"

echo "==> Fetching latest commit on deluge from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" refs/heads/deluge | cut -f1)
echo "    Latest deluge HEAD: $LATEST_REV"

# Show the latest OpenSSH 10.x release (informational; the fil-c source already
# embeds the OpenSSH tree at the rev we're pinning, so we don't refetch it
# separately — the version is whatever's in projects/openssh-10.3p1/version.h).
LATEST_OPENSSH_V10=$(git ls-remote https://github.com/openssh/openssh-portable 'refs/tags/V_10*' 2>/dev/null | awk '{print $2}' | sort -V | tail -1 || true)
echo "    Latest OpenSSH 10.x upstream tag: ${LATEST_OPENSSH_V10:-<unknown>}"

# Extract current rev from openssh-filc.nix
CURRENT_REV=$(grep -oP 'filcRev = "\K[^"]+' "$PKG_FILE" | head -1)
echo "    Current fil-c rev: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
    echo "==> Already up to date!"
    exit 0
fi

echo "==> Calculating source hash for $LATEST_REV..."
echo "    (Note: the fil-c repo is ~1.1GB compressed because it contains the"
echo "     full LLVM/Clang fork. This may take a while.)"
SRC_HASH=$(nix-prefetch-github "$OWNER" "$REPO" "$LATEST_REV" 2>/dev/null | tail -1)
if [[ -z "$SRC_HASH" || "$SRC_HASH" != sha256-* ]]; then
    echo "ERROR: nix-prefetch-github did not return a sha256-... hash."
    echo "       Got: '$SRC_HASH'"
    exit 1
fi
echo "    Source hash: $SRC_HASH"

echo "==> Updating $PKG_FILE..."
cd "$SCRIPT_DIR"

# Update rev
sed -i "s|filcRev = \"[^\"]*\"|filcRev = \"$LATEST_REV\"|" "$PKG_FILE"

# Update hash
sed -i "s|filcHash = \"[^\"]*\"|filcHash = \"$SRC_HASH\"|" "$PKG_FILE"

echo "==> Done! openssh-filc updated to fil-c rev $LATEST_REV."
echo "    Note: please run 'nix flake check --no-build' to verify the"
echo "    overlay still evaluates, and 'nix build .#openssh-filc' (or"
echo "    the equivalent on your host config) to verify it builds."
