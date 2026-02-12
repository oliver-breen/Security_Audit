#!/usr/bin/env bash
# Install security pre-commit hooks
# Usage: ./install-hooks.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_SOURCE="${SCRIPT_DIR}/pre-commit-hook.sh"
HOOK_DEST=".git/hooks/pre-commit"

echo "🔧 Installing pre-commit hook for sensitive file detection..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository root"
    echo "   Please run this script from the repository root directory"
    exit 1
fi

# Check if hook source exists
if [ ! -f "$HOOK_SOURCE" ]; then
    echo "❌ Error: pre-commit-hook.sh not found"
    echo "   Expected at: $HOOK_SOURCE"
    exit 1
fi

# Backup existing hook if it exists
if [ -f "$HOOK_DEST" ]; then
    BACKUP="${HOOK_DEST}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "⚠️  Existing pre-commit hook found"
    echo "   Creating backup at: $BACKUP"
    cp "$HOOK_DEST" "$BACKUP"
fi

# Install the hook
cp "$HOOK_SOURCE" "$HOOK_DEST"
chmod +x "$HOOK_DEST"

echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "The hook will now check for sensitive files before each commit."
echo ""
echo "To test the hook:"
echo "  1. Try creating a test file: touch test-secret.key"
echo "  2. Stage it: git add test-secret.key"
echo "  3. Try to commit: git commit -m 'test'"
echo "  4. The commit should be blocked"
echo ""
echo "To bypass the hook (not recommended):"
echo "  git commit --no-verify"
echo ""
echo "To uninstall:"
echo "  rm .git/hooks/pre-commit"
echo ""
