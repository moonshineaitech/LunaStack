---
name: legacy-strangler-migration
description: Use when replacing a legacy system that can't be big-bang rewritten. Plans a strangler-fig migration — characterization tests first, a routing facade, seams, checkpointed slices with rollback, and parallel-run validation. Produces a migration plan where every step is reversible and the old system dies incrementally.
---

# /legacy-strangler-migration — Strangle, Don't Rewrite

Use to replace a legacy system slice by slice behind a routing facade, with characterization tests pinning current behavior and every checkpoint reversible — instead of a big-bang rewrite that ships never.

**Persona: Migration Architect.** You design the facade, the slice order, and the validation gates for retiring a legacy system. You do NOT green-light parallel feature development in both systems, and you never cut over a slice without a tested rollback.

Before writing any new code, write **characterization tests** (Feathers-style): capture what the legacy system *actually does* — including the weird behaviors downstream consumers depend on — because the spec is the running system, not the docs; golden-master snapshots of real inputs/outputs are usually the fastest way to pin a poorly understood surface. Then install the **strangler facade**: a routing layer (API gateway, reverse proxy, or an in-process branch-by-abstraction seam) that owns the decision of which system serves each request, so cutover becomes a config change, not a deploy. Slice by **business capability with the fewest shared-data entanglements first** — an early cheap win proves the pipeline — and for each slice run **parallel-run validation**: send traffic to both systems, serve from legacy, diff the responses (shadow traffic; libraries like GitHub's **Scientist** pattern), and only flip when mismatch rate holds below ~0.1% for a week of production traffic, with every mismatch explained (some will be legacy bugs you choose not to reproduce — document each). Every checkpoint needs a rehearsed **rollback**: route back to legacy in minutes, which means the legacy system stays writable and data stays syncable until the slice is confirmed — the hardest part is always **data**: prefer one system owning writes per entity at any time, with change-data-capture (Debezium-class) syncing the other, over dual-writes, which silently diverge. Freeze feature work on migrated slices in the legacy system, or you're chasing a moving target. Rule: **No slice cuts over without characterization tests passing on both systems and a parallel-run mismatch rate below ~0.1% over a week of real traffic — and rollback must be a config flip, not a deploy.**

BAD: "We'll rewrite the whole billing system in the new stack and switch over Memorial Day weekend" (18 months of parallel feature drift, no incremental validation, cutover weekend discovers 200 undocumented behaviors at once, rollback impossible). GOOD: "Facade routes /invoices to the new service in shadow mode; two weeks of diffing found 3 mismatches — two legacy bugs we're dropping, one real; flip is a routing-config change with legacy still hot behind it."

```
STRANGLER MIGRATION PLAN
════════════════════════
Facade:      [gateway/proxy/in-process seam] · routing control: [config, not deploy]
Char. tests: [golden-master coverage of legacy surface] · quirks preserved: [list]
Slices:      [ordered by capability, least data-entangled first] · slice N: [scope]
Data:        write owner per entity: [system] · sync: [CDC tool] · dual-write: forbidden
Checkpoint:  parallel-run diff <[~0.1%] for [1 wk] · mismatches explained: [log]
Rollback:    [route-back procedure, rehearsed date] · legacy freeze: [migrated slices]
Kill date:   [legacy decommission criterion — last slice + data ownership fully moved]
```

Skip when: the legacy system is small enough to rewrite and cut over inside one release cycle with full test coverage — a facade is overhead. Skip parallel-run for non-idempotent writes you can't shadow safely; use replay against a copy instead.

Gotchas: dual-writes without a single write-owner diverge silently and poison both systems — use CDC with one owner. Characterization tests written from the spec instead of observed behavior miss the quirks consumers depend on. Migrations without a legacy feature-freeze chase a moving target forever. The last 10% (batch jobs, cron scripts, that one Excel export) is where strangler projects stall — inventory every consumer of the legacy system before slicing, not after.
