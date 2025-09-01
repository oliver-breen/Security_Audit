```markdown
# Vulnerable App — For Audit Practice

This small Flask app is intentionally insecure so you can practice discovery and exploitation techniques in a safe, local environment.

How to run:
1. cd vulnerable_app
2. python3 -m venv venv
3. source venv/bin/activate
4. pip install -r requirements.txt
5. python vulnerable_app.py
6. Visit http://127.0.0.1:5000

Notes:
- The /search endpoint demonstrates an SQL injection via string interpolation.
- The /comments endpoint demonstrates reflected XSS by rendering user input unescaped.
- The /headers endpoint demonstrates verbose header disclosure.
- Do not run this on public infrastructure. Use only on localhost or isolated lab VMs.
```