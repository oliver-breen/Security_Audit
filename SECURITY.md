# Security Guidelines for Security_Audit Repository

## Overview

This repository includes multiple layers of protection to prevent accidentally committing sensitive files like private keys, credentials, and secrets.

## Protection Layers

### 1. Git Pre-Commit Hook (Local Protection)

A pre-commit hook that runs on your local machine before each commit to check for sensitive files.

#### Installation

```bash
./install-hooks.sh
```

This will install the pre-commit hook that automatically checks for sensitive file patterns.

#### What It Checks

The pre-commit hook blocks commits containing files that match these patterns:
- Private keys: `*.key`, `*.pem`, `*.p12`, `*.pfx`, `id_rsa*`, etc.
- Certificates: `*.crt`, `*.der`, `*.cer`, `*.cert`, etc.
- Secret files: `secret*`, `credentials*`, etc.
- Environment files: `.env*`, `*.env`
- Cloud credentials: `aws*.json`, `gcloud*.json`, `service-account*.json`, etc.
- Password managers: `*.kdb`, `*.kdbx`, `wallet.dat`, etc.
- VPN configs: `*.ovpn`, `*.tblk`
- Auth files: `.netrc`, `.pgpass`, `*.token`, `*.apikey`

#### Content Scanning

The hook also performs basic content scanning to detect potential secrets in files:
- API keys
- Passwords
- Tokens
- Bearer tokens
- Private keys (in content)
- Access keys

This generates warnings (not blocks) to help you review potentially sensitive content.

#### Bypassing the Hook (Not Recommended)

In rare cases where you need to bypass the hook:

```bash
git commit --no-verify
```

**⚠️ WARNING:** Only bypass if you are absolutely certain the files are safe to commit.

### 2. .gitignore (Automatic Exclusion)

The `.gitignore` file is configured to automatically exclude common sensitive files and directories:

- All patterns checked by the pre-commit hook
- Scan output directories: `recon/`, `scans/`, `findings/`
- Cloud provider config directories: `.aws/`, `.azure/`, `.gcloud/`

### 3. GitHub Actions Workflow (CI Protection)

The GitHub Actions workflow (`.github/workflows/security-audit.yml`) provides additional checks:

- **TruffleHog Secret Scan**: Detects secrets in commit history
- **Sensitive File Check**: Validates no sensitive files are in the repository
- Runs on: pull requests, pushes to main, and weekly schedule

## Best Practices

### For Security Audit Work

1. **Keep Secrets Separate**: Never store real credentials in the repository
2. **Use Environment Variables**: Store sensitive configuration in environment variables
3. **Sanitize Outputs**: Before committing scan results, ensure they don't contain:
   - IP addresses of production systems
   - Real credentials or API keys
   - Sensitive business information
   - Personally identifiable information (PII)

4. **Use Placeholders**: In examples and documentation, use:
   - `example.com` for domains
   - `192.0.2.1` (TEST-NET-1) for IP addresses
   - `user@example.com` for emails
   - `YOUR_API_KEY_HERE` for API keys

### For Tool Development

1. **Test Credentials**: Use clearly marked test/dummy credentials
2. **Scan Isolation**: Run scans in isolated directories that are gitignored
3. **Output Directories**: The following directories are gitignored:
   - `recon/` - reconnaissance outputs
   - `scans/` - scanner outputs
   - `findings/` - normalized findings
   - `audit-output/` - generated reports

## Testing the Pre-Commit Hook

You can test that the hook is working correctly:

```bash
# Create a test sensitive file
echo "test" > test-secret.key

# Try to stage and commit it
git add test-secret.key
git commit -m "test"

# Expected: Commit should be blocked
# Clean up
git reset HEAD test-secret.key
rm test-secret.key
```

## Uninstalling the Hook

If you need to remove the pre-commit hook:

```bash
rm .git/hooks/pre-commit
```

## Recovering from Accidental Commits

If you accidentally commit sensitive data:

### Before Pushing

```bash
# Remove the file from the last commit
git rm --cached <sensitive-file>
git commit --amend --no-edit

# Or reset the commit entirely
git reset --soft HEAD~1
```

### After Pushing

If sensitive data was already pushed to GitHub:

1. **Immediately rotate/revoke the exposed credentials**
2. Contact a repository administrator
3. Consider using tools like:
   - `git filter-branch` (deprecated but works)
   - `BFG Repo-Cleaner` (recommended)
   - GitHub's guide: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

**⚠️ Important:** Simply deleting a file in a new commit doesn't remove it from git history!

## Security Scanning Tools

This repository uses several security scanning tools:

- **Bandit**: Python security linter
- **Safety**: Python dependency vulnerability scanner
- **ShellCheck**: Shell script analysis
- **CodeQL**: GitHub's semantic code analysis
- **TruffleHog**: Secret detection in git history
- **Dependency Review**: Checks for vulnerable dependencies in PRs

## Reporting Security Issues

If you discover a security vulnerability in this repository:

1. **Do NOT create a public issue**
2. Email the repository owner with details
3. Wait for a response before disclosure

## Additional Resources

- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [Git Hooks Documentation](https://git-scm.com/docs/githooks)

## Maintenance

The pre-commit hook and sensitive file patterns should be reviewed and updated periodically to cover new types of sensitive files and emerging patterns.

Last updated: 2026-02-12
