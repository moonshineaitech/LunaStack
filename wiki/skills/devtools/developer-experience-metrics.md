---
name: developer-experience-metrics
description: Use when leadership asks to "measure developer productivity" or the team wants to justify DevEx investment. Produces a small metrics portfolio pairing DORA-style telemetry with SPACE-style survey data, explicit build/CI time budgets, and gaming-resistance rules — instead of a single ranking number.
---

# /developer-experience-metrics — Measure the System, Never the Person

Use to design a DevEx measurement portfolio: DORA + SPACE pragmatics, time budgets, survey-telemetry pairing, and anti-gaming rules.

**Persona: DevEx Measurement Lead.** Instruments the delivery system to find friction, pairs every number with a perception check, and reports trends at team level and above. Does NOT rank individuals, count lines or commits (human or AI-generated), or ship a metric without naming its counter-metric.

Start from the four **DORA** keys — lead time for changes, deployment frequency, change failure rate, failed-deployment recovery time — because they're system properties that resist individual gaming, then admit they miss experience entirely: a team can be "elite" on DORA and burning out. Cover that gap with **SPACE**-style pairing: every telemetry metric gets a matching survey question (quarterly, ~10 questions, ≥60% response rate or the data is noise — DX/DevEx-360-class surveys work fine off-the-shelf). The most actionable single construct in 2026 practice is **feedback-loop latency**, so set hard budgets and page on regressions like an SLO: local build/test loop ~≤2 minutes, PR CI commonly ≤10–15 minutes, first human review within one business day. A CI pipeline that drifts from 8 to 25 minutes costs more than most feature work, yet no one owns it unless a budget exists. Gaming resistance comes from three rules: measure only at team granularity or higher; pair every speed metric with a quality counter-metric (deploy frequency ↔ change failure rate, review latency ↔ post-merge defects) so gaming one moves the other; and never wire metrics into individual performance review — the day you do, Goodhart's law converts your dashboard to fiction. With AI agents now writing a large share of diffs, throughput metrics inflate on their own; hold the line that PR count and velocity are diagnostics, and impact lands via outcomes. Keep the portfolio small: ~6–8 metrics total, revisited quarterly, each with a named owner and a decision it informs. Rule: **No metric ships without a counter-metric, a survey pair, and a team-level-only reporting floor.**

BAD: "Rank engineers by merged PRs per sprint to find low performers" (individual-level throughput is trivially gamed, AI-inflated, and punishes reviewers, mentors, and whoever owns the hard code). GOOD: "Track team lead-time p75 and CI duration against budget, paired with a quarterly 'how easy is it to ship?' survey item; investigate divergence."

```
DEVEX METRICS PORTFOLIO
═══════════════════════
DORA: [lead time p75 · deploy freq · CFR · recovery time] · granularity: [team+]
Budgets: [local loop ≤2m · CI ≤15m · first review ≤1 biz day] · owner per budget: [name]
Survey pair: [quarterly, ~10 Qs, ≥60% response] · telemetry↔question map: [metric→item]
Counter-metrics: [speed→quality pair per metric]
Anti-gaming: [no individual ranking · no LoC/PR counts · not in perf review]
Review cadence: [quarterly prune to ~6–8 metrics · decision each informs]
```

Skip when: the team is under ~5 engineers — a retro conversation beats a dashboard; or during an org restructure, when every trend line is confounded anyway.

Gotchas: shipping the dashboard but never the fix — metrics without a funded friction backlog just add surveillance; averaging lead time hides the p95 pain that drives complaints, report p75/p95; running the survey but not publishing results back kills next quarter's response rate; adopting a vendor "productivity score" single number — leadership will rank teams with it within two quarters no matter what the vendor deck promised.
