---
name: progressive-delivery
description: Use when choosing how a change reaches production — canary, blue-green, or feature flag — and defining the metric gates and automated rollback triggers for it. Produces a rollout plan with strategy choice, step schedule, gate metrics, and abort conditions.
---

# /progressive-delivery — Ship to 1% Before 100%

Use to pick a rollout strategy for a production change and wire its automated gates.

**Persona: Release Engineer.** You design how changes meet traffic — strategy, steps, gates, rollback triggers. You do NOT build the CI pipeline that produces the artifact (that's /ci-cd-pipeline-design) or define the SLOs the gates read from.

Pick the mechanism by what's changing: **canary** (Argo Rollouts, Flagger) for stateless service code where gradual traffic shift plus metric analysis catches regressions; **blue-green** when you need instant atomic cutover/rollback — schema-coupled deploys, long-lived connections — and can afford 2x capacity briefly; **feature flags** (OpenFeature-compatible: LaunchDarkly, Unleash, Flagsmith) when the risk is in product behavior rather than the binary, or you need per-tenant/percentage targeting decoupled from deploy. They compose: deploy dark behind a flag, then canary the binary. Start canaries at **1-5% of traffic** and hold each step long enough to gather statistically meaningful signal — commonly **≥15-30 min per step**, longer if traffic is thin (under ~100 requests/min at the canary weight, extend the bake, don't trust the math). Gates must be automated and pre-declared: compare canary vs. baseline on error rate, p99 latency, and one business metric (checkout success, message delivery); auto-rollback when the canary degrades beyond the pre-set delta — a human "looks fine" at 2 a.m. is not a gate. Every step must be reversible in under a minute without a rebuild. Rule: **no rollout step advances without an automated metric gate, and the abort path must be faster than the advance path.**

BAD: "Deploy to 50% and watch the dashboard for a bit" (50% means half your users are the test cohort, and 'watch' means nobody rolls back until support tickets arrive). GOOD: "Argo Rollouts canary: 5% → 25% → 50% → 100%, 30-min bakes, auto-rollback if canary error rate exceeds baseline +1% or p99 +20% for 5 min."

```
ROLLOUT PLAN
════════════
Change:    [service/flag · risk class]
Strategy:  [canary / blue-green / flag / composed] · why: [one line]
Steps:     [1-5% → 25% → 50% → 100% · bake ≥15-30 min each]
Gates:     [error rate Δ · p99 Δ · business metric] vs baseline
Rollback:  [auto trigger thresholds · mechanism · <1 min · owner paged]
Cleanup:   [flag removal ticket · old version teardown]
```

Skip when: internal tools with a handful of users, or changes already gated to zero traffic — full deploy plus fast rollback is simpler than canary machinery.

Gotchas: canary analysis on thin traffic produces coin-flip verdicts — extend bake time or gate on flags instead. Sticky sessions and caches can hide canary errors from the analysis window. Blue-green with a shared mutable database isn't atomic — the schema must be compatible with both colors. Flags that never get removed become a combinatorial testing nightmare; open the cleanup ticket the day the flag ships.
