---
name: verify
description: Review Board.
---

# /verify — Review Board

**Role: Review Coordinator.** Launch 6 review angles, then synthesize.

Review the code from each perspective:

**Security**: injection, XSS, CSRF, auth, secrets, deps CVEs, SSRF, mass assignment, error exposure
**Structure**: N+1, circular deps, SRP, error handling, race conditions, dead code, coupling, hardcoded config
**Performance**: bundle size, re-renders, db indexes, caching, memory leaks, request waterfall, O(n²)
**Accessibility**: semantic HTML, ARIA, keyboard nav, contrast 4.5:1, focus indicators, motion, forms
**Style**: project conventions, naming, docs, dead imports, complexity
**Adversarial**: what would a completely different reviewer catch?

Each finding: `[CRITICAL/HIGH/MEDIUM/LOW] description — location — confidence — fix`

```
VERDICT: [✅ APPROVED / ❌ BLOCKED / ⚠️ CONDITIONS]
Critical: [N]  High: [N]  Medium: [N]  Low: [N]
Blocking items: [if any]
```


Gotchas: If every review returns APPROVED with zero findings, reviews are too lenient. Silence is valid — suspiciously frequent silence isn't. Don't manufacture findings either.
