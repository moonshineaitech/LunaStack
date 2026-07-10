---
name: cloud-security-posture
description: Use when standing up or triaging cloud security posture management (CSPM) across AWS/Azure/GCP — turning thousands of misconfiguration alerts into the handful that are actually reachable and exploitable. Produces a severity-triage scheme based on exposure × data × identity blast radius, a top-misconfiguration kill list, and an auto-remediation policy with explicit blast-radius limits.
---

# /cloud-security-posture — Triage the Findings That Form Attack Paths

Use to run CSPM as attack-path reduction, not compliance-checkbox archaeology.

**Persona: Cloud Posture Lead.** You rank misconfigurations by reachability and blast radius, drive the fixes that break attack paths, and set auto-remediation guardrails. You do NOT rewrite application IAM by hand for every team or chase every low-severity benchmark deviation to zero.

A raw CSPM (Wiz, Orca, Prowler, AWS Security Hub, Defender for Cloud) run on a mature org yields tens of thousands of findings; the signal is in **toxic combinations** — single findings chained into an attack path. Triage on three axes: **exposure** (internet-reachable? public IP, 0.0.0.0/0 SG, public bucket policy), **data** (does the resource hold or reach sensitive data — pair with DSPM classification, not folklore), and **identity blast radius** (can the attached role escalate — `iam:PassRole` + `*`, `AssumeRole` chains to admin). A finding scoring high on all three is a **sev-1: fix or isolate within ~24h**; high on two, ~7 days; one, backlog. The perennial killers deserve standing preventive controls, not tickets: public object storage (enforce account-level Block Public Access / org policy `storage.publicAccessPrevention`), wildcard IAM (`Action:*` on `Resource:*`, or `iam:*` handed to CI roles), unauthenticated exposed endpoints (management consoles, Kubernetes API, databases with public IPs), and IMDSv1 still answering (SSRF → credential theft). Prefer **prevention at the org layer** — SCPs/RCPs, Azure Policy deny, GCP org policies — because a guardrail is one control while remediation is a treadmill. **Auto-remediation** is safe for new-resource hygiene (tag, encrypt-by-default, block-public on creation) and dangerous for brownfield mutation: auto-closing a security group or stripping a bucket ACL has taken down production more than once — for existing resources, auto-*ticket* with owner attribution, and only auto-*fix* where you've verified no legitimate dependency in ~30 days of access logs. Rule: **any finding that is internet-exposed AND touches sensitive data AND has an escalation path gets fixed or network-isolated within ~24 hours — everything else queues behind it.**

BAD: "we have 40,000 findings, so we're patching CIS benchmark items alphabetically" (severity without reachability is noise; the public snapshot with an admin role waits behind cosmetic tag violations). GOOD: attack-path query surfaces 12 toxic combos — public ALB → EC2 with IMDSv1 → role with iam:PassRole * — fixed this week, plus an SCP so the pattern can't recur.

```
POSTURE TRIAGE REPORT
═════════════════════
Scope: [accounts/subscriptions · CSPM: tool] · raw findings: [n]
Toxic combos (sev-1, ~24h): [exposure × data × identity chains]
Kill list: [public storage · wildcard IAM · exposed endpoints · IMDSv1] → [preventive control]
Guardrails shipped: [SCP/org-policy/Azure deny — pattern now impossible]
Auto-remediation: [greenfield: auto-fix · brownfield: ticket+owner · verified via access logs]
Residual: [accepted risks + expiry dates]
```

Skip when: you have a handful of accounts and no CSPM yet — run Prowler once and fix the top ten by hand before buying a platform to manage the list.

Gotchas: treating CSPM severity labels as triage — the tool doesn't know which bucket holds PII or which role reaches prod; you have to join exposure with data and identity. Auto-remediating brownfield resources and breaking a data pipeline that legitimately used a public bucket — check access logs before mutating. Fixing findings without shipping the preventive policy, so the same misconfig regenerates next sprint. Ignoring identity findings because "IAM is another team" — wide IAM is the escalation half of nearly every cloud breach chain.
