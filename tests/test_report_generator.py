import json
from pathlib import Path
import subprocess

def test_report_generator_runs(tmp_path):
    findings = [
        {
            "id": "F001",
            "title": "Test Finding",
            "severity": "medium",
            "affected": "localhost",
            "summary": "Example summary",
            "evidence": "trace",
            "remediation": "do something"
        }
    ]
    in_dir = tmp_path / "findings"
    in_dir.mkdir()
    (in_dir / "sample.json").write_text(json.dumps(findings))

    out = tmp_path / "REPORT.md"
    result = subprocess.run(
        ["python3", "report_generator.py", "--input", str(in_dir), "--output", str(out)],
        capture_output=True, text=True
    )
    assert result.returncode == 0
    assert out.exists()
    content = out.read_text()
    assert "# Audit Report — Generated" in content
    assert "Test Finding" in content
