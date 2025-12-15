#!/usr/bin/env bash
# Update script for island package
# Fetches latest commit, updates hashes, and regenerates Cargo.lock

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/landlock-lsm/island"
TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Cloning island repository..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR/island"

cd "$TMP_DIR/island"

# Get latest commit info
COMMIT=$(git rev-parse HEAD)
DATE=$(git log -1 --format=%cs)

echo "Latest commit: $COMMIT"
echo "Date: $DATE"

# Generate Cargo.lock
echo "Generating Cargo.lock..."
nix shell nixpkgs#cargo -c cargo generate-lockfile

# Copy Cargo.lock
cp Cargo.lock "$SCRIPT_DIR/Cargo.lock"
echo "Updated Cargo.lock"

# Calculate source hash using nix-prefetch-github
echo "Calculating source hash..."
PREFETCH_OUTPUT=$(nix shell nixpkgs#nix-prefetch-github nixpkgs#jq -c nix-prefetch-github --rev "$COMMIT" landlock-lsm island 2>/dev/null)
SRC_HASH=$(echo "$PREFETCH_OUTPUT" | nix shell nixpkgs#jq -c jq -r '.hash')

echo "Source hash: $SRC_HASH"

# Extract git dependencies and calculate their hashes
echo "Calculating git dependency hashes..."
OUTPUT_HASHES=""

# Parse Cargo.lock for git dependencies
# Format: source = "git+URL?rev=REV#HASH"
while IFS= read -r line; do
    if [[ "$line" =~ ^name\ =\ \"(.*)\"$ ]]; then
        CURRENT_NAME="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^version\ =\ \"(.*)\"$ ]]; then
        CURRENT_VERSION="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^source\ =\ \"git\+([^?]+)\?rev=([^#]+)# ]]; then
        GIT_URL="${BASH_REMATCH[1]}"
        GIT_REV="${BASH_REMATCH[2]}"
        echo "  Found git dep: $CURRENT_NAME-$CURRENT_VERSION @ $GIT_REV"
        
        DEP_HASH=$(nix shell nixpkgs#nix-prefetch-git nixpkgs#jq -c \
            nix-prefetch-git --url "$GIT_URL" --rev "$GIT_REV" 2>/dev/null | jq -r '.hash')
        
        echo "    Hash: $DEP_HASH"
        OUTPUT_HASHES+="      \"$CURRENT_NAME-$CURRENT_VERSION\" = \"$DEP_HASH\";"$'\n'
    fi
done < "$SCRIPT_DIR/Cargo.lock"

# Generate the new island.nix content
cat > "$SCRIPT_DIR/island.nix" << EOF
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "island";
  version = "0-unstable-$DATE";

  src = fetchFromGitHub {
    owner = "landlock-lsm";
    repo = "island";
    rev = "$COMMIT";
    hash = "$SRC_HASH";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
EOF

if [[ -n "$OUTPUT_HASHES" ]]; then
    cat >> "$SCRIPT_DIR/island.nix" << EOF
    outputHashes = {
$OUTPUT_HASHES    };
EOF
fi

cat >> "$SCRIPT_DIR/island.nix" << 'EOF'
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "A sandboxing tool using Landlock for secure command execution";
    homepage = "https://github.com/landlock-lsm/island";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "island";
  };
})
EOF

echo "Updated island.nix"
echo ""
echo "Done! Please verify the changes and rebuild."