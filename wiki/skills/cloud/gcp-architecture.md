---
name: gcp-architecture
description: Use when designing or reviewing Google Cloud infrastructure and you want secure, cost-aware, well-architected choices. Produces a review against common GCP traps.
---

# /gcp-architecture — Well-Architected GCP

Use when designing GCP infrastructure or reviewing a project for risk and cost.

**Persona: GCP Cloud Architect.** You use the resource hierarchy and IAM as designed, and you keep an eye on egress and idle spend.

Use the **resource hierarchy** (Organization → Folders → Projects) to isolate environments and scope policy; one project per app/environment limits blast radius. **IAM least privilege**: grant predefined/custom roles at the narrowest scope; avoid `Owner`/`Editor` on service accounts, and prefer **Workload Identity Federation** over downloaded service-account keys (static keys are a top leak vector). Use **regional/multi-regional** resources for availability; deploy across zones. Cost watch: **network egress** (especially inter-region and to the internet), idle Compute Engine instances, and un-lifecycled Cloud Storage — set budgets + alerts, use committed-use discounts for steady load. Prefer managed services (Cloud Run, Cloud SQL, Pub/Sub, BigQuery) over self-managed VMs. Enable VPC Service Controls for sensitive data, private Google access, and CMEK where compliance needs it. Keep Cloud Storage buckets private (uniform bucket-level access, no `allUsers`). Turn on Security Command Center + audit logs.

BAD: a service account with `Editor` and a downloaded JSON key committed near the code, public GCS bucket, all resources in one prod project mixed with dev — over-permissioned, leaky, no isolation. GOOD: Workload Identity Federation (no keys), scoped custom role, private buckets, separate projects per env, budgets + SCC on.

```
GCP REVIEW
══════════
□ Resource hierarchy: project per app/env (blast-radius isolation)
□ IAM least privilege; no Owner/Editor on SAs
□ Workload Identity Federation over downloaded SA keys
□ Regional/multi-zone for availability
□ Cost: egress/idle/storage watched; budgets + alerts; CUDs
□ Managed services over self-managed VMs
□ Private buckets (uniform access, no allUsers); SCC + audit logs on
```

Skip when: a tiny hobby project where a single managed service suffices.

Gotchas: downloaded service-account keys are a top leak vector — use Workload Identity Federation. `Editor`/`Owner` on service accounts massively over-permissions them. Public GCS buckets (`allUsers`) leak data — enforce uniform bucket-level access.
