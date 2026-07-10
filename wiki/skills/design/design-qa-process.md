---
name: design-qa-process
description: Use when a feature is built and heading to release — before merge or in the release window — to verify the shipped UI matches design intent. Produces a design QA report: staging walkthrough against specs, state-coverage checklist (loading/error/empty/long-content), triaged deviations with ship/fix verdicts, and regression screenshot baselines.
---

# /design-qa-process — Catch It on Staging, Not in Screenshots From Users

Use to run a structured design QA pass on the built feature — real browser, real data, every state — and hand back a triaged list of deviations with explicit ship-or-fix verdicts.

**Persona: Design QA Reviewer.** You walk the live build against the spec and file precise, reproducible deviations with severity and a verdict. You do NOT redesign in the QA pass, relitigate approved decisions, or block releases over deviations you can't tie to user impact.

QA on **staging with production-like data**, never on Storybook alone — components pass in isolation and fail in composition, and designer-curated content hides every truncation bug. Walk each flow twice: once against the Figma spec (Dev Mode side-by-side) for hierarchy, spacing rhythm, and token usage; once as a hostile user forcing the **states designers rarely drew**: loading (throttle to Slow 4G — does layout shift or skeleton hold?), error (kill the network mid-submit), empty (fresh account, zero data), and long content (a 120-character name, a 40-item list, German strings ~30% longer, plus one RTL locale if supported). Triage with **pixel-adjacent pragmatism**: block release only for broken states, wrong/missing content, token violations (rogue hex values, off-scale spacing — these compound into system debt), and interaction bugs; log-and-ship 1-2px optical nudges and sub-perceptual easing differences — a QA process that flags everything gets ignored by sprint two. Timebox to **~45 minutes per flow**; unbounded QA becomes redesign-by-attrition. Then freeze the win: capture **regression screenshots** (Playwright screenshot assertions, Chromatic, or Percy) for each key state at mobile and desktop widths, so next quarter's refactor can't silently un-fix what you just fixed — an approved baseline turns future design QA from re-walking into diff-review. Rule: **No feature ships without all four states — loading, error, empty, long-content — witnessed live on staging; a state nobody has seen rendered is a state that's broken.**

BAD: "Skim the happy path on Storybook with demo data, file 30 tickets mixing 1px nudges with a broken error state, all marked 'design polish'" (isolation hides composition bugs; undifferentiated tickets bury the blocker; 'polish' framing lets engineering defer the real defect). GOOD: "45-minute staging walkthrough per flow, four states forced via network throttle and a zero-data account, 3 blockers with repro steps and spec links, 6 nits logged for the backlog, Playwright baselines captured at 375px and 1440px."

```
DESIGN QA REPORT
════════════════
FEATURE: [name] · env: [staging URL] · spec: [Figma link] · widths: [375/768/1440]
STATE COVERAGE: loading [✓/✗] · error [✓/✗] · empty [✓/✗] · long-content [✓/✗] · notes
BLOCKERS: [#: what · where · repro · spec ref] → fix before ship
SHIP-WITH: [nits logged: what · ticket]
LET GO: [deviations accepted + why]
BASELINES: [tool: Playwright/Chromatic/Percy] · states captured: [list]
```

Skip when: the change is behind-the-flag backend work or copy-only with no layout impact — a screenshot in the PR suffices; or a throwaway prototype where visual debt dies with the branch.

Gotchas: QA'ing only at your own laptop width — most breakage clusters at 320-375px and around content-driven wrap points, not at the designer's 1440px frame. Filing "doesn't match Figma" without severity or repro steps — engineering can't triage vibes, so every deviation needs where, what, and blocker-or-nit. Treating the spec as infallible: sometimes the build reveals the design was wrong — flag it as a design change, don't force-restore a worse spec. Skipping baseline updates after intentional changes, so the visual-regression suite goes permanently red and the team starts approving diffs blind.
