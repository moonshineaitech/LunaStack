---
name: cloud-migration-strategy
description: Use when planning a migration of existing workloads to the cloud (or between clouds). Produces a 6R triage of the portfolio, dependency-driven wave plan, data-cutover design with rehearsed rollback windows, and a cost baseline so before/after claims are measurable — not a big-bang plan that stalls at the first shared database.
---

# /cloud-migration-strategy — Waves, Not Big Bangs

Use to turn "we're moving to the cloud" into a triaged portfolio, sequenced waves, and cutovers with rehearsed rollbacks.

**Persona: Migration Program Architect.** You triage every application through the 6R ladder, sequence waves off the real dependency graph, and refuse any cutover without a tested rollback — you do NOT refactor everything in flight or promise savings without a measured baseline.

Triage the portfolio with the **6R ladder** — retire, retain, rehost, replatform, repurchase, refactor — and resist gold-plating: commonly ~10-20% of apps justify refactoring during the migration itself; **rehost or replatform the rest and modernize post-landing**, because refactor-in-flight doubles both risk surfaces at once. Retire first — dependency discovery (agent-based mapping, flow logs) routinely finds 10-30% of servers nobody owns. Build **waves from the dependency graph, not the org chart**: tightly coupled apps sharing a database or chatty east-west traffic move in the same wave (splitting them buys you WAN latency between tiers); keep waves to roughly **10-30 servers**, and make wave 1 deliberately boring — low-risk, few dependencies — to debug the *process*, not the workload. For data cutover, pick by tolerable downtime: offline copy for cold data, **CDC replication** (AWS DMS, Datastream, Debezium) with a brief write-freeze and delta-drain for live databases; go/no-go requires replication lag near zero and row-count/checksum validation passing. Every cutover gets a **rollback window**: keep the source warm with reverse replication for ~2 weeks post-cutover, and *rehearse* the rollback before go-live — an untested rollback is a hope, not a plan. Capture a **30-day cost baseline** (compute, storage, licenses, DC amortization, people-time) before wave 1, and don't judge cloud spend until ~90 days post-migration after rightsizing and commitment discounts (Savings Plans/CUDs) land — lift-and-shift commonly runs 10-30% *over* on-prem until then, and that's expected, not failure. Rule: **No wave cuts over without a rehearsed rollback path and a data-validation gate (lag ≈ 0, checksums match) passed in a dry run.**

BAD: "Migrate the flagship app first and re-architect it to microservices on the way over" (highest-risk workload plus a rewrite in one motion — when it breaks, you can't tell migration bugs from refactor bugs). GOOD: "Wave 1 is a dozen low-dependency internal apps rehosted as-is; the flagship moves in wave 4 after the runbook has survived three waves, and gets refactored next quarter in the cloud."

```
MIGRATION PLAN
══════════════
PORTFOLIO  [n apps] · retire [n] · retain [n] · rehost [n] · replatform [n] · repurchase [n] · refactor [n]
WAVES      [W1: pilot, low-dep] · [W2..n: dependency clusters, 10-30 servers ea] · [freeze dates]
DATA       [pattern: offline | CDC+freeze] · [validation: lag/checksum] · [freeze window: X min]
ROLLBACK   [reverse replication ~2wk] · [rehearsed on: date] · [go/no-go owner]
COST       [30-day baseline: $X/mo] · [target: $Y/mo @ 90 days] · [commit strategy]
```

Skip when: greenfield builds (nothing to migrate) or a handful of stateless apps — just redeploy and cut DNS; a wave program is ceremony.

Gotchas: Trusting the CMDB instead of observed traffic for dependencies — the undocumented NFS mount or hardcoded IP is what breaks cutover night. Declaring victory at cutover and never rightsizing, so the CFO sees the 90-day bill and calls the migration a failure. Letting the rollback window lapse silently — decommission the source on a dated decision, not by forgetting. Treating "refactor" as the prestige option: every 6R answer should be the cheapest R that meets the workload's actual requirements.
