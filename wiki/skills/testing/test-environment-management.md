---
name: test-environment-management
description: Use when tests pass in one environment and fail in another, staging has drifted from production, or teams queue for a shared env. Produces an environment strategy — ephemeral preview envs, a parity budget of allowed prod deltas, and a data-refresh policy with owners.
---

# /test-environment-management — Environments You Can Trust

Use to replace a drifting shared staging with ephemeral previews plus an explicitly budgeted, honest pre-prod.

**Persona: Environment Steward.** Owns where tests run and how truthfully those places resemble production. Does NOT design the tests, manage test data creation (see /test-data-management), or run production incident response.

The modern default is **ephemeral preview environments**: every PR gets a short-lived, from-scratch environment (Argo CD ApplicationSets or GitOps preview pipelines on Kubernetes, or platform previews like Vercel/Neon branching for app+DB), torn down on merge with a TTL cap (commonly ≤72h) so orphans don't bleed money. Ephemerality is the anti-drift weapon — an environment rebuilt from declarative config on every PR *cannot* drift, whereas a long-lived staging accumulates manual kubectl edits, stale feature flags, and forgotten cron jobs until it tests a system that no longer exists. For the one persistent pre-prod you keep, practice **staging honesty**: maintain a written **parity budget** — an explicit list of every difference from production (instance sizes, replica counts, third-party sandboxes vs live, data scale, flag states) — commonly capped at ~10 items, each with an owner and a justification. An undocumented delta is a latent "works in staging" incident; the budget converts drift from a surprise into a reviewed decision, and CI can diff live config against the declared list to catch delta #11. Data freshness is a policy, not an accident: refresh persistent-env data on a stated cadence (commonly weekly to monthly) from **synthetic generators shaped like production** — never raw prod copies (PII/GDPR scope) — and version the seed script with the schema so refresh never breaks on migration day. Rule: **Any environment that cannot be destroyed and recreated from committed config within ~30 minutes is a liability — fix reproducibility before adding another environment.**

BAD: "Keep staging alive for two years and hand-patch it when tests fail there" (each patch widens undocumented drift; staging greenlights deploys against a fictional system). GOOD: "Per-PR ephemeral envs from the same manifests as prod, plus one pre-prod with a 10-item signed parity budget diffed in CI weekly."

```
ENVIRONMENT STRATEGY
════════════════════
EPHEMERAL: per-PR via [ArgoCD ApplicationSet/…] · TTL≤72h · teardown-on-merge
PERSISTENT: [pre-prod] · rebuildable-from-git ≤30min
PARITY BUDGET: [≤10 deltas vs prod] · each: what/why/owner · CI drift-diff=[weekly]
DATA: refresh=[cadence] · source=synthetic (no prod PII) · seed versioned w/ schema
COST GUARD: [TTL reaper + budget alert]
```

Skip when: a solo project where docker-compose on the laptop plus production is the whole topology, or infra is fully serverless-managed with per-branch previews already built into the platform.

Gotchas: shared mutable staging as the merge gate creates a team-wide queue and turns every broken env into an org-wide outage — previews decouple that; "parity" pursued as exact prod duplication doubles infra spend for marginal signal — budget the deltas instead of denying them; seeding preview envs by copying staging's already-drifted data propagates the drift; DNS, TLS, quotas, and third-party webhook allowlists are the classic unlisted deltas — they differ silently and only fail in prod.
