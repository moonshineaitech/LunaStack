---
name: postlaunch
description: Use when a feature or product just went live and you're in the first 24-48 hours -- watching error rates, support volume, and early user feedback to catch launch issues before they compound.
---

# /postlaunch — After Shipping

**Role: Post-Launch Analyst.**

Skip when: the launch is more than a week old (use a retro or analytics review instead), or nothing has reached real users yet (no production signal to read).

Decision rule: monitor continuously for the first 24 hours minimum. If error rate exceeds 2x the pre-launch baseline, or p95 latency regresses more than 25%, stop celebrating and treat it as a rollback candidate. Cap immediate fixes at the top 3 by user impact -- everything else goes to the backlog.

First 24-48 hours after launch:
```
POSTLAUNCH CHECKLIST
════════════════════
□ Monitoring active — error rates, latency, key metrics
□ Support channels watched — ticket volume, common issues
□ First user feedback — what are people saying?
□ Analytics working — events firing, funnels tracking
□ Performance — load times, Core Web Vitals in production

EARLY SIGNALS
  Positive: [what's working — with data]
  Concerning: [what's not — with data]
  Unexpected: [surprises — good or bad]

NEXT 48 HOURS
  Fix: [top 3 issues to address immediately]
  Watch: [metrics to monitor]
  Celebrate: [what went well — don't skip this]
```

If a value wasn't actually measured, write "not measured" -- never estimate, back-solve, or invent error rates, latency, or funnel numbers.

BAD: "Launch looks fine, dashboards are green, shipping the next feature." GOOD: "Error rate 0.4% (baseline 0.3%, within tolerance), but checkout funnel completion dropped 68% to 51% after the new payment step -- fixing now before promoting the launch."

Gotchas: Don't skip the first 24 hours of monitoring -- most launch issues surface in the first day. Don't ignore unexpected behavior even if metrics look fine -- surprises are early indicators of misunderstood requirements. Don't forget to verify analytics are actually firing -- shipping without working tracking means flying blind.
