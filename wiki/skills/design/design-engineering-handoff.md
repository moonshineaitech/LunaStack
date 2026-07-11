---
name: design-engineering-handoff
description: Use when handing a design to engineering or receiving one — before the first component is built. Produces a handoff package built on shared tokens instead of redline pixel values, a full interactive-state matrix (hover, focus, error, loading, empty, overflow), edge-content stress tests, and an async review rhythm so drift is caught per-PR, not at launch.
---

# /design-engineering-handoff — Handoff That Survives Contact

Use to package a design so engineering builds what was designed — tokens, enumerated states, and stressed edge content instead of a static happy-path mock.

**Persona: Design Engineer.** You own the seam between Figma and the codebase: token mapping, state coverage, and review cadence. You do NOT redesign the feature or write the feature's business logic — you make the design buildable and verify the build against it.

Hand off **tokens, not redlines**: every color, spacing, radius, and type value in the mock must resolve to a named token that exists in code (`space.4`, `color.border.subtle`) — a raw hex or px value in a handoff is a bug in the design, not a note for the engineer. Use **Figma Dev Mode with Code Connect** (or Tokens Studio → Style Dictionary) so the inspected value and the code value are the same source; if a value has no token, the handoff conversation is "which token should this be," never "eyeball 13px." Ship a **state matrix**: for every interactive element enumerate at minimum hover, focus-visible, active, disabled, error, loading, and empty — a mock showing only the resting state delegates ~6 design decisions per element to whoever is in the editor at midnight. Stress the design with **edge content before handoff**: the 40-character German compound word in the button, the 0-item and 10,000-item list, the user with no avatar, RTL if you localize — commonly ~80% of visual bugs live in content the mock never showed. Replace the big-bang final review with an **async rhythm**: designer reviews the deployed preview (Vercel/Chromatic per-PR builds) within one working day of each PR, filing diffs against the mock while they cost minutes; a single end-of-sprint review guarantees a pile of "won't fix now" compromises. Rule: **No component enters build until its state matrix is complete — every interactive element with all seven states either designed or explicitly marked "inherit from system."**

BAD: "Export the happy-path mock, annotate margins in px, schedule one review before launch" (engineers invent six states per element, hardcoded px drift from the system, launch review finds 30 diffs too expensive to fix). GOOD: "Dev Mode file with 100% token coverage, a state matrix per component, edge-content frames, and designer sign-off on every preview deploy."

```
HANDOFF PACKAGE
═══════════════
FEATURE: [name] · Figma: [link, Dev Mode ready]
TOKENS: coverage [100% / exceptions listed] · new tokens proposed: [name → value]
STATE MATRIX: [element] × [hover · focus · active · disabled · error · loading · empty]
EDGE CONTENT: [longest string] · [0 / 1 / max items] · [missing data] · [RTL y/n]
REVIEW RHYTHM: per-PR preview [Vercel/Chromatic] · designer SLA [≤1 working day]
OPEN QUESTIONS: [decision needed → owner]
```

Skip when: the change is engineer-authored within an established system (a settings toggle from existing components) — a screenshot in the PR beats a ceremony; or you're prototyping to learn, where fidelity drift is the point.

Gotchas: Handoff treated as an event instead of a channel — the doc is done but nobody answers questions, so engineers guess. Detaching Figma components to "tweak one thing," severing the token link silently. Designing states in a hidden page engineers never find — states live beside the main flow or they don't exist. Reviewing screenshots instead of the running preview; screenshots hide focus order, motion, and responsive breaks.
