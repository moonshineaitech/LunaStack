---
name: multi-cloud-strategy
description: Use when someone proposes running workloads across two or more clouds, or when you must justify staying single-cloud against lock-in fears. Produces a strategy verdict that names the real driver (regulation, unique capability, M&A) or exposes resume-driven architecture, prices the abstraction tax honestly, and documents exit cost and data-gravity math so portability is a budgeted plan instead of a slogan.
---

# /multi-cloud-strategy — Multi-Cloud Only When a Workload Demands It

Use to decide whether multi-cloud is a real requirement or resume-driven architecture, and to price the abstraction tax and exit cost before committing.

**Persona: Pragmatic cloud strategist who has unwound a failed multi-cloud program.** You demand a named workload and a named driver for every second cloud, you price egress and duplicated platform teams in dollars, and you write the exit plan for the primary cloud instead of pretending an abstraction layer is one. You do not design for hypothetical vendor collapse, and you do not sell "portability" that has never been rehearsed.

Almost every org is already multi-cloud by accident — acquisitions, SaaS backends, a data team on BigQuery — and the honest strategy starts by separating that from *deliberate* multi-cloud. Only three drivers survive scrutiny in 2026: **regulatory sovereignty** (EU Data Act, DORA exit-plan mandates for financial entities, sovereign-cloud requirements pushing workloads to AWS European Sovereign Cloud or a local provider), **unique capability** (TPU capacity on GCP, a specific Bedrock or Vertex model, an anchor customer's marketplace commit), and **inherited estates from M&A**. "Avoiding lock-in" alone is not a driver — the **abstraction tax** of building to the lowest common denominator (self-managed Postgres instead of Aurora/Spanner, Crossplane wrappers over everything, dual-cloud CI, two on-call rotations) commonly costs 20–30% of platform engineering capacity and forfeits exactly the managed services you're paying cloud premiums for. The cheaper hedge is a **documented exit plan**: open formats at persistence boundaries (Postgres wire, S3 API, Parquet/Iceberg, Kubernetes, OpenTelemetry), Terraform/OpenTofu with thin per-cloud modules rather than a fake-portable layer, and a yearly rehearsed restore of one real service on the second cloud. Run the **data-gravity math** before any split: cross-cloud egress runs ~$0.02–0.09/GB, so replicating 100TB/month costs roughly $2k–9k in transfer alone before latency and consistency pain — and the EU Data Act's free egress applies to *leaving*, not to steady-state replication. Rule: **Add a second cloud only when a named workload has a regulatory or unique-capability driver its owner will sign; if cross-cloud data transfer would exceed ~10% of that workload's compute bill, move the compute to the data instead.**

BAD: "We'll deploy everything on Kubernetes with a cloud-agnostic abstraction layer so we can switch providers anytime" (nobody ever switches; you pay the 20–30% tax forever, forfeit managed databases and queues, and the untested "switch" fails on data migration anyway). GOOD: "Primary cloud AWS; the EU banking workload runs on the sovereign region because DORA requires it; everything else uses native managed services, with an exit plan per service and one restore rehearsal a year."

```
MULTI-CLOUD VERDICT — [org/workload]
═══════════════════════════════════
Posture:       [single + exit plan | deliberate multi | accidental — consolidate]
Second cloud:  [name | none] · driver: [regulation | unique capability | M&A | NONE → reject]
Workload:      [named service] · owner: [team] · sign-off: [name]
Data gravity:  [TB/mo cross-cloud] × [$/GB] = [$X/mo] · [%] of workload compute bill
Abstraction:   [native per-cloud | LCD layer] · tax: [~% platform capacity]
Exit plan:     formats: [Postgres/S3-API/Iceberg/K8s/OTel] · est. exit: [eng-months + $egress]
Rehearsal:     last restore-on-second-cloud: [date | NEVER → portability unproven]
═══════════════════════════════════
```

Skip when: you're a startup pre-product-market-fit (pick one cloud, go all-in on managed services, revisit at scale) or the "multi-cloud" in question is just SaaS tools plus one IaaS provider — that's normal, not a strategy problem.

Gotchas: teams claim portability because they run Kubernetes while their state lives in DynamoDB, IAM, and SQS — portability is decided at the data and identity layer, not the compute layer; exit cost estimates always omit the people cost (retraining, dual runbooks, second on-call) which usually dwarfs egress; an unrehearsed exit plan is fiction — DORA auditors and your own incident will both find this out; and "we'll arbitrage spot prices across clouds" fails because committed-use discounts (Savings Plans, CUDs) reward concentration, so splitting spend raises your effective rate on both clouds.
