#!/usr/bin/env bash
# Static analysis helper for Python projects (Bandit).
# Usage: ./static_analysis.sh [path]
set -euo pipefail

TARGET_DIR="${1:-.}"
OUT_DIR="scans/static"
mkdir -p "$OUT_DIR"

if command -v bandit >/dev/null 2>&1; then
  echo "[*] Running bandit on ${TARGET_DIR}"
  bandit -r "$TARGET_DIR" -f json -o "${OUT_DIR}/bandit.json" || true
else
  echo "[!] bandit not installed. Install with: pip install bandit"
fi

echo "[*] Static analysis outputs saved to $OUT_DIR"