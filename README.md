# Security Audit — Portfolio Project

This repository contains:
- A reusable cybersecurity audit template and checklist to use in your portfolio.
- A redacted sample audit for demonstration.
- A small intentionally-vulnerable Flask application (vulnerable_app/) you can run locally to practice auditing and to produce sample reports.
- **Built-in protection against committing sensitive files** (pre-commit hooks + GitHub Actions)

⚠️ **Important:** Only run the vulnerable app locally or on isolated test hosts you control. Never use these tools or techniques against systems you do not own or do not have explicit written authorization to test.

## Setup

### Install Pre-Commit Hook (Recommended)

Protect against accidentally committing sensitive files:

```bash
./install-hooks.sh
```

This installs a pre-commit hook that checks for private keys, credentials, and other sensitive files before each commit. See [SECURITY.md](SECURITY.md) for details.

## Repository Layout

- **AUDIT_TEMPLATE.md** — canonical audit report template
- **CHECKLIST.md** — audit checklist
- **SAMPLE_AUDIT.md** — short example audit (redacted)
- **vulnerable_app/** — small Flask app intentionally created for practice
- **SECURITY.md** — security guidelines and sensitive file protection
- **install-hooks.sh** — installs pre-commit hooks for security
- **pre-commit-hook.sh** — the actual pre-commit hook script
- **recon.sh, scan.sh, static_analysis.sh** — security scanning scripts
- **report_generator.py** — converts scan findings to markdown reports

## Running the Vulnerable App

To run the vulnerable app for practice:
1. cd vulnerable_app
2. python3 -m venv venv && source venv/bin/activate
3. pip install -r requirements.txt
4. python app.py
5. Open http://127.0.0.1:5000 in your browser

## Security Features

This repository includes multiple layers of protection against committing sensitive data:

1. **Pre-commit Hook**: Local validation before each commit
2. **.gitignore**: Automatic exclusion of sensitive file patterns
3. **GitHub Actions**: CI/CD checks including TruffleHog secret scanning

See [SECURITY.md](SECURITY.md) for complete documentation.
