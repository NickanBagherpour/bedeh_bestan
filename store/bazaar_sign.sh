#!/usr/bin/env bash
# Sign an AAB for Cafe Bazaar using Bazaar's bundlesigner tool.
#
# Cafe Bazaar's App Bundle flow: after you upload the .aab, Bazaar asks you to
# "encrypt" it with their bundlesigner and upload the resulting .bin file:
#   https://developers.cafebazaar.ir/fa/guidelines/feature/app_bundle
#
# This runs `genbin`, which uses YOUR release keystore to produce a signed
# digest (.bin) for the given bundle. No .pk8/.pem conversion needed — the tool
# reads the Java KeyStore directly (--ks).
#
# Usage:
#   store/bazaar_sign.sh [path/to/app.aab]
#     (no arg = newest *.aab in store/builds/)
#
# Env overrides:
#   JAR         path to bundlesigner-*.jar   (default: newest in store/)
#   V2          v2 signing enabled           (default: true)
#   V3          v3 signing enabled           (default: false, per Bazaar's example)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ANDROID_DIR="$ROOT/apps/bedeh_bestan/android"
KEY_PROPS="$ANDROID_DIR/key.properties"
BUILDS_DIR="$ROOT/store/builds"
V2="${V2:-true}"
V3="${V3:-false}"

if [[ -t 1 ]]; then G="$(printf '\033[32m')"; Y="$(printf '\033[33m')"; R="$(printf '\033[31m')"; B="$(printf '\033[1m')"; N="$(printf '\033[0m')"; else G=""; Y=""; R=""; B=""; N=""; fi
die() { printf '%sxx %s%s\n' "$R" "$*" "$N" >&2; exit 1; }

command -v java >/dev/null || die "java not found (Bazaar's bundlesigner needs a JRE)."

# Locate the bundlesigner jar (newest match in store/).
JAR="${JAR:-}"
if [[ -z "$JAR" ]]; then
  JAR="$(ls -t "$ROOT"/store/bundlesigner-*.jar 2>/dev/null | head -1 || true)"
fi
[[ -n "$JAR" && -f "$JAR" ]] || die "bundlesigner jar not found in store/. Download it from Bazaar and place it there (it is gitignored)."

# Pick the AAB.
AAB="${1:-}"
if [[ -z "$AAB" ]]; then
  AAB="$(ls -t "$BUILDS_DIR"/*.aab 2>/dev/null | head -1 || true)"
fi
[[ -n "$AAB" && -f "$AAB" ]] || die "No AAB given and none found in store/builds/. Build one first (store/release.sh)."

# Load keystore config.
[[ -f "$KEY_PROPS" ]] || die "Missing $KEY_PROPS (run store/create_keystore.sh)."
get() { grep -E "^$1=" "$KEY_PROPS" | head -1 | cut -d= -f2-; }
KEY_ALIAS="$(get keyAlias)"
STORE_FILE_REL="$(get storeFile)"
export BB_KS_PASS="$(get storePassword)"
export BB_KEY_PASS="$(get keyPassword)"
# storeFile is relative to the android/ dir (matches build.gradle.kts rootProject.file).
case "$STORE_FILE_REL" in
  /*) STORE_FILE="$STORE_FILE_REL";;
  *)  STORE_FILE="$ANDROID_DIR/$STORE_FILE_REL";;
esac
[[ -f "$STORE_FILE" ]] || die "Keystore not found: $STORE_FILE"

printf '%s==>%s Signing for Cafe Bazaar\n' "$B" "$N"
printf '    aab : %s\n' "$AAB"
printf '    ks  : %s (alias %s)\n' "$STORE_FILE" "$KEY_ALIAS"
printf '    v2=%s v3=%s -> bin dir %s\n' "$V2" "$V3" "$BUILDS_DIR"

mkdir -p "$BUILDS_DIR"

java -jar "$JAR" genbin -v \
  --v2-signing-enabled "$V2" \
  --v3-signing-enabled "$V3" \
  --bundle "$AAB" \
  --bin "$BUILDS_DIR" \
  --ks "$STORE_FILE" \
  --ks-key-alias "$KEY_ALIAS" \
  --ks-pass "env:BB_KS_PASS" \
  --key-pass "env:BB_KEY_PASS"

# Report the produced .bin (genbin names it after the bundle).
BIN="$(ls -t "$BUILDS_DIR"/*.bin 2>/dev/null | head -1 || true)"
if [[ -n "$BIN" ]]; then
  printf '%s✓%s Upload this .bin to Bazaar: %s%s%s\n' "$G" "$N" "$B" "$BIN" "$N"
else
  printf '%s!!%s genbin finished but no .bin found in %s\n' "$Y" "$N" "$BUILDS_DIR"
fi
