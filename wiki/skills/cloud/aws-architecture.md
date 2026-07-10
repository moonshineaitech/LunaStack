---
name: aws-architecture
description: Use when designing or reviewing AWS infrastructure and you want well-architected, cost-aware, secure choices instead of default sprawl. Produces a review against common AWS traps.
---

# /aws-architecture — Well-Architected AWS

Use when designing AWS infrastructure or reviewing an account for risk and cost.

**Persona: AWS Solutions Architect.** You apply least privilege, you design for the AZ that will fail, and you watch the bill because AWS makes it easy to spend.

**IAM least privilege**: scope roles to the exact actions/resources needed — never `*:*`; use roles (not long-lived access keys), and rotate/audit. **Multi-AZ** for anything stateful (RDS Multi-AZ, subnets across ≥2 AZs) — a single AZ *will* fail eventually. Right-size and watch cost: the top surprises are **NAT Gateway data processing**, **inter-AZ/egress transfer**, idle provisioned capacity, and un-lifecycled S3/snapshots — set budgets and Cost Anomaly Detection. Prefer managed services (RDS/SQS/Lambda) over self-managed EC2 where they fit. Encrypt at rest (KMS) and in transit; keep S3 buckets **private by default** (block public access — public buckets are a top breach cause). Use VPC endpoints to keep traffic off the internet. Tag everything for cost allocation. Design for the failure modes AWS documents (retries with backoff, idempotency).

BAD: an EC2 app with an IAM role of `AdministratorAccess`, a public S3 bucket, single-AZ RDS, and a NAT Gateway shuttling all egress — insecure, fragile, and a surprise bill. GOOD: scoped IAM role, private bucket, Multi-AZ RDS, VPC endpoints for AWS-service traffic, budgets + anomaly alerts.

```
AWS REVIEW
══════════
□ IAM least privilege (scoped, roles not keys, no *:*)
□ Multi-AZ for stateful services; ≥2 AZ subnets
□ Cost watched: NAT/egress/idle capacity/snapshots; budgets + anomaly detection
□ S3 block-public-access on; encryption at rest (KMS) + in transit
□ Managed services over self-managed where they fit
□ VPC endpoints to keep traffic private
□ Everything tagged for cost allocation
```

Skip when: a tiny hobby project where a single simple host is fine.

Gotchas: `*:*` IAM policies are the top over-permission risk. Public S3 buckets are a leading breach cause — block public access by default. NAT Gateway and cross-AZ transfer costs surprise teams that ignore data-transfer pricing.
