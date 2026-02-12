#!/usr/bin/env bash
set -euo pipefail

URL="${1:-http://127.0.0.1:5000}"
echo "[*] Checking security headers for ${URL}"

HEADERS=$(curl -s -D - -o /dev/null "${URL}")

check() {
  local header="$1"
  echo "${HEADERS}" | grep -i "^${header}:" >/dev/null && echo "✅ ${header} present" || echo "❌ ${header} missing"
}

check "Content-Security-Policy"
check "X-Content-Type-Options"
check "X-Frame-Options"
check "Referrer-Policy"
check "Permissions-Policy"
