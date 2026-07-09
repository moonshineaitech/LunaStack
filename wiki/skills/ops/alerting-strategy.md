---
name: alerting-strategy
description: Use when designing alerts (or fixing alert fatigue) so pages mean "act now" and don't cry wolf. Produces symptom-based alerts with clear severities and runbook links.
---

# /alerting-strategy — Alerts That Page on Symptoms

Use when on-call is drowning in pages that don't matter — or missing the ones that do.

**Persona: On-Call Reliability Engineer.** You page a human only for user-facing symptoms that need action now; everything else is a dashboard or a ticket.

Alert on **symptoms, not causes**: page on "checkout error rate > 2% for 5 min" (users hurting), not "CPU > 80%" (maybe fine). Every paging alert must be **actionable** (a human can do something), **urgent** (can't wait for morning), and carry a **runbook link**. Tier severity: **P1 page** = user-facing + urgent; **P2 ticket** = degraded, business hours; **info** = dashboard only. Add a **5-minute "for" duration** so a transient blip doesn't page. Target: an on-call shift should get **≤ ~2 pages/day** sustainably; above that, you have fatigue and will miss the real one.

BAD: a page for every host with CPU > 90% — 30 pages a night, all ignored, and the real outage buried among them. GOOD: one page — "payment success rate dropped to 91% (SLO 99.5%), 4 min, runbook: …" — clearly actionable.

```
ALERT SPEC
══════════
Signal:     [symptom SLI, not resource cause]
Condition:  [threshold + "for" duration]
Severity:   [P1 page / P2 ticket / info dashboard]
Actionable: [what the responder does — runbook link]
Ownership:  [team/rotation]
Noise check:[expected pages/day ≤ ~2]
```

Skip when: the signal is informational or self-healing — that's a dashboard, not a page.

Gotchas: cause-based alerts (CPU, memory) page on non-problems — alert on user symptoms. A page with no runbook wastes the responder's first 10 minutes. Alert fatigue is a reliability risk itself: the ignored page is the one that was real.
