#!/usr/bin/env bash
# Scanner orchestrator: runs web discovery and optional intrusive checks.
# Usage: ./scan.sh [--authorized] target
set -euo pipefail

AUTHORIZED=false
TARGET=""

if [[ "${1:-}" == "--authorized" ]]; then
  AUTHORIZED=true
  shift
fi

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 [--authorized] target"
  exit 2
fi
TARGET="$1"

OUT_DIR="scans/${TARGET}"
mkdir -p "$OUT_DIR"

echo "[*] Web discovery for $TARGET"

# Directory bruteforce (gobuster if installed)
if command -v gobuster >/dev/null 2>&1; then
  echo "[*] Running gobuster (common-words). Output: ${OUT_DIR}/gobuster.txt"
  gobuster dir -u "http://${TARGET}" -w /usr/share/wordlists/dirb/common.txt -q -t 20 2>/dev/null | sed '/^$/d' > "${OUT_DIR}/gobuster.txt" || true
else
  echo "[!] gobuster not found, skipping"
fi

# Nikto (light web vulnerability scan — non-exploit)
if command -v nikto >/dev/null 2>&1; then
  echo "[*] Running nikto (non-intrusive). Output: ${OUT_DIR}/nikto.txt"
  nikto -h "http://${TARGET}" -o "${OUT_DIR}/nikto.txt" -Format txt || true
else
  echo "[!] nikto not installed, skipping"
fi

# SQLi/emulation and exploitation tools require explicit authorization
if [[ "$AUTHORIZED" == "true" ]]; then
  echo "[*] Authorized mode: running additional checks (sqlmap template shown)"
  # Create a scan plan file for manual review
  cat > "${OUT_DIR}/INTRUSIVE_NOTES.txt" <<'EOF'
This directory contains pointers for intrusive testing. Do NOT run these unless you have signed authorization.
Example manual step (sqlmap):
  sqlmap -u "http://TARGET/search" --data="q=example" --batch --level=2 --risk=1
Always review and obtain written permission. Keep activity logs.
EOF
else
  echo "[*] Skipping intrusive checks (requires --authorized). See ${OUT_DIR}/INTRUSIVE_NOTES.txt for guidance."
  cat > "${OUT_DIR}/INTRUSIVE_NOTES.txt" <<'EOF'
Intrusive tests are disabled. To enable them, re-run this script with --authorized.
Examples of intrusive checks:
 - sqlmap for SQLi exploitation
 - authenticated scanning with Burp Suite active intrusions
 - fuzzing / brute forcing
Always have written authorization.
EOF
fi

echo "[*] Scan outputs saved to $OUT_DIR"