```markdown
# Sample Audit — ExampleCorp Web App (Redacted)

Date: 2025-08-01
Author: Oliver Breen

Executive Summary
- High: 1 (SQL Injection in /search)
- Medium: 1 (Reflected XSS in /comments)
- Several low/info issues (headers, disclosure)

Top Findings
- FIND-001 (High) — SQL Injection in /search
  - Affected: webapp.example.com
  - CVSS: 8.2 (example)
  - Summary: Unsanitized user input in `q` parameter used in a SQL statement.
  - Impact: Data exfiltration from user table.
  - Remediation: Use parameterized queries, input validation, and logging.

- FIND-002 (Medium) — Reflected XSS in /comments
  - Affected: webapp.example.com
  - Summary: Comment content is reflected without encoding.
  - Remediation: Output encode user content and apply CSP.

Risk Matrix
- High: 1
- Medium: 1
- Low: 2

Recommended Next Steps
- Patch SQLi within 7 days and re-test.
- Implement output encoding and stronger input validation.
- Harden server headers and review monitoring rules.

Appendix
- Tools used: nmap, Burp Suite, sqlmap (authorized usage)
- Note: This sample is redacted and for demonstration only.
```