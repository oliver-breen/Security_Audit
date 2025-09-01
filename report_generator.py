#!/usr/bin/env python3
# Simple report generator: combine findings JSON files into a markdown report
# Usage: python3 report_generator.py --input findings/ --output REPORT.md
import argparse
import json
from pathlib import Path
from datetime import date

TEMPLATE = """# Audit Report — Generated

Date: {date}

## Executive Summary
- Findings summary generated from scanner outputs.

## Findings
{findings_section}

## Appendix
- Raw findings files: listed in findings/ directory.
"""

FINDING_BLOCK = """
### {id} — {title}
- Severity: {severity}
- Affected: {affected}
- Summary: {summary}
- Evidence (sanitized): `{evidence}`
- Remediation: {remediation}
"""

def normalize_finding(obj, idx):
    return {
        "id": obj.get("id", f"F{idx:03d}"),
        "title": obj.get("title", obj.get("summary", "Unnamed finding")),
        "severity": obj.get("severity", "info"),
        "affected": obj.get("affected", "unknown"),
        "summary": obj.get("summary", ""),
        "evidence": obj.get("evidence", "")[:300],  # truncate
        "remediation": obj.get("remediation", "See remediation guidance.")
    }

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", "-i", default="findings", help="Directory with findings JSON files")
    p.add_argument("--output", "-o", default="REPORT.md")
    args = p.parse_args()

    input_dir = Path(args.input)
    findings = []
    if not input_dir.exists():
        print(f"[!] Input directory {input_dir} does not exist.")
        return

    for file in sorted(input_dir.glob("*.json")):
        try:
            data = json.load(file.open())
            if isinstance(data, list):
                for idx, item in enumerate(data, start=1):
                    findings.append(normalize_finding(item, idx))
            elif isinstance(data, dict):
                findings.append(normalize_finding(data, len(findings)+1))
            else:
                print(f"[!] Skipping {file} (unexpected format)")
        except Exception as e:
            print(f"[!] Failed to parse {file}: {e}")

    findings_md = ""
    for f in findings:
        findings_md += FINDING_BLOCK.format(**f)

    report = TEMPLATE.format(date=date.today().isoformat(), findings_section=findings_md or "No findings found.")
    Path(args.output).write_text(report)
    print(f"[+] Report written to {args.output}")

if __name__ == "__main__":
    main()