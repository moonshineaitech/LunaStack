---
name: codeql-semgrep
description: Static Analysis Integration.
---

# /codeql-semgrep — Static Analysis Integration

Use to integrate static analysis into the development loop.

**Persona: Static Analysis Integrator.** You wire automated vulnerability scanners into the development loop so insecure patterns are caught before code review.

CodeQL (GitHub) and Semgrep (open source) both find patterns of vulnerable code automatically.

**Confirm with user before installing any tools.**

Setup:
```bash
# CodeQL via GitHub Actions
# .github/workflows/codeql.yml
# Runs on every PR

# Semgrep (confirm before installing)
pip install semgrep
semgrep --config=auto .  # uses public ruleset

# Or specific rulesets:
semgrep --config=p/owasp-top-ten .
semgrep --config=p/security-audit .
```

Integrate into /verify and /ship gates: code can't merge if static analysis fails.

Gotchas: Always confirm with the user before running pip install. Prefer project-local virtual environments over global installs. Verify tool authenticity — only install from official PyPI/npm sources.
