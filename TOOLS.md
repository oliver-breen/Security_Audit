```markdown
# Audit Tooling — Overview & Usage

These helper scripts automate common audit tasks and produce structured output you can use when writing reports. They are designed to be safe by default and require explicit confirmation before running intrusive tests.

Files:
- recon.sh — passive + light active reconnaissance (subdomains, ports)
- scan.sh — targeted scanning workflows (nmap, web discovery, optional intrusions)
- deps_scan.sh — dependency & container scanning (trivy, snyk)
- static_analysis.sh — static code checks (bandit for Python)
- report_generator.py — convert findings JSON into a markdown audit report
- Makefile — convenient task runner

Safety & Authorization
- Always have written authorization for any active testing.
- Intrusive tests (sqlmap, aggressive fuzzing, exploitation) are disabled unless you pass --authorized on the command line.
- Check the scripts before running and run them in an isolated environment when practicing.

Example usage
- Make sure scripts are executable:
  chmod +x recon.sh scan.sh deps_scan.sh static_analysis.sh
- Run a passive/light recon on example.com:
  ./recon.sh example.com
- Run a full scan with explicit authorization:
  ./scan.sh --authorized example.com
- Run static analysis on the local repo:
  ./static_analysis.sh
- Generate a report from findings/*.json:
  python3 report_generator.py --input findings/ --output REPORT.md

Output layout (created by tools)
- recon/ — raw reconnaissance outputs (subdomains.txt, nmap/)
- scans/ — scanner outputs (nmap.xml, nikto.txt, dirb/)
- findings/ — normalized JSON findings for report_generator.py
- REPORT.md — generated audit markdown (when using report_generator.py)
```