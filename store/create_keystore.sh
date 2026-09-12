#!/usr/bin/env bash
# Creates android/upload-keystore.jks + android/key.properties (gitignored).
# Run once. Back up both files; losing them blocks store updates.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../apps/bedeh_bestan/android" && pwd)"
KEYSTORE="$ROOT/upload-keystore.jks"
PROPS="$ROOT/key.properties"
KEYTOOL="${KEYTOOL:-/opt/android-studio/jbr/bin/keytool}"
if [[ ! -x "$KEYTOOL" ]]; then
  KEYTOOL="$(command -v keytool)"
fi

if [[ -f "$KEYSTORE" ]]; then
  echo "Already exists: $KEYSTORE"
  exit 0
fi

PASS="$(python3 -c 'import secrets; print(secrets.token_urlsafe(24))')"
"$KEYTOOL" -genkeypair \
  -keystore "$KEYSTORE" \
  -alias upload \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -storepass "$PASS" -keypass "$PASS" \
  -dname "CN=BedeBestan, OU=NickApp, O=NickApp, L=Tehran, ST=Tehran, C=IR"

umask 077
cat > "$PROPS" <<EOF
storePassword=$PASS
keyPassword=$PASS
keyAlias=upload
storeFile=upload-keystore.jks
EOF
chmod 600 "$KEYSTORE" "$PROPS"
echo "Wrote $KEYSTORE and $PROPS"
echo "Copy both to a safe backup. Do not commit them."
