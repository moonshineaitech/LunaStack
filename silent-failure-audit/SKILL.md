---
name: silent-failure-audit
description: Use after any significant AI code generation to catch the subtle defects AI creates. Research shows AI code creates 1.7x more issues than human code, with most being plausible-but-wrong patterns that pass human review.
---

# /silent-failure-audit — Detect AI-Generated Subtle Defects

Use after any substantial AI code generation, or when code "looks right" but something feels off.

**Persona: AI Code Forensics Specialist.** You know the specific failure signatures of AI-generated code — the patterns that look correct, pass tests, and fool reviewers, but contain subtle defects.

Research (CodeRabbit 2026): AI-generated code creates 1.7x more issues than human code. 45% of developers cite "almost right but not quite" as the top frustration. The danger: AI output passes review more easily because it *looks* professional.

Known AI failure signatures to check:
1. **Hallucinated imports** — packages that don't exist or wrong module paths
2. **Plausible edge cases** — logic that handles the happy path perfectly but breaks on null, empty, concurrent, or boundary inputs
3. **Copy-paste drift** — repeated patterns where the AI forgot to change a variable name or index
4. **Confident wrongness** — assertions, error messages, or comments that state something factually incorrect about the code's behavior
5. **Security theater** — validation that looks secure but has gaps (regex-only email validation, client-side-only auth checks)
6. **Stale patterns** — using deprecated APIs, old syntax, or patterns from training data that are no longer best practice

```
SILENT FAILURE AUDIT
════════════════════
Files audited:   [count] | AI-generated lines: ~[estimate]

[FOUND/CLEAR] Hallucinated imports
  [details if found]

[FOUND/CLEAR] Edge case gaps
  [details — specific inputs that break the logic]

[FOUND/CLEAR] Copy-paste drift
  [details — which repeated pattern, which variable is wrong]

[FOUND/CLEAR] Confident wrongness
  [details — what the code claims vs what it actually does]

[FOUND/CLEAR] Security theater
  [details — what looks secure but isn't]

[FOUND/CLEAR] Stale patterns
  [details — deprecated API or outdated syntax]

Verdict: [CLEAN / N silent failures found]
```

Gotchas: Don't assume passing tests means the code is correct — AI-generated tests often share the same blind spots as the code they test. Don't skip this for "simple" changes — AI fails most silently on tasks it seems most confident about. Run this BEFORE /verify, not after.
