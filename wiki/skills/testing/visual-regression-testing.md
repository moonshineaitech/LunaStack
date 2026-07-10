---
name: visual-regression-testing
description: Use when UI changes keep shipping unintended visual breakage, or before a CSS refactor/design-system migration. Establishes screenshot-diff testing (Playwright snapshots, Chromatic, Percy, Lost Pixel class) with flake sources neutralized, tuned thresholds, component-level granularity, and a baseline-review workflow. Produces a stable visual test suite and an approval process the team actually follows.
---

# /visual-regression-testing — Screenshot Diffs Without the Flake Tax

Use to catch unintended visual changes via screenshot diffing that stays stable enough for the team to trust red builds.

**Persona: Visual QA Infrastructure Engineer.** Locks down every source of rendering nondeterminism before writing a single assertion, and designs the baseline-approval workflow as carefully as the tests. Does NOT screenshot full pages by default, and does not paper over flake by cranking thresholds until real regressions pass.

Flake kills visual testing faster than missing coverage, so eliminate nondeterminism at the source before tuning any threshold: pin the **rendering environment** (one browser build, one OS, one device-pixel-ratio — Docker or a cloud renderer like Chromatic/Percy, never "whatever CI has today"); bundle and preload fonts locally (system-font fallback is the #1 diff source); freeze time and randomness; disable animations globally (Playwright's `toHaveScreenshot` does this via `animations: 'disabled'`, plus `prefers-reduced-motion` CSS); mask or stub dynamic regions (avatars, timestamps, ads) rather than excluding whole components. Prefer **component-level snapshots** (Storybook stories via Chromatic/Lost Pixel, or Playwright component testing) over full-page: a full-page diff turns one header change into 40 red screenshots, while component snapshots localize blame and run in parallel. Set thresholds to absorb only anti-aliasing noise — `maxDiffPixelRatio` around 0.01 (~1%) or a small `maxDiffPixels` (commonly ≤100 for component shots) with perceptual comparison (SSIM/YIQ à la pixelmatch/odiff), never 5-10% "to make it green." Treat baselines like code: updates ship in the same PR as the change, reviewed as images in the diff UI, approved by someone who knows the design intent — auto-accepting baselines on main silently ratchets in every regression. Rule: **If a visual test flakes twice in a week, fix the nondeterminism source or delete the test — never raise the threshold to quiet it.**

BAD: "Full-page screenshots of 30 routes at 10% threshold, baselines auto-updated nightly" (10% hides real regressions, full-page couples everything, and auto-update means the suite approves its own bugs). GOOD: "Component snapshots per Storybook story at ~1% diff ratio, fonts bundled, animations disabled, baseline changes reviewed as images inside the feature PR."

```
VISUAL REGRESSION SETUP
══════════════════════════════════════════
RENDERER: [tool + browser build + DPR] · GRANULARITY: [component/page mix]
DETERMINISM: fonts [bundled?] · animations [disabled?] · clock [frozen?] · dynamic regions [masked list]
THRESHOLD: [maxDiffPixelRatio/pixels] · COMPARATOR: [pixelmatch/odiff/SSIM]
BASELINE FLOW: [who approves · where reviewed · update-with-PR? y/n]
FLAKE LOG: [test → root cause → fix, not threshold bump]
```

Skip when: the UI is churning daily pre-product-market-fit (baselines become pure friction), or a design system's tokens + unit tests already pin the styling surface you'd screenshot.

Gotchas: running baselines on macOS locally but Linux in CI guarantees permanent font/AA drift — generate baselines only in the CI environment; snapshotting during in-flight lazy-loads or skeleton states produces coin-flip diffs, so wait for network-idle plus explicit content assertions first; masking too much (whole hero, whole table) leaves a test that can't fail; and a 2000-screenshot suite nobody reviews is worse than 60 curated component shots someone actually looks at.
