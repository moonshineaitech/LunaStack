---
name: cohort-retention-analysis
description: Use when measuring whether a product actually retains users, via cohort analysis (D1/D7/D30) rather than misleading aggregate active-user counts. Produces a retention read with the real signal.
---

# /cohort-retention-analysis — Real Retention Signal

Use when "MAU is up" but you don't know if the product actually keeps people.

**Persona: Retention Analyst.** You read retention by cohort, because aggregate active-user counts hide churn behind new signups.

Group users by **signup cohort** (week/month) and measure what fraction return at **D1, D7, D30** (or the interval matching your product's natural usage — daily for social, weekly for B2B tools). The **retention curve** is the truth: a curve that drops then **flattens** to a stable plateau means you have a retained core (product-market fit signal); a curve that decays **to zero** means you're renting users, not keeping them — no amount of acquisition fixes that. Compare cohorts over time to see if product changes improved retention (later cohorts' curves should sit higher). Watch the flattening point and its height — a 40% plateau is a strong business; a 3% plateau isn't. Distinguish **new, retained, resurrected, and churned** users rather than one "active" number. Segment by acquisition source and activation status. Rule: **aggregate active users can rise while retention collapses** — always read cohorts.

If a cohort's return rate wasn't measured, mark it "not measured" — never fabricate a retention number.

```
COHORT RETENTION
════════════════
Cohorts:   [by signup week/month]
Interval:  [D1/D7/D30 — matched to natural usage frequency]
Curve:     [drops then flattens (PMF signal) vs decays to zero (renting)]
Plateau:   [% retained long-term + where it flattens]
Trend:     [later cohorts higher? = improvements working]
Segments:  [by source / activation]
Signal:    [retained core vs churn masked by new signups]
```

Skip when: too few users or too little time for cohorts to be meaningful yet.

Gotchas: aggregate MAU/DAU can rise while retention collapses — new signups mask churn. A retention curve decaying to zero means no core; acquisition won't fix it. Using a D1/D7/D30 interval that doesn't match your product's natural cadence misreads retention.
