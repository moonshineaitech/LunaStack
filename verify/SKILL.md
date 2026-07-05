---
name: verify
description: Use before merging or shipping any non-trivial change. Multi-angle review board over the diff and its blast radius, with an explicit blocking verdict.
---

# /verify — Review Board

**Role: Review Coordinator.** Launch 6 review angles, then synthesize.

Scope first: read the FULL diff before any angle runs. Review changed code plus its blast radius (every caller of a changed function, every consumer of a changed type) — nothing else. Diffs over 400 lines: review in 2 passes (pass 1: security + structure; pass 2: the rest) so late files get the same attention as early ones.

Angle applicability — skip angles that cannot apply, and say so:
- Backend-only diff → skip Accessibility
- Docs/config-only diff → Security + Style only
- Everything else → all 6

**Security**: injection, XSS, CSRF, auth, secrets, deps CVEs, SSRF, mass assignment, error exposure
**Structure**: N+1, circular deps, SRP, error handling, race conditions, dead code, coupling, hardcoded config
**Performance**: bundle size, re-renders, db indexes, caching, memory leaks, request waterfall, O(n²)
**Accessibility**: semantic HTML, ARIA, keyboard nav, contrast 4.5:1, focus indicators, motion, forms
**Style**: project conventions, naming, docs, dead imports, complexity
**Adversarial**: what would a completely different reviewer catch?

Each finding: `[CRITICAL/HIGH/MEDIUM/LOW] description — location — confidence — fix`
Confidence = how sure the issue is REAL (90% = near-certain; 60% = plausible, verify before acting). It is not severity.

Blocking policy: CRITICAL always blocks. HIGH blocks unless the user explicitly accepts it in this session. MEDIUM/LOW are advisory — list them, don't block on them.

BAD finding: "Error handling could be improved in the auth module." (no location, no severity basis, not actionable)
GOOD finding: "[HIGH] refresh token compared with == instead of constant-time compare — auth/refresh.ts:41 — 85% — use crypto.timingSafeEqual."

```
VERDICT: [✅ APPROVED / ❌ BLOCKED / ⚠️ CONDITIONS]
Critical: [N]  High: [N]  Medium: [N]  Low: [N]
Blocking items: [if any]
```

Skip when: the diff is pure formatting/rename with tests green, or generated files only (LunaStack.md, lockfiles) — verify the generator instead.

Gotchas: If every review returns APPROVED with zero findings, reviews are too lenient. Silence is valid — suspiciously frequent silence isn't. Don't manufacture findings either.
