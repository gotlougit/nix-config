#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/codex-auth.nix"
OWNER="loongphy"
REPO="codex-auth"
REPO_URL="https://github.com/$OWNER/$REPO"

tmp_dir="$(mktemp -d /tmp/codex-auth-update.XXXXXX)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

git clone --depth 1 "$REPO_URL" "$tmp_dir/repo"

commit="$(git -C "$tmp_dir/repo" rev-parse HEAD)"
date="$(git -C "$tmp_dir/repo" log -1 --format=%cs)"
hash="$(
  nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$commit.tar.gz" \
    | tail -n1
)"
sri_hash="$(nix hash to-sri --type sha256 "$hash")"

sed -i \
  -e "s/version = \".*\";/version = \"0-unstable-$date\";/" \
  -e "s/rev = \".*\";/rev = \"$commit\";/" \
  -e "s|hash = \".*\";|hash = \"$sri_hash\";|" \
  "$PKG_FILE"

echo "Updated codex-auth to $commit ($date)"
