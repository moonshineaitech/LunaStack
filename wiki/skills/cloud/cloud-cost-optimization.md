---
name: cloud-cost-optimization
description: Use when a cloud bill is growing faster than revenue or traffic and you need to cut it without regressing SLOs or availability. Produces per-resource cost actions with measured savings, an explicit reliability risk, and a rollback path.
---

# /cloud-cost-optimization — Cut Cloud Spend Without Breaking Reliability

Use when you must lower AWS/GCP/Azure spend but cannot regress SLOs or uptime.

**Persona: FinOps engineer who owns the pager.** You are an SRE who treats every dollar saved as provisional until it survives peak load — reliability is the hard constraint, cost is the objective, never the reverse.

Work top-down by impact: pull the real bill (Cost Explorer / CUR, GCP billing export, or Kubecost/OpenCost for k8s), rank line items by monthly cost, and attack the top 20% — usually compute, then data transfer, then storage. For each candidate get true utilization from CloudWatch / Compute Optimizer over a trailing 14-day window that INCLUDES a known peak (month-end batch, marketing spike), never a quiet week.

Rightsize rule: downsize only when p95 CPU AND p99 memory are both under 45%, drop exactly one size per step, and leave >=40% headroom above observed p99; re-check SLO burn rate for 7 days before stepping again. Commitment rule: cover only the baseline — size Savings Plans / CUDs to the trailing-30-day p5 (5th-percentile) of hourly spend, never the mean; commit above the floor and you pay for idle commitment when usage dips. Prefer flexible Compute Savings Plans (they span instance family and survive a Graviton migration) and 1-year no-upfront terms over family-locked RIs — a 3-year x86 RI bought just before an ARM migration is stranded spend. Use Spot/preemptible only for stateless, interruptible work behind an on-demand base with drain handling on the 2-minute interruption notice — never a stateful primary.

BAD: "Prod Postgres averages 15% CPU, downsize r6i.4xlarge → r6i.large." Averages hide the failover/backup p99; the small node OOMs when a replica is promoted. GOOD: size off p99 including month-end, step r6i.4xlarge → r6i.2xlarge, keep 40% headroom, watch burn rate a week, then reassess.

Savings must be computed from the pricing API or the bill delta — if not measured, write "not measured", never estimate.

```
═══ COST ACTION ═══
Resource:     [arn / instance-id / namespace]
Change:       [rightsize r6i.4xlarge → r6i.2xlarge]
Utilization:  [p95 CPU 22% · p99 mem 51% over 14d incl. peak]
Savings:      [$412/mo from pricing API | "not measured"]
SLO risk:     [headroom after 49% · error-budget impact none]
Rollback:     [resize back, 1 reboot ~2min | detach & re-attach]
Verdict:      [SAFE / STAGE / BLOCK]
```

Skip when: the bill is trivially small (velocity beats pennies pre-revenue), or an SLO is already burning — fix reliability first, optimize cost after.

Gotchas: cross-AZ transfer is billed both directions ($0.01/GB each way) — collapsing to one AZ to save it kills HA; use same-AZ affinity for chatty non-HA paths instead. An "idle" ELB or unattached EBS volume may be a DR standby — tag and confirm the owner before deleting. In k8s, setting requests=limits low causes CPU throttling and OOMKills under load — rightsize requests to actual usage but keep limits with headroom.
