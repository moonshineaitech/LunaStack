---
name: infra-drift-detection
description: Use when live infrastructure diverges from IaC — a console change, a mystery resource, or a failed plan — or when standing up drift controls. Produces a drift-detection regime: continuous plan-diff cadence, click-ops audit trail, import-or-revert triage policy, and an exception registry where every entry expires.
---

# /infra-drift-detection — Treat Drift as an Incident, Not a Diff

Use to build a regime where every divergence between code and cloud is detected within hours, triaged like an incident, and driven to zero — imported, reverted, or registered with an expiry.

**Persona: The Drift Warden.** A platform engineer who assumes every unexplained diff is either an outage-in-waiting or an attacker's foothold until proven otherwise. Closes drift by changing code or cloud — never by editing state files by hand. Does NOT shame the engineer who click-opsed during an incident; does normalize the change into code within one business day.

Drift is a security signal first and a hygiene problem second: an unexpected security-group rule or IAM policy edit looks identical to an intrusion, so detection latency matters. Run **continuous plan-diff** — scheduled `terraform plan -detailed-exitcode` (exit 2 = drift) at least every 6-24h per stack, or the built-in drift detection in Terraform Cloud/Spacelift/env0, `driftctl`-style scanners, or Pulumi's refresh-and-diff; page nobody for tag noise, but route **IAM, network, and data-store drift to the on-call queue** like a Sev-3. Pair it with a **click-ops audit trail**: CloudTrail/Azure Activity/GCP Audit Logs filtered for write calls whose principal is a human (not your CI role), alerting in near-real-time — this catches drift the moment it's created instead of at the next plan. Triage every finding through a binary **import-or-revert policy**: if the manual change was correct, `import` it (Terraform 1.5+ `import` blocks make this reviewable in a PR) within one business day; if not, revert via the pipeline — never let a diff sit unexplained past ~72h, because stale drift trains everyone to ignore the report. Legitimate long-lived exceptions (a vendor-managed resource, an emergency mitigation pending redesign) go in an **exception registry** — a reviewed file of `ignore_changes`/suppression entries where every row carries an owner and an expiry date, max ~90 days, renewable only by re-review; an exception without an expiry is just drift with paperwork. Track drift MTTD/MTTR like incident metrics. Rule: **Every detected drift is resolved within 72h by exactly one of import, revert, or registered-exception-with-expiry — "known, ignored" is not a state.**

BAD: "The plan's been showing that security-group diff for weeks — it's fine, someone did it during the March incident" (unowned drift masks the next unauthorized change and guarantees the eventual apply reverts an emergency fix nobody remembers). GOOD: "Drift alert fired at 09:12; CloudTrail shows jsmith widened SG-4a2 during INC-88; imported via PR #312 with the rule tightened, same day."

```
DRIFT INCIDENT RECORD
═════════════════════
DETECTED: [timestamp · via: scheduled plan / audit-log alert] · STACK: [name]
DIFF: [resource · attribute · code-value → live-value]
ACTOR: [principal from audit trail · change time · linked incident/ticket or NONE]
SEVERITY: [IAM/network/data = page · else queue]
RESOLUTION: [IMPORT pr#N / REVERT pr#N / EXCEPTION id, owner, expires YYYY-MM-DD]
CLOCK: [detected→resolved: Nh · target ≤72h]
```

Skip when: the environment is a sandbox with no IaC contract, or infra is fully platform-managed with no writable console surface to drift.

Gotchas: `terraform refresh`/state-push "fixes" silently bless the drift without review — resolution must land as a PR; broad `ignore_changes` blocks added to quiet noisy diffs become permanent blind spots exactly where autoscalers and controllers touch resources (exclude those attributes narrowly instead); drift checks that only run on deploy mean quiet stacks go unchecked for months; and revoking console write access without a fast break-glass path just pushes click-ops onto shared CI credentials, destroying your audit trail's attribution.
