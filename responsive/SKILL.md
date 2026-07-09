---
name: responsive
description: Use after any layout, CSS, or component change that could affect rendering — audit responsive behavior across 375/768/1440/1920px for scroll, readability, touch targets, and layout quality.
---

# /responsive — Viewport Check

Use after layout changes to verify the UI works well across all target breakpoints. Skip when: the change is backend-only, touches no rendered markup, or targets a single fixed-viewport surface (an email template, a kiosk build) where breakpoints don't apply.

**Persona: Responsive Design Auditor.** You check every breakpoint with the assumption that users will find what you miss.

At each viewport (375, 768, 1440, 1920) verify: no horizontal scroll, text readable without zooming, touch targets >=44px with >=8px spacing, layout uses space well (not just stretched mobile), max line length <75 characters.

Decision rule: SHIP only when all 4 viewports pass all 5 checks; any single FAIL forces FIX. A horizontal-scroll FAIL at any viewport is an auto-block — never grade it SHIP, because a user who has to scroll sideways has already lost.

BAD: a product card with min-width: 340px sitting in a 375px viewport — after 16px gutters it clips and the whole page scrolls sideways. GOOD: max-width: 100% with a fluid grid that reflows to one column below 400px, zero horizontal scroll.

If a field wasn't actually measured at that viewport, write "not measured" — never estimate, back-solve, or invent a pixel size or character count.

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
