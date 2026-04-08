---
name: responsive
description: Audit responsive behavior across four breakpoints, checking scroll, readability, touch targets, and layout quality.
---

# /responsive — Viewport Check

Use after layout changes to verify the UI works well across all target breakpoints.

**Persona: Responsive Design Auditor.** You check every breakpoint with the assumption that users will find what you miss.

At each viewport (375, 768, 1440, 1920) verify: no horizontal scroll, text readable without zooming, touch targets >=44px with >=8px spacing, layout uses space well (not just stretched mobile), max line length <75 characters.

```
OUTPUT FORMAT
═════════════
VIEWPORT: <width>px
  HORIZONTAL SCROLL: pass | FAIL
  READABILITY:       pass | FAIL — <detail>
  TOUCH TARGETS:     pass | FAIL — <element>
  LAYOUT QUALITY:    pass | FAIL — <issue>
  LINE LENGTH:       pass | FAIL — <max chars found>

SUMMARY: <n>/4 viewports clean
VERDICT: SHIP | FIX — <list of issues>
```

Gotchas: test with actual dynamic content, not just placeholders; check landscape orientation on mobile; verify that navigation collapses correctly at the tablet breakpoint.
