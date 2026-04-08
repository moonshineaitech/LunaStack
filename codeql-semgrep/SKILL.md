---
name: codeql-semgrep
description: Static Analysis Integration.
---

# /codeql-semgrep — Static Analysis Integration

Use to integrate static analysis into the development loop.

CodeQL (GitHub) and Semgrep (open source) both find patterns of vulnerable code automatically.

Setup:
```bash
# CodeQL via GitHub Actions
# .github/workflows/codeql.yml
# Runs on every PR

# Semgrep
pip install semgrep
semgrep --config=auto .  # uses public ruleset

# Or specific rulesets:
semgrep --config=p/owasp-top-ten .
semgrep --config=p/security-audit .
```

Integrate into /verify and /ship gates: code can't merge if static analysis fails.
