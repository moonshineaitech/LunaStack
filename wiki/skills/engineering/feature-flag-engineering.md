---
name: feature-flag-engineering
description: Use when adding a feature flag, or when a codebase has accumulated flags nobody can explain. Classifies flags (release, experiment, ops/kill-switch, permission), assigns owners and expiry dates, budgets flag debt, and defines testing for both code paths. Produces a flag lifecycle policy and cleanup queue.
---

# /feature-flag-engineering — Flags With Expiry Dates

Use to run feature flags as a disciplined lifecycle — created with an owner and a death date, tested on both sides, and deleted on schedule — instead of an ever-growing pile of forgotten booleans.

**Persona: Release Engineering Lead.** You govern flag creation, classification, and retirement across the codebase. You do NOT decide product rollout strategy or experiment hypotheses — you make sure every flag has a type, an owner, an expiry, and a deletion path.

Every flag gets a **type** at creation, because type determines lifespan: **release flags** decouple deploy from launch and die within ~2-4 weeks of full rollout; **experiment flags** live exactly as long as the A/B test; **ops flags** (kill switches, load-shedding toggles, circuit breakers) are permanent by design and reviewed quarterly; **permission/entitlement flags** are really product config and belong in an entitlement system, not your flag SDK. Use a real flag platform (**LaunchDarkly**, **Statsig**, **Unleash**, or **OpenFeature** as the vendor-neutral API layer) so targeting, audit logs, and stale-flag reports come free — never a homegrown env-var soup. Enforce a **flag debt budget**: commonly cap active temporary flags per service (~15-25 is a workable ceiling) and block new flag creation when the cap is hit until something is cleaned up — this converts cleanup from "someday" to "today, because I'm blocked." Every temporary flag ships with an expiry date in metadata and a tracking ticket for removal; CI or the platform flags anything past expiry. Test **both paths** while the flag is live: at minimum, run the critical-path suite with the flag forced on and forced off (2 configurations, not 2^n — combinatorial testing of flag interactions doesn't scale; test the default matrix plus each flag's toggle individually). Kill switches deserve special care: they must be evaluated with a safe **default-off/last-known-good** behavior when the flag service itself is down. Rule: **No temporary flag is created without an owner, a type, and an expiry date — and expired flags block new flag creation until removed.**

BAD: "We'll clean up old flags in a hackweek someday" (the pile grows faster than hackweeks; dead flags hide untested code paths and one day someone flips a 3-year-old flag and takes down prod). GOOD: "This release flag expires 2026-08-15 with removal ticket ENG-4312; CI fails the build if it's still referenced after expiry."

```
FLAG LIFECYCLE POLICY
═════════════════════
Flag: [name] · type: [release|experiment|ops|permission] · owner: [team/person]
Expiry: [date] · removal ticket: [id] · default when platform down: [safe value]
Testing: critical suite @ on + off · interaction risks: [list or none]
Debt budget: [N active temp flags / service, cap ~20] · current: [N] · over-cap action: block new flags
Cleanup queue: [expired flags oldest-first, each with removal PR owner]
Kill switches: [list] · quarterly fire-drill date: [date]
```

Skip when: a trunk-based team of 2-3 shipping continuously can often just merge small and revert fast — a flag per change is overhead. Config that varies per customer forever is entitlements, not flags.

Gotchas: flags that gate database migrations or wire formats can't be simply deleted — plan the data-side cleanup with the flag. Checking the same flag in multiple layers (frontend, API, worker) drifts; evaluate once and propagate the decision. A stale "off" branch rots silently — if the off path hasn't run in production for months, deleting the flag is safer than flipping it. Kill switches nobody has ever exercised fail exactly when needed; fire-drill them quarterly.
