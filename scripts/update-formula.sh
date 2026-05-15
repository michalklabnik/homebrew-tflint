#!/usr/bin/env bash
# Updates Formula/tflint.rb to a new tflint version and SHA256 pair.
#
# Usage: scripts/update-formula.sh <new-version> <arm64-sha256> <amd64-sha256>
#
# Idempotent: running twice with the same arguments leaves the file unchanged.
# All three arguments are required; SHA256 values must be 64 lowercase hex chars.

set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: $0 <new-version> <arm64-sha256> <amd64-sha256>" >&2
  exit 2
fi

NEW_VERSION="$1"
ARM_SHA="$2"
AMD_SHA="$3"

# Strip an optional leading "v" from the version (accept either "0.62.1" or "v0.62.1").
NEW_VERSION="${NEW_VERSION#v}"

if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: version must be semver X.Y.Z (got: $NEW_VERSION)" >&2
  exit 2
fi
for sha in "$ARM_SHA" "$AMD_SHA"; do
  if [[ ! "$sha" =~ ^[a-f0-9]{64}$ ]]; then
    echo "error: sha256 must be 64 lowercase hex chars (got: $sha)" >&2
    exit 2
  fi
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FORMULA="$REPO_ROOT/Formula/tflint.rb"

if [[ ! -f "$FORMULA" ]]; then
  echo "error: $FORMULA not found" >&2
  exit 1
fi

# Rewrite version line and the two sha256 lines scoped to on_arm / on_intel blocks.
# awk is used over sed because we need block-scoped state (which sha256 belongs
# to which arch) and we want portable behavior across BSD/GNU.
awk -v new_ver="$NEW_VERSION" -v arm="$ARM_SHA" -v amd="$AMD_SHA" '
  /^  version "[^"]*"$/ {
    sub(/"[^"]*"/, "\"" new_ver "\"")
    print
    next
  }
  /on_arm do/   { in_arm = 1; in_intel = 0 }
  /on_intel do/ { in_intel = 1; in_arm = 0 }
  /^    end$/   { in_arm = 0; in_intel = 0 }
  /^      sha256 "/ && in_arm {
    sub(/"[a-f0-9]+"/, "\"" arm "\"")
    print
    next
  }
  /^      sha256 "/ && in_intel {
    sub(/"[a-f0-9]+"/, "\"" amd "\"")
    print
    next
  }
  { print }
' "$FORMULA" > "$FORMULA.tmp"

mv "$FORMULA.tmp" "$FORMULA"

# Sanity: confirm all three values landed exactly once.
grep -qx "  version \"$NEW_VERSION\"" "$FORMULA" || { echo "error: version not updated" >&2; exit 1; }
grep -qx "      sha256 \"$ARM_SHA\""  "$FORMULA" || { echo "error: arm64 sha not updated" >&2; exit 1; }
grep -qx "      sha256 \"$AMD_SHA\""  "$FORMULA" || { echo "error: amd64 sha not updated" >&2; exit 1; }

echo "updated $FORMULA -> version=$NEW_VERSION"
