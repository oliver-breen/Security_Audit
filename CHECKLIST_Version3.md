```markdown
# Audit Checklist

Pre-engagement
- [ ] Confirm written authorization and scope
- [ ] Sign NDA if required
- [ ] Gather contacts and schedule

Reconnaissance
- [ ] Passive OSINT
- [ ] DNS & subdomain enumeration
- [ ] Port/service discovery (nmap)
- [ ] Web mapping/crawling (if applicable)

Automated Scanning
- [ ] Unauthenticated vulnerability scan
- [ ] Authenticated vulnerability scan (if credentials provided)
- [ ] Static code analysis (if repo available)
- [ ] Dependency scanning (SCA)

Manual Testing
- [ ] Auth / authorization testing
- [ ] Input validation (XSS, SQLi, command injection)
- [ ] Business logic testing
- [ ] Session/CSRF testing
- [ ] File upload checks
- [ ] API testing (rate limits, auth, parameter handling)

Post-exploitation (only if authorized)
- [ ] Privilege escalation
- [ ] Lateral movement
- [ ] Data access/exfiltration analysis (redacted in public reports)

Reporting
- [ ] Triage/verify findings
- [ ] Assign severity and remediation guidance
- [ ] Draft executive summary
- [ ] Produce final report and an executive one-pager

Remediation Verification
- [ ] Re-test fixes
- [ ] Recommend CI/infra checks to prevent recurrence

Ethics & Safety
- [ ] Ensure tests follow law and authorization
- [ ] Do not perform destructive testing unless authorized
- [ ] Keep record of authorization on file
```