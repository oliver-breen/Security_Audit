#!/usr/bin/env bash
# Lightweight reconnaissance helper.
# Usage: ./recon.sh [--authorized] target
# Note: Passive by default. Pass --authorized to allow light active probing (port discovery).
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

# Safety check
if [[ "$AUTHORIZED" != "true" ]]; then
  echo "[*] Running in safe (passive) mode. For active scans, re-run with --authorized."
fi

OUT_DIR="recon/${TARGET}"
mkdir -p "$OUT_DIR"

echo "[*] Collecting passive DNS / whois for $TARGET"
{
  echo "=== whois ==="
  whois "$TARGET" 2>/dev/null || true
  echo
  echo "=== dig A/AAAA/CNAME (public resolver) ==="
  dig +noall +answer "$TARGET" A @1.1.1.1 2>/dev/null || true
  dig +noall +answer "$TARGET" AAAA @1.1.1.1 2>/dev/null || true
  dig +noall +answer "$TARGET" CNAME @1.1.1.1 2>/dev/null || true
} > "${OUT_DIR}/passive_dns_whois.txt" || true

# Subdomain discovery (if tools installed)
echo "[*] Subdomain enumeration (if subfinder/gobuster are installed)"
if command -v subfinder >/dev/null 2>&1; then
  subfinder -d "$TARGET" -silent -o "${OUT_DIR}/subfinder.txt" || true
fi
if command -v amass >/dev/null 2>&1; then
  amass enum -d "$TARGET" -passive -o "${OUT_DIR}/amass.txt" || true
fi

# Light active probing: nmap top ports (requires --authorized)
if [[ "$AUTHORIZED" == "true" ]]; then
  echo "[*] Running light nmap scan (authorized)"
  if command -v nmap >/dev/null 2>&1; then
    mkdir -p "${OUT_DIR}/nmap"
    nmap -Pn -sV --top-ports 200 -oA "${OUT_DIR}/nmap/scan_top200" "$TARGET" || true
  fi
else
  echo "[*] Skipping nmap (requires --authorized)"
fi

echo "[*] Recon saved to $OUT_DIR"