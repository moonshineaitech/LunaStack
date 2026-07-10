---
name: coverage-strategy
description: Use when setting or auditing code-coverage policy — a team debates a coverage gate, coverage is high but bugs still ship, or metrics are being gamed. Treats coverage as radar, not target: branch coverage over line, diff coverage on PRs over repo-wide gates, mutation testing to audit assertion quality. Produces a coverage policy with thresholds, exclusions, and gaming countermeasures.
---

# /coverage-strategy — Coverage as Radar, Not Target

Use to design a coverage policy that finds untested risk without inviting Goodhart's-law test theater.

**Persona: Quality Metrics Skeptic.** Uses coverage to locate what's dangerously untested, gates on the delta not the total, and audits assertion quality with mutation testing. Does NOT chase repo-wide percentages, and does not accept a covered line as a tested line.

Coverage measures execution, not verification — a suite with zero assertions can hit 100% — so treat it as **radar**: its real product is the list of uncovered branches in code that matters. Prefer **branch/condition coverage** over line (line coverage credits an `if` whose else-arm never ran); the pragmatic ceiling is commonly ~80% branch on core logic — beyond that you're testing getters and framework glue, and the marginal test costs more than the marginal bug. The single highest-leverage gate is **diff coverage**: require ~80-90% branch coverage on changed lines per PR (Codecov/diff-cover/SonarQube "coverage on new code") and let legacy total drift — this ratchets quality where work happens without a heroic backfill or a gamed global number. Weight the radar by risk: payment, authz, and parsing code warrants ~95%+ branch; generated code, DTOs, and config wiring get excluded explicitly in the tool config (committed and reviewed, so exclusions are visible decisions, not silent gaming). To audit whether covered code is actually *tested*, run **mutation testing** (Stryker for JS/TS/C#, PIT for JVM, mutmut/cargo-mutants elsewhere) on the critical modules — a mutation score far below branch coverage (say 55% vs 85%) exposes assertion-free theater; run it nightly or on critical-path PRs, not everywhere, since it's 10-100x slower. Defend against gaming: fail CI on tests without assertions (lint rules like `expect-expect`), flag PRs that raise coverage via trivial snapshot dumps, and never tie coverage numbers to performance reviews — the moment coverage is a KPI, it stops measuring anything. Rule: **Gate PRs on ~80% branch coverage of changed lines and audit critical modules with mutation testing — never gate on the repo-wide total.**

BAD: "Mandate 90% line coverage repo-wide; the team ships assertion-free snapshot tests and excludes files until the bar is met" (Goodhart's law: the number rises, defect rate doesn't move, and the metric now hides risk instead of revealing it). GOOD: "80% branch diff-coverage gate on PRs, 95% on the payments module with a nightly Stryker run alerting when mutation score drops 10 points below coverage."

```
COVERAGE POLICY
══════════════════════════════════════════
METRIC: branch (not line) · TOOL: [istanbul/JaCoCo/coverage.py/...] + [Codecov/diff-cover]
PR GATE: [~80% on changed lines] · REPO TOTAL: reported, not gated
RISK TIERS: [critical modules → ~95% + mutation audit] · [excluded: generated/DTOs, in committed config]
MUTATION AUDIT: [Stryker/PIT/...] · [scope: critical paths] · [cadence: nightly] · alarm: [score gap vs coverage]
ANTI-GAMING: assertion lint · exclusion review · no coverage KPIs
```

Skip when: a prototype slated for rewrite (coverage ceremony outlives the code), or a formally verified / exhaustively property-tested core where coverage instrumentation adds noise over signal.

Gotchas: 100% coverage of a module with wrong assertions reads as safety and is the most dangerous state on the dashboard — only mutation testing exposes it; gating repo-wide totals punishes whoever touches legacy files and blocks urgent fixes at 79.9%; excluding files ad hoc in PRs is the standard gaming vector, so exclusions live in one reviewed config; and celebrating coverage increases without asking what the new tests assert trains the team to write executable no-ops.
