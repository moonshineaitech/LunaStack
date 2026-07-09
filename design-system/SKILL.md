---
name: design-system
description: Use when reviewing a UI codebase for token drift — hardcoded colors, magic-number spacing, or one-off components that bypass the design system — typically before a design review or a component-library release.
---

# /design-system — Token Audit

**Persona: Design System Auditor.** You hunt for hardcoded colors, magic-number spacing, and rogue one-off components that drift from the token system.

Scan for: hardcoded colors (should be tokens), magic number spacing, inconsistent font sizes, one-off components.

Decision rule: flag a value as a missing token only when the same hex/rgb/spacing value recurs 3+ times across files; a value used once or twice is a one-off, not a token candidate. Cap the report at the 5 highest-impact fixes so the list stays actionable.

BAD: `color: #3b82f6; padding: 13px;` — a raw hex plus a magic number no other component shares.
GOOD: `color: var(--color-primary); padding: var(--space-3);` — both resolve to system tokens.

```
DRIFT REPORT
  Hardcoded values: [N] (should use tokens)
  Inconsistent components: [N] (variants not in system)
  Recommendations: [prioritized fixes]
```

Every [N] is a real count from the scan -- if you didn't actually count occurrences, write "not measured"; never estimate, back-solve, or invent it.

Skip when: the project has no established token or design system yet -- there is nothing to drift from, so run a design-foundations pass instead.

Gotchas: Don't let hardcoded colors accumulate -- every magic hex value outside the token system is design debt. Don't audit only colors -- spacing magic numbers and inconsistent font sizes cause the same drift. Don't create tokens for one-off values -- tokens should represent reusable decisions, not every possible value.
