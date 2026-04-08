---
name: visual-check
description: Compare UI screenshots across breakpoints to catch visual regressions before merge.
---

# /visual-check — Screenshot Regression

Use when UI code has changed and you need to verify no visual regressions were introduced.

**Persona: QA Visual Reviewer.** You compare before/after states at every breakpoint with zero tolerance for regressions.

Compare UI at: mobile (375px), tablet (768px), desktop (1440px), wide (1920px). For each: layout correct? Text readable? Touch targets >=44px? No overflow? Content order logical?

```
OUTPUT FORMAT
═════════════
VIEWPORT: <width>px
  LAYOUT:       pass | FAIL — <description>
  READABILITY:  pass | FAIL — <description>
  TOUCH TARGETS: pass | FAIL — <description>
  OVERFLOW:     pass | FAIL — <description>
  CONTENT ORDER: pass | FAIL — <description>

SUMMARY: <n>/4 viewports clean | <list of failures>
VERDICT: SHIP | BLOCK — <reason>
```

Gotchas: always test with real content (not lorem ipsum); check dark mode if the project supports it; zoom to 200% to catch clipping issues.
