#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix nix-prefetch-url gnused gawk
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/shitter.nix"
LOCK_FILE="$SCRIPT_DIR/lock.json"
REPO_URL="https://codeberg.org/shitter/shitter"
OAUTH_URL="https://github.com/CORDEA/oauth"

WORK_DIR=$(mktemp -d /tmp/shitter-update.XXXXXX)
cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "==> Fetching latest commit from $REPO_URL..."
git clone --quiet --depth 1 "$REPO_URL" "$WORK_DIR/repo"
LATEST_REV=$(git -C "$WORK_DIR/repo" rev-parse HEAD)
VERSION_DATE=$(git -C "$WORK_DIR/repo" show -s --format=%cs HEAD)
NEW_VERSION="0-unstable-$VERSION_DATE"

CURRENT_REV=$(sed -n 's/^[[:space:]]*rev = "\([^"]*\)";/\1/p' "$PKG_FILE" | head -n 1)
echo "    Latest commit: $LATEST_REV"
echo "    Current commit: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
  echo "==> Already up to date!"
  exit 0
fi

echo "==> Calculating source hash..."
SRC_HASH=$(nix-prefetch-url --unpack "$REPO_URL/archive/$LATEST_REV.tar.gz")
SRC_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$SRC_HASH")
echo "    Source hash: $SRC_HASH_SRI"

echo "==> Generating Nim dependency lockfile..."
if command -v nim_lk >/dev/null 2>&1; then
  nim_lk "$WORK_DIR/repo" > "$LOCK_FILE"
else
  nix shell nixpkgs#nim_lk -c nim_lk "$WORK_DIR/repo" > "$LOCK_FILE"
fi

# nim_lk may resolve a stale oauth version from its package index. Shitter
# imports oauth/oauth1, which was introduced in oauth v0.11, so pin the version
# declared in the nimble file.
OAUTH_VERSION=$(sed -n 's/.*requires "oauth == \([^"]*\)".*/\1/p' "$WORK_DIR/repo/nitter.nimble" | head -n 1)
if [[ -n "$OAUTH_VERSION" ]]; then
  OAUTH_TAG="v$OAUTH_VERSION"
  OAUTH_REV=$(git ls-remote --tags "$OAUTH_URL" "refs/tags/$OAUTH_TAG" | awk '{print $1}' | head -n 1)
  if [[ -n "$OAUTH_REV" ]]; then
    echo "==> Pinning oauth $OAUTH_TAG..."
    OAUTH_HASH=$(nix-prefetch-url --unpack "$OAUTH_URL/archive/$OAUTH_REV.tar.gz")
    TMP_LOCK=$(mktemp)
    jq \
      --arg tag "$OAUTH_TAG" \
      --arg rev "$OAUTH_REV" \
      --arg url "$OAUTH_URL/archive/$OAUTH_REV.tar.gz" \
      --arg hash "$OAUTH_HASH" \
      '(.depends[] | select((.packages | index("oauth")) != null)) |= (
        .ref = $tag
        | .rev = $rev
        | .url = $url
        | .sha256 = $hash
      )' "$LOCK_FILE" > "$TMP_LOCK"
    mv "$TMP_LOCK" "$LOCK_FILE"
  fi
fi

TMP_LOCK=$(mktemp)
jq 'del(.depends[].path)' "$LOCK_FILE" > "$TMP_LOCK"
mv "$TMP_LOCK" "$LOCK_FILE"

echo "==> Updating $PKG_FILE..."
sed -i \
  -e "s|version = \"[^\"]*\";|version = \"$NEW_VERSION\";|" \
  -e "0,/rev = \"[^\"]*\";/s|rev = \"[^\"]*\";|rev = \"$LATEST_REV\";|" \
  -e "0,/hash = \"[^\"]*\";/s|hash = \"[^\"]*\";|hash = \"$SRC_HASH_SRI\";|" \
  "$PKG_FILE"

echo "==> Done! Shitter updated to $LATEST_REV. Please verify the build."
