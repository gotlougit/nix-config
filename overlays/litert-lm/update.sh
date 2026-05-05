#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix-prefetch-github nix-prefetch-url curl gnused
set -euo pipefail

# Update script for litert-lm package
# Fetches latest release, updates hashes, and reports changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_PKG_FILE="$SCRIPT_DIR/litert-lm-api.nix"
CLI_PKG_FILE="$SCRIPT_DIR/litert-lm.nix"

REPO_URL="https://github.com/google-ai-edge/litert-lm"
OWNER="google-ai-edge"
REPO="litert-lm"

echo "==> Fetching latest release from $REPO_URL..."
LATEST_TAG=$(curl -sL "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | jq -r '.tag_name')
echo "    Latest tag: $LATEST_TAG"

# Extract current revision from litert-lm.nix
CURRENT_REV=$(grep -oP 'rev = "\K[^"].+' "$CLI_PKG_FILE")
echo "    Current rev: $CURRENT_REV"

echo "==> Fetching source hash for $LATEST_TAG..."
SRC_HASH=$(nix-prefetch-github --owner "$OWNER" --repo "$REPO" --rev "$LATEST_TAG" --quiet | jq -r '.hash')
echo "    Source hash: $SRC_HASH"

# Get version without 'v' prefix
VERSION="${LATEST_TAG#v}"
echo "    Version: $VERSION"

echo "==> Fetching wheel hash from PyPI..."
# Get the manylinux x86_64 cp313 wheel URL
WHEEL_URL=$(curl -sL "https://pypi.org/pypi/litert-lm-api/$VERSION/json" | \
  jq -r '.urls[] | select(.filename | contains("manylinux") and contains("x86_64") and contains("cp314")) | .url // empty')

# Fallback to cp313 if cp314 not available
if [[ -z "$WHEEL_URL" ]]; then
  WHEEL_URL=$(curl -sL "https://pypi.org/pypi/litert-lm-api/$VERSION/json" | \
    jq -r '.urls[] | select(.filename | contains("manylinux") and contains("x86_64") and contains("cp313")) | .url // empty')
fi

if [[ -z "$WHEEL_URL" ]]; then
  echo "    WARNING: Could not find wheel URL for litert-lm-api $VERSION"
else
  echo "    Wheel URL: $WHEEL_URL"
  WHEEL_HASH=$(nix-prefetch-url "$WHEEL_URL" 2>/dev/null)
  WHEEL_SHA256=$(nix hash to-sri --type sha256 "$WHEEL_HASH")
  echo "    Wheel hash: $WHEEL_SHA256"
fi

echo ""
echo "==> Summary of changes needed:"
echo "    Update $CLI_PKG_FILE:"
echo "      - version = \"$VERSION\""
echo "      - rev = \"v$VERSION\""
echo "      - hash = \"$SRC_HASH\""
echo ""
echo "    Update $API_PKG_FILE:"
echo "      - version = \"$VERSION\""
echo "      - hash = \"$WHEEL_SHA256\""
echo ""
echo "==> Note: Update manually or re-run with automation flags."
