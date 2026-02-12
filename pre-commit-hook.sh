#!/usr/bin/env bash
# Pre-commit hook to prevent committing sensitive files
# This hook checks for common sensitive file patterns before allowing a commit

set -e

echo "🔍 Running sensitive file check..."

# Define sensitive file patterns
SENSITIVE_PATTERNS=(
    "*.key"
    "*.pem"
    "*.p12"
    "*.pfx"
    "*.crt"
    "*.der"
    "*.cer"
    "*.cert"
    "*.jks"
    "*.keystore"
    "*.pkcs12"
    "secret*"
    "Secret*"
    "SECRET*"
    ".env*"
    "*.env"
    "credentials*"
    "Credentials*"
    "CREDENTIALS*"
    "*_rsa"
    "*_dsa"
    "*_ecdsa"
    "*_ed25519"
    "id_rsa*"
    "id_dsa*"
    "id_ecdsa*"
    "id_ed25519*"
    "*.ppk"
    "*.kdb"
    "*.kdbx"
    "*.agilekeychain"
    "*.keychain"
    "wallet.dat"
    "*.ovpn"
    "*.tblk"
    "authinfo*"
    "*authinfo*"
    ".netrc"
    ".pgpass"
    "*.password"
    "*password*"
    "*.token"
    "*token*"
    "*.apikey"
    "*apikey*"
    "*api_key*"
    "*api-key*"
    "aws*.json"
    "gcloud*.json"
    "azure*.json"
    "service-account*.json"
    "credentials.json"
    "client_secret*.json"
)

# Get list of files to be committed
FILES_TO_COMMIT=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$FILES_TO_COMMIT" ]; then
    echo "✅ No files to check"
    exit 0
fi

FOUND_SENSITIVE=0

# Check each file against sensitive patterns
while IFS= read -r file; do
    # Skip if file doesn't exist (deleted files)
    [ -f "$file" ] || continue
    
    # Check filename against patterns
    filename=$(basename "$file")
    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        # Convert glob pattern to regex for matching
        pattern_regex=$(echo "$pattern" | sed 's/\./\\./g; s/\*/.*/g')
        if [[ "$filename" =~ ^${pattern_regex}$ ]]; then
            echo "❌ BLOCKED: Sensitive file detected: $file (matches pattern: $pattern)"
            FOUND_SENSITIVE=1
        fi
    done
    
    # Check file content for potential secrets (basic patterns)
    if grep -qE "(api[_-]?key|password|secret|token|bearer|private[_-]?key|access[_-]?key)['\"]?\s*[:=]\s*['\"]?[a-zA-Z0-9+/=_-]{20,}" "$file" 2>/dev/null; then
        # Exclude common false positives (documentation, examples)
        if ! grep -q "# Example\|# Sample\|TODO\|FIXME\|placeholder\|example\.com\|your-api-key\|YOUR_\|<your" "$file" 2>/dev/null; then
            echo "⚠️  WARNING: Potential secret detected in: $file"
            echo "   Please review the file content before committing."
            # Don't block, just warn for content-based detection
        fi
    fi
done <<< "$FILES_TO_COMMIT"

if [ $FOUND_SENSITIVE -eq 1 ]; then
    echo ""
    echo "❌ COMMIT BLOCKED: Sensitive files detected!"
    echo ""
    echo "To fix this:"
    echo "1. Remove sensitive files from staging: git reset HEAD <file>"
    echo "2. Add them to .gitignore to prevent future accidents"
    echo "3. If you absolutely must commit these files (not recommended):"
    echo "   - Use: git commit --no-verify"
    echo "   - Or remove this hook: rm .git/hooks/pre-commit"
    echo ""
    exit 1
fi

echo "✅ No sensitive files detected - proceeding with commit"
exit 0
