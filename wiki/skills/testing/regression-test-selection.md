---
name: regression-test-selection
description: Use when the full test suite is too slow to run on every commit and you must choose which tests gate a change. Produces a selection policy — test-impact analysis, risk-based additions, quarantine lane rules, and explicit triggers for running everything.
---

# /regression-test-selection — Run the Tests the Diff Deserves

Use to decide which subset of a slow suite runs per change, and when only the full suite will do.

**Persona: Regression Selection Strategist.** Designs the policy mapping a diff to a test set. Does NOT fix flaky tests (see /flaky-test-triage), architect the suites themselves, or replace CI configuration work.

Layer three selectors. First, **test-impact analysis (TIA)**: map tests to the code they exercise — via per-test coverage data, build-graph dependencies (Bazel/Nx affected-targets), or ML-based predictive selection in larger orgs — and run only tests transitively touched by the diff. TIA is a precision tool with known blind spots: it can't see reflection, dynamic dispatch, config/data-driven behavior, or cross-service effects, so never let it stand alone. Second, add a **risk-based floor** that runs regardless of impact mapping: tests tagged for revenue-critical paths and recent-incident areas, plus tests that historically fail most — commonly the top ~5% of tests by failure yield catch a large majority of caught regressions, so pin them into every run. Third, define **full-suite triggers** explicitly: merges to main, release candidates, dependency and toolchain bumps, changes to shared config/migrations/build files, and a scheduled nightly — selection debt accumulates invisibly, and the nightly full run is what pays it down and flags TIA misses (any nightly-only failure means the selector has a hole to patch). Keep quarantined flaky tests in a **separate non-blocking lane**: they still run and report, but never gate merges and never count as selection coverage — a quarantined test silently included in the "selected" count is fake safety. Budget the whole thing: PR-gating selection should finish in ~10 minutes; if the selected set routinely exceeds that, tighten the selector or shard before you start skipping. Rule: **Selection may decide when a test runs, never whether it exists — every test must run at least nightly, and any test that never gets selected is either dead (delete it) or your impact map is broken (fix it).**

BAD: "Skip the nightly full run since selected tests have been green for a month" (green selected runs are exactly what a blind spot looks like; the miss ships in the one path TIA can't see). GOOD: "TIA-selected set + pinned risk floor on PRs in ≤10 min; full suite nightly and on main, with any nightly-only failure triaged as a selector bug."

```
SELECTION POLICY
════════════════
TIA: source=[coverage-map/build-graph/predictive] · blind spots noted=[reflection, config, cross-service]
RISK FLOOR: [critical-path tags + top ~5% failure-yield tests] · always runs
PR BUDGET: ≤10 min · overflow → shard/tighten, never skip
FULL SUITE: [main merges · releases · dep bumps · shared-file changes · nightly]
QUARANTINE LANE: runs non-blocking · excluded from coverage claims
MISS AUDIT: nightly-only failure → selector bug ticket
```

Skip when: the full suite runs in under ~10 minutes — just run everything, selection machinery costs more than it saves; or the codebase is a monolith with no reliable test-to-code mapping yet (build the map first).

Gotchas: trusting file-path heuristics ("changed `users/` so run `users` tests") misses shared utilities and config that fan out everywhere; letting the risk floor grow monotonically until "selection" is 80% of the suite — prune it quarterly by failure yield; counting quarantined tests as coverage; forgetting that a change to the test selector itself must trigger a full run — a selector bug that skips tests is invisible by construction.
