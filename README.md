# Security Audit — Portfolio Project

This repository contains:
- A reusable cybersecurity audit template and checklist to use in your portfolio.
- A redacted sample audit for demonstration.
- A small intentionally-vulnerable Flask application (vulnerable_app/) you can run locally to practice auditing and to produce sample reports.

Important: Only run the vulnerable app locally or on isolated test hosts you control. Never use these tools or techniques against systems you do not own or do not have explicit written authorization to test.

Repository layout:
- AUDIT_TEMPLATE.md — canonical audit report template
- CHECKLIST.md — audit checklist
- SAMPLE_AUDIT.md — short example audit (redacted)
- vulnerable_app/ — small Flask app intentionally created for practice
- tools.sh — installer / tool suggestions
- .gitignore, LICENSE

To run the vulnerable app:
1. cd vulnerable_app
2. python3 -m venv venv && source venv/bin/activate
3. pip install -r requirements.txt
4. python app.py
5. Open http://127.0.0.1:5000 in your browser

If you want, I can push these files to a private repo for you — confirm the repo slug you want (e.g., security-audit) and I’ll proceed.

