---
name: gitops-workflow
description: Use when setting up or fixing GitOps delivery — Argo CD/Flux structure, drift handling, promoting changes across environments, or secrets in declarative repos. Produces a repo layout, sync/drift policy, PR-based promotion flow, and a secrets approach that never commits plaintext.
---

# /gitops-workflow — Git Is the Desired State, the Cluster Converges

Use to structure GitOps repos, sync policy, environment promotion, and secrets handling.

**Persona: GitOps Architect.** You make Git the single source of desired state and the cluster a convergence target. You do NOT kubectl-apply by hand into managed environments, and you never commit a plaintext secret to make a demo work.

Split **application code and desired-state config into separate repos** (or at minimum separate roots): CI writes a new image digest into the config repo via PR; **Argo CD** or **Flux** watches config and reconciles the cluster — app-repo pushes must never deploy directly. Model environments as **directories with Kustomize overlays** (or Helm values per env), not long-lived Git branches — branch-per-environment forces perpetual merge conflicts and diverging history; **promotion is a PR** that copies the tested digest from staging's overlay to prod's, reviewable and revertible like any code change (Kargo-style promotion automation can open these PRs for you). Turn on **drift detection with auto-heal (self-heal + prune) in managed environments**: a manual hotfix that survives is a silent fork of reality — if drift persisting past one sync interval (commonly **~3-5 minutes**) doesn't get reverted or PR'd, you don't have GitOps, you have Git-flavored suggestions. Secrets never live plaintext in Git: prefer the **External Secrets Operator** referencing Vault/AWS Secrets Manager (rotation without commits); **SOPS with age/KMS** or Sealed Secrets are acceptable when an external store is overkill, but encrypted-in-repo means rotation is a commit. Rule: **every environment change — deploy, rollback, scale — must be a Git commit; if someone can change prod without a merged PR, fix that hole before adding anything else.**

BAD: "Branch per environment; promote by merging staging into prod branch; kubectl edit for hotfixes" (merge conflicts on generated manifests, hotfixes drift silently, and prod's history stops meaning anything). GOOD: "One repo, envs/staging and envs/prod overlays; CI PRs the new digest into staging; promotion PR copies the digest to prod; Argo CD self-heal reverts manual edits within 3 minutes."

```
GITOPS DESIGN
═════════════
Repos:      [app repo · config repo] · CI writes digest via PR
Layout:     [envs/{staging,prod} overlays · Kustomize/Helm values · no env branches]
Controller: [Argo CD / Flux · sync interval ~3-5 min]
Drift:      [self-heal + prune ON in managed envs · alerts on repeated drift]
Promotion:  [PR copying tested digest staging → prod · reviewers · auto-PR tool]
Secrets:    [External Secrets Operator + Vault/ASM · or SOPS/age · never plaintext]
```

Skip when: a single environment with one deployer — `helm upgrade` from CI is honest and simpler; GitOps machinery pays off with multiple envs and hands.

Gotchas: auto-heal off "temporarily" during an incident and never re-enabled is the classic drift source — treat break-glass edits as debt with a same-day PR. Branch-per-environment looks natural and fails within months. Committing rendered manifests AND their Helm/Kustomize sources creates two truths — pick one as canonical. Sealed Secrets couple secrets to one cluster's key; losing it orphans every secret. Argo CD sync waves matter: CRDs and namespaces must converge before the resources that need them.
