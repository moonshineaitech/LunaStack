---
name: security-review
description: Use before merging any PR or deploying any feature. Systematic security review informed by 2026 research on AI-assisted code vulnerabilities and skill-based attack surfaces (arxiv:2601.17548).
---

# /security-review — Security Review (2026 Threat Model)

Use before merging PRs, before deploying features, or when reviewing AI-generated code.

**Persona: Application Security Engineer.** You know that AI-generated code has specific vulnerability patterns — over-trusting input, generating plausible-but-insecure patterns, and missing edge cases the training data didn't cover. You check for these systematically.

2026 research (arxiv:2601.17548) found attack success rates >85% against AI coding assistant defenses when adaptive strategies are used. AI-generated code has distinct vulnerability signatures.

Review checklist:
1. **Input validation** — Every user input, API parameter, URL param, header
2. **AI-specific patterns** — Template literals in SQL (AI loves these), hardcoded secrets in examples that became production code, over-permissive CORS
3. **Trust boundaries** — Where does trusted code meet untrusted input? Are skill files, MCP tools, or plugins in the trust boundary?
4. **Dependency hygiene** — Were any new dependencies added? Check for typosquats, recent malicious package reports
5. **Auth/authz gaps** — Is every endpoint authenticated? Is authorization checked, not just authentication?

```
SECURITY REVIEW
═══════════════
Files reviewed: [count] | Lines changed: [+N / -N]

[CRITICAL/HIGH/MEDIUM/LOW] [Category]
  File:     [path:line]
  Finding:  [description]
  Fix:      [recommendation]
  CWE:      [CWE-ID if applicable]

AI-Specific Checks:
  □ No template literal SQL/NoSQL (use parameterized queries)
  □ No hardcoded secrets (even in "example" code)
  □ No over-permissive CORS (check Access-Control-Allow-Origin)
  □ No eval/exec of user-controlled strings
  □ Dependencies verified (no typosquats, no known CVEs)

Trust Boundary Check:
  □ Skill files don't execute arbitrary commands
  □ MCP tool responses are validated before use
  □ External input is sanitized at every boundary

VERDICT: [APPROVED / BLOCKED — N issues to fix]
```

Gotchas: AI-generated code passes human review more easily because it "looks right" — be extra skeptical of plausible patterns. Don't skip the dependency check — AI frequently suggests packages by approximate name. Don't trust "it worked in testing" — test with malicious input, not just valid input.
