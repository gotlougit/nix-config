#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix-prefetch-git python3
set -euo pipefail

# Update script for the Kittygram package. Kittygram uses git-lfs, so the
# source hash has to be computed with --fetch-lfs.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/kittygram.nix"

REPO_URL="https://codeberg.org/irelephant/kittygram"

echo "==> Fetching latest commit from $REPO_URL..."
LATEST_REV=$(git ls-remote "$REPO_URL" HEAD | cut -f1)
echo "    Latest commit: $LATEST_REV"

CURRENT_REV=$(python3 - "$PKG_FILE" <<'PY'
import re
import sys

text = open(sys.argv[1]).read()
m = re.search(
    r'url = "https://codeberg\.org/irelephant/kittygram";\s*\n\s*rev = "([^"]+)"',
    text,
)
print(m.group(1) if m else "")
PY
)
echo "    Current commit: $CURRENT_REV"

if [[ "$LATEST_REV" == "$CURRENT_REV" ]]; then
    echo "==> Already up to date!"
    exit 0
fi

echo "==> Calculating source hash (with git-lfs)..."
SRC_HASH=$(nix-prefetch-git --url "$REPO_URL" --rev "$LATEST_REV" --fetch-lfs --quiet | jq -r '.hash')
echo "    Source hash: $SRC_HASH"

COMMIT_DATE=$(git show -s --format=%cs "$LATEST_REV" 2>/dev/null || true)
if [[ -z "${COMMIT_DATE:-}" ]]; then
    COMMIT_DATE=$(date +%Y-%m-%d)
fi

echo "==> Updating $PKG_FILE..."
python3 - "$PKG_FILE" "$LATEST_REV" "$SRC_HASH" "$COMMIT_DATE" <<'PY'
import re
import sys

path, rev, src_hash, date = sys.argv[1:5]
text = open(path).read()

text, n1 = re.subn(
    r'(url = "https://codeberg\.org/irelephant/kittygram";\s*\n\s*rev = ")[^"]+(")',
    lambda m: m.group(1) + rev + m.group(2),
    text,
    count=1,
)
text, n2 = re.subn(
    r'(fetchLFS = true;\s*\n\s*hash = ")[^"]+(")',
    lambda m: m.group(1) + src_hash + m.group(2),
    text,
    count=1,
)
text, n3 = re.subn(
    r'(version = "0-unstable-)[^"]+(")',
    lambda m: m.group(1) + date + m.group(2),
    text,
    count=1,
)
if n1 != 1 or n2 != 1:
    raise SystemExit("failed to locate the kittygram source block")
open(path, "w").write(text)
PY

echo "==> Done! Kittygram updated to $LATEST_REV. Please verify the build!"