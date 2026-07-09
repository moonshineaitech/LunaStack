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

Decision rule: any single FAIL at any of the 4 breakpoints = BLOCK — one broken viewport ships a broken experience to that whole device class; touch targets under 44px and horizontal overflow are automatic FAILs, not judgment calls.

BAD finding: "Mobile looks a bit cramped." (which element? which breakpoint? pass or fail?)
GOOD finding: "375px LAYOUT FAIL — the pricing table overflows 40px past the viewport; horizontal scroll appears. BLOCK."

If you did not actually render and view a viewport, mark it "not checked" — never assume a breakpoint passed, describe a screenshot you didn't capture, or infer layout from the code alone.

Skip when: the change is backend-only, copy-only, or touches no rendered layout — there's nothing visual to regress.

Gotchas: always test with real content (not lorem ipsum); check dark mode if the project supports it; zoom to 200% to catch clipping issues.
