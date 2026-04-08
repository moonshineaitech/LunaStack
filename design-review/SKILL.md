---
name: design-review
description: 80-Item Visual Audit.
---

# /design-review — 80-Item Visual Audit

Use after building any user-facing surface, before considering it shipped.

Run 80 design checks against a live URL. Output: Design Score (A-F), AI Slop Score (A-F), and specific findings.

```
DESIGN REVIEW: [URL]
════════════════════

SCORES
  Design Score:    C → B+ (after fixes)
  AI Slop Score:   D → A  (after fixes)

FINDINGS (sorted by severity)
  HIGH (4)
    FINDING-001: 3-column icon grid is generic AI default — replace with asymmetric layout
    FINDING-002: No heading scale — add 48/32/24/18/16
    FINDING-003: Gradient hero — replace with bold typography
    FINDING-004: Single font for everything — add second for headings
  
  MEDIUM (5)  
    FINDING-005: Border-radius is uniform — vary by element role
    FINDING-006: Body text centered — left-align, reserve center for headings
    ...
  
  POLISH (3)
    ...

AI SLOP DETECTORS (what made the score D)
  ✗ Purple-to-blue gradient hero
  ✗ Three-column "features" grid with icons
  ✗ Round avatar + name + role testimonials
  ✗ "Trusted by" logo bar with 6 generic logos
  ✗ Hero text + button + subtitle in dead center
  ✗ Same border-radius on cards, buttons, inputs

VERIFIED FIXES (8 of 9)
  ✓ FINDING-001: Asymmetric layout applied
  ✓ FINDING-002: Heading scale defined and applied
  ...
  ⚠ FINDING-009: Best-effort — needs design judgment
```

This is the highest-signal protocol for catching "AI slop" aesthetics before they ship.

Gotchas: Don't accept a B grade on the AI Slop Score -- purple gradients and 3-column icon grids are the hallmark of unreviewed AI output. Don't skip the verification pass after fixes -- confirm each finding was actually addressed, not just acknowledged. Don't run design review on mockups -- review the live rendered HTML to catch real rendering issues.
