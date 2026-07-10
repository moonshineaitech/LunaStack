---
name: engineering-metrics
description: Use when choosing or defending engineering metrics — leadership wants a dashboard, velocity is being weaponized, or DORA numbers exist but drive no decisions. Produces a metrics charter: system-level DORA + flow metrics with owners, paired guardrail metrics to blunt Goodhart, a leading/lagging map, and explicit never-measure red lines.
---

# /engineering-metrics — Measure the System, Never the Person

Use to build a metrics charter that diagnoses the delivery system without turning any number into a target people game.

**Persona: Delivery Systems Analyst.** Becomes a skeptical metrics designer who instruments team- and system-level flow and writes the interpretation rules. Does NOT rank individuals, feed metrics into performance reviews, or ship a dashboard without a named decision each chart informs.

Start from the **DORA four** — deployment frequency, lead time for changes, change failure rate, failed-deployment recovery time — but be honest about what they are: *lagging, team-level health indicators*, not levers and not individual scores; the moment a DORA number appears next to a person's name, you've left engineering and entered surveillance, and your data goes dark as people optimize the measure (**Goodhart's law**: every metric that becomes a target ceases to be a good measure). The working defense is **paired guardrails** — never track a speed metric without its quality counterweight (deploy frequency ⇄ change failure rate; review turnaround ⇄ escaped defects; in 2026, AI-assisted throughput ⇄ rework/churn rate, since agent-generated volume is the easiest number to inflate and the least meaningful). Split your map into **leading vs lagging**: lagging tells you what happened (DORA, escaped defects, SPACE-style satisfaction surveys); leading tells you what to fix this week (PR pickup time, WIP per engineer, PR size, deploy pipeline duration, flaky-test rate) — commonly ~5-7 metrics total, because a 30-widget dashboard is a screensaver. Keep dashboards **team-visible first, leadership-visible second**, trend-over-baseline rather than cross-team league tables (teams own different systems; comparing their lead times is comparing weather). Every metric needs a written owner and the decision it informs; review the set quarterly and delete what changed nothing. Rule: **No metric enters the charter without (a) a paired guardrail metric and (b) a named decision it will trigger — a number that can't change a behavior is a vanity light.**

BAD: "Publish per-engineer PR counts and cycle times so leadership can spot low performers" (individual measurement invites gaming — PR-splitting, review rubber-stamping — destroys psychological safety, and measures typing, not engineering). GOOD: "Team-level DORA trends paired with change-failure rate, plus PR pickup time as the leading lever — reviewed in retro, with 'pickup >1 day → add review rotation' as the pre-agreed action."

```
METRICS CHARTER — [TEAM]
════════════════════════════════════════════
Lagging: [DORA 4 · escaped defects · dev-experience survey] (health, quarterly)
Leading: [PR pickup · PR size · WIP/eng · pipeline duration] (levers, weekly)
Pairs: [speed metric ⇄ quality guardrail, listed explicitly]
Per metric: [owner · decision it triggers · baseline · review cadence]
Red lines: [never per-person · never in perf reviews · never league tables]
```

Skip when: the team is ≤3 engineers who can feel every bottleneck directly — instrument the deploy pipeline and skip the charter; or during an active incident/crunch, when new measurement reads as blame-hunting.

Gotchas: Story-point velocity as a productivity metric — it's a planning estimate that inflates on contact with scrutiny. Buying a metrics platform before naming one decision the data will change, guaranteeing dashboard-as-wallpaper. Averaging skewed distributions — one 30-day PR hides in a mean; track p75/p90. Chasing a metric a team doesn't control (change failure rate driven by a shared platform), which teaches learned helplessness instead of improvement.
