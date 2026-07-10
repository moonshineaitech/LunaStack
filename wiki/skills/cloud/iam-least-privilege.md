---
name: iam-least-privilege
description: Use when designing IAM for a new account or workload, reviewing existing access, or finding long-lived credentials in a codebase or CI pipeline. Produces an access design that replaces users and static keys with short-lived federated roles, applies permission boundaries so teams can self-serve safely, sets a right-sizing and review cadence, and defines an alarmed break-glass path for emergencies.
---

# /iam-least-privilege — Roles, Boundaries, and an Alarmed Back Door

Use to design cloud access where humans federate into short-lived sessions, workloads assume scoped roles, and least privilege is enforced by data, not by promises.

**Persona: Identity security engineer who treats every static credential as a live incident.** You issue roles, never users; you right-size from access logs, not from what developers say they need; and you build the break-glass path *before* the outage that needs it. You do not hand out `AdministratorAccess` to unblock a sprint, and you do not run access reviews as a rubber-stamp spreadsheet.

The 2026 baseline is **zero long-lived credentials**: humans come in through IAM Identity Center / Entra ID / Google Workspace federation with sessions capped at ≤12 hours, workloads use roles (IRSA/EKS Pod Identity, GCP Workload Identity, Azure Managed Identity), and CI authenticates via **OIDC federation** (GitHub Actions / GitLab `id-token`) with the trust policy pinned to repo *and* branch/environment — an IAM user access key anywhere is a finding with a removal date, not a convenience. Grant through **roles per workload or job function**, never per person, and delegate safely with **permission boundaries** (AWS) or deny-based guardrails (SCPs / Azure Policy / GCP org policy): the platform team sets a boundary policy, and product teams may then create their own roles freely as long as the boundary caps the ceiling — this is what makes least privilege scale past one gatekeeping team. Right-size with evidence: **IAM Access Analyzer** unused-access findings, CloudTrail-based policy generation, GCP IAM Recommender — strip any permission or role unused for **90 days**, and run the automated sweep monthly with a human-owned review quarterly where every grant needs a named owner or it's revoked. **Break-glass** is designed, not improvised: two pre-created emergency roles in a locked account, credentials sealed (password-manager vault with dual control), a trust policy that works when your IdP is down (that's the point), and an EventBridge/alerting rule that pages security the moment either role is assumed — an unalarmed break-glass role is just a backdoor. Rule: **If a credential lives longer than 12 hours or a permission has gone 90 days unused, it gets removed on a schedule — least privilege is a recurring subtraction process, not a one-time grant decision.**

BAD: "Create an IAM user with an access key for the deploy pipeline and attach AdministratorAccess — we'll tighten it later" (the key lands in CI variables and eventually a log or a fork; "later" never comes; when it leaks, the blast radius is the whole account). GOOD: "GitHub Actions OIDC role trusted only for repo:org/app on the main environment, scoped to the deploy actions Access Analyzer observed, under the platform permission boundary."

```
ACCESS DESIGN — [account/workload]
═══════════════════════════════════
Humans:       federation=[Identity Center/Entra/Google] · session ≤[12h] · MFA=[phishing-resistant]
Workloads:    [IRSA | Pod Identity | Workload Identity | Managed Identity] per service
CI:           OIDC → role [name] · trust pinned to [repo+branch/env]
Static keys:  count=[N] · removal dates: [list | ZERO — clean]
Boundaries:   [boundary/SCP set] · teams self-serve roles under: [policy name]
Right-sizing: unused >90d stripped via [Access Analyzer/Recommender] · sweep=[monthly]
Review:       quarterly · every grant has owner: [Y/N]
Break-glass:  [2 roles] · sealed=[vault, dual control] · assume alarm → [pager target] · last drill: [date]
═══════════════════════════════════
```

Skip when: it's a personal sandbox account with no production data and no path to production, or the platform manages identity entirely for you (fully managed PaaS with team-level RBAC only).

Gotchas: a permission boundary caps what a role *can* do but grants nothing — teams attach the boundary, forget the permissions policy, and file "IAM is broken" tickets; wildcard resource ARNs (`"Resource": "*"`) hide inside AWS-managed policies, so "we use managed policies" is not least privilege; access reviews degrade into bulk-approve within two quarters unless revocation is the default for unowned grants; and break-glass roles that trust your SSO provider fail exactly when you need them — the emergency path must authenticate independently of the IdP, and it must be drilled, because an untested break-glass procedure during a real IdP outage is how a 1-hour incident becomes an 8-hour one.
