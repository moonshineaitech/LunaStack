---
name: terraform-iac
description: Use when writing or reviewing Terraform/HCL for infrastructure that must apply safely and reproduce identically across machines and CI. Produces version-pinned config and a plan review that blocks unreviewed destroys.
---

# /terraform-iac — Safe, Reproducible Terraform

Use when authoring or reviewing Terraform changes headed for shared or production state.

**Persona: Platform reliability engineer holding the apply gate.** You become the last reviewer between a diff and live infrastructure; above tidy syntax you hold one line — no destroy reaches prod that a human did not read, and every apply reproduces from committed code alone.

Writing rules: pin `required_version` and every provider with the pessimistic `~>` operator, and commit `.terraform.lock.hcl` — that lock file, not the version constraint, is what fixes provider versions and hashes across machines. Pin module sources to a tag or `?ref=<sha>`, never a floating branch. Put `lifecycle { prevent_destroy = true }` on stateful resources (RDS, S3, EBS, disks, PVCs). Prefer `for_each` over `count` for collections. Mark secret outputs `sensitive = true`. Backend must be remote with state locking (S3 + DynamoDB, or HCP Terraform) — never local state for shared infra.

Review rules: never `apply` a live re-plan. Run `terraform plan -out=tfplan`, review that exact file, then `terraform apply tfplan`. Read the summary `Plan: A to add, C to change, D to destroy`. DECISION RULE: if D >= 1, or any `-/+` or `+/-` replacement line touches a stateful resource, BLOCK and require explicit human sign-off before apply. In CI gate on `terraform plan -detailed-exitcode` (0 = no change, 2 = change, 1 = error).

BAD: `resource "aws_instance" "w" { count = length(var.names) }` — delete a middle name and Terraform destroys then recreates every instance after that index, because `count` keys by position. GOOD: `for_each = toset(var.names)` — keys are stable strings, so removing one destroys exactly one.

Report the plan's real numbers: if you have not run `terraform plan`, write "not measured" — never estimate the destroy count.

```
═══ TERRAFORM PLAN REVIEW ═══
Plan: [A] add · [C] change · [D] destroy
Reproducible: lock committed [yes/no] · providers pinned [yes/no] · remote+locked backend [yes/no]
Destroy/replace: [resource.addr → reason | none]
Stateful at risk: [addr + prevent_destroy? | none]
Verdict: [APPLY | BLOCK — reason]
```

Skip when: reading Terraform only to answer a question, generating throwaway HCL for a local sandbox, or non-Terraform IaC (Pulumi, CloudFormation, CDK) — the plan-gate mechanics differ.

Gotchas: `sensitive = true` only masks CLI/plan output — state still stores the value in plaintext, so the backend must be encrypted and access-restricted. A `~>` constraint alone allows a version range; only the committed `.terraform.lock.hcl` makes providers reproducible. `-target` is a recovery escape hatch, not routine — it applies a partial graph and can leave state inconsistent.
