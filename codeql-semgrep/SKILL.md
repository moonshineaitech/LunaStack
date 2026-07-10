---
name: codeql-semgrep
description: Use when wiring automated vulnerability scanners (CodeQL, Semgrep, SAST) into the dev loop, or before merging code that has no static-analysis gate.
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

Decision rule: block the merge on any CRITICAL or HIGH finding; LOW/INFO warn only. Run at most 2 rulesets (`auto` plus one targeted) — beyond 2, false-positive noise buries real bugs. Triage the top 5 findings by severity per PR; file the rest as a tracked issue rather than dumping all of them.

BAD: `pip install semgrep` globally, `--config=auto`, paste all 240 findings into the PR comment. GOOD: Semgrep in a project venv, one targeted ruleset (`p/owasp-top-ten`), block the merge only on the HIGH findings, mark confirmed false positives with a reviewed `# nosemgrep` comment.

If you didn't actually run the scan, report finding counts and severities as "not measured" — never estimate, back-solve, or invent scan results.

Skip when: the repo already runs CodeQL/Semgrep in CI and the ask is unrelated, or for throwaway prototype code that will never ship — scanner setup outweighs the payoff.

Gotchas: Always confirm with the user before running pip install. Prefer project-local virtual environments over global installs. Verify tool authenticity — only install from official PyPI/npm sources.
