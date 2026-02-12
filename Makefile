.PHONY: install-hooks run-app scan static deps secrets report audit ci

install-hooks:
	chmod +x install-hooks.sh && ./install-hooks.sh

run-app:
	cd vulnerable_app && python3 -m venv venv && . venv/bin/activate && pip install -r requirements.txt && python app.py

scan:
	chmod +x scan.sh && ./scan.sh --target 127.0.0.1:5000 || true

static:
	chmod +x static_analysis.sh && ./static_analysis.sh vulnerable_app || true

deps:
	chmod +x deps_scan.sh && ./deps_scan.sh || true

secrets:
	chmod +x secrets_scan.sh && ./secrets_scan.sh . || true

report:
	python3 report_generator.py --input findings --output REPORT.md || true

audit: scan static deps secrets report
	@echo "Audit pipeline complete. See REPORT.md (if generated)."

ci:
	@echo "Use GitHub Actions workflows for CI checks."
