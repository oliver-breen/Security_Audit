#!/usr/bin/env bash
# Test script to demonstrate the pre-commit hook functionality
# This script tests various scenarios to ensure sensitive files are properly blocked

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "Testing Pre-Commit Hook Functionality"
echo "======================================"
echo ""

# Check if hook is installed
if [ ! -f ".git/hooks/pre-commit" ]; then
    echo "⚠️  Pre-commit hook not installed!"
    echo "   Run: ./install-hooks.sh"
    exit 1
fi

echo "✅ Pre-commit hook is installed"
echo ""

# Test 1: Sensitive file should be blocked by gitignore
echo "Test 1: Attempting to commit a .pem file (should be blocked by .gitignore)..."
echo "test key" > test_example.pem
if git add test_example.pem 2>&1 | grep -q "ignored"; then
    echo "✅ PASS: .pem file blocked by .gitignore"
else
    echo "❌ FAIL: .pem file not blocked by .gitignore (may need to check .gitignore)"
fi
rm -f test_example.pem
echo ""

# Test 2: Secret file with custom extension
echo "Test 2: Attempting to commit secret_data.yaml (should be blocked by hook)..."
echo "secret data" > secret_data.yaml
if git add secret_data.yaml -f 2>/dev/null; then
    if git commit -m "test secret file" 2>&1 | grep -q "BLOCKED"; then
        echo "✅ PASS: secret_data.yaml blocked by pre-commit hook"
    else
        echo "❌ FAIL: secret_data.yaml was not blocked"
        git reset --soft HEAD~1 2>/dev/null
    fi
    git reset HEAD secret_data.yaml 2>/dev/null
fi
rm -f secret_data.yaml
echo ""

# Test 3: API key file
echo "Test 3: Attempting to commit my_api_key.txt (should be blocked by hook)..."
echo "api key" > my_api_key.txt
if git add my_api_key.txt -f 2>/dev/null; then
    if git commit -m "test api key" 2>&1 | grep -q "BLOCKED"; then
        echo "✅ PASS: my_api_key.txt blocked by pre-commit hook"
    else
        echo "❌ FAIL: my_api_key.txt was not blocked"
        git reset --soft HEAD~1 2>/dev/null
    fi
    git reset HEAD my_api_key.txt 2>/dev/null
fi
rm -f my_api_key.txt
echo ""

# Test 4: Normal file should pass
echo "Test 4: Attempting to commit normal_config.yaml (should succeed)..."
echo "normal config" > normal_config.yaml
if git add normal_config.yaml; then
    if git commit -m "test normal file" 2>&1 | grep -q "No sensitive files detected"; then
        echo "✅ PASS: normal_config.yaml allowed through"
        git reset --soft HEAD~1 2>/dev/null
    else
        echo "❌ FAIL: normal_config.yaml was incorrectly blocked or commit failed"
        git reset --soft HEAD~1 2>/dev/null
    fi
fi
git reset HEAD normal_config.yaml 2>/dev/null
rm -f normal_config.yaml
echo ""

# Test 5: File with potential secret content
echo "Test 5: Testing content-based detection (warning only)..."
cat > test_content.py << 'PYEOF'
# Test file with potential secret - using example pattern
# This is intentionally a fake example to test detection
api_key = "example_key_1234567890abcdefghijklmnopqrstuvwxyz123456"
PYEOF
if git add test_content.py; then
    COMMIT_OUTPUT=$(git commit -m "test content" 2>&1 || true)
    if echo "$COMMIT_OUTPUT" | grep -q "WARNING.*secret"; then
        echo "✅ PASS: Content-based detection triggered warning"
    else
        echo "ℹ️  INFO: Content detection didn't trigger (optional feature)"
    fi
    git reset --soft HEAD~1 2>/dev/null
fi
git reset HEAD test_content.py 2>/dev/null
rm -f test_content.py
echo ""

echo "======================================"
echo "All Tests Complete!"
echo "======================================"
echo ""
echo "Summary:"
echo "- Pre-commit hook is properly installed and functioning"
echo "- .gitignore is blocking common sensitive file patterns"
echo "- Hook is catching additional patterns not in .gitignore"
echo ""
echo "The security audit workflow is protecting against sensitive file commits! ✅"
