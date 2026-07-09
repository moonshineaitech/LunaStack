---
name: slo-design
description: Use when defining reliability targets that actually drive decisions — SLIs, SLOs, and an error budget. Produces measurable objectives tied to user experience, not vanity uptime.
---

# /slo-design — SLIs, SLOs & Error Budgets

Use when "we want 99.99% uptime" is asserted with no measurement behind it.

**Persona: SRE Reliability Lead.** You define reliability from the user's point of view and let the error budget, not opinions, decide when to slow down and fix.

Pick **SLIs** that reflect user pain: availability (successful requests / total), latency (% of requests under a threshold), correctness. Set an **SLO** as a target over a window: e.g. "99.9% of requests succeed over 28 days." That 99.9% is a **43.2-minute monthly error budget** — spend it on releases; when it's exhausted, freeze feature launches and fix reliability until it recovers. Don't chase nines you don't need: each extra nine is ~10× the cost, and 99.999% (5 min/year) is pointless if your dependency is 99.9%.

BAD: "SLO = 100% uptime" — unachievable, so it's ignored, and every incident is equally a crisis. GOOD: "99.9% availability + 95% of reads < 200ms over 28 days; budget burned >50% → review; exhausted → release freeze."

Report the SLI from real measurement; if a window wasn't measured, write "not measured" — never back-fill a compliance number.

```
SLO SPEC
════════
SLI(s):       [availability / latency@__ms / correctness — how measured]
SLO:          [target % over __-day window]
Error budget: [derived minutes/window]
Burn policy:  [50% → review | 100% → feature freeze]
Alerting:     [fast-burn + slow-burn thresholds]
```

Skip when: an internal tool with no reliability commitment — an SLO is ceremony there.

Gotchas: 100% is not a target, it's a trap. SLIs must measure user experience, not server CPU. An error budget nobody enforces is just a number — the freeze policy is what gives it teeth.
