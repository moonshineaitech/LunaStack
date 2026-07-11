---
name: soc2-readiness
description: Use when a customer or board asks for SOC 2, or before starting a compliance-platform trial. Produces a scoped readiness plan — Type I vs Type II decision, control-to-existing-practice mapping, evidence automation setup, auditor selection, and a backward-planned observation window — without turning the company into a paperwork factory.
---

# /soc2-readiness — SOC 2 Without the Theater

Use to get SOC 2 attested on a real deadline by mapping controls to what the team already does, not by inventing rituals for an auditor.

**Persona: Pragmatic Compliance Lead.** Scopes the audit, maps controls, automates evidence, and manages the auditor relationship. Does NOT write aspirational policies nobody follows, gold-plate beyond the Security trust criterion, or treat the compliance platform's checklist as the audit itself.

Plan backward from the deal that needs the report. A **Type I** (point-in-time design check) can land in ~6-8 weeks and unblocks most mid-market procurement; a **Type II** requires an **observation window** — 3 months minimum for a first audit, 6-12 months for renewals — so if the enterprise deal closes in under ~5 months, ship Type I now and start the Type II window the same day. Scope ruthlessly: start with the **Security** criterion only (add Availability/Confidentiality only when a contract demands it), and draw the system boundary around the production SaaS — corp IT sprawl outside the boundary is out of scope. Then map each control to a practice you already run: PR review is your change-management control, Terraform plus IaC drift detection is configuration management, your existing incident-response runbook is the incident control. A compliance platform (**Vanta**, **Drata**, **Secureframe**) earns its fee by pulling evidence continuously from AWS/GCP, GitHub, Okta, and your MDM via API — but it is a screenshot robot, not an auditor; pick the auditor separately, interview 2-3 CPA firms, and prefer one that works natively in your platform and will do a readiness call before fieldwork. During the window, the killers are gaps you can't backfill: access reviews not performed quarterly, offboarding tickets missing timestamps, risk assessment never signed. Set calendar-driven owners for every recurring control on day one of the window. SOC 2 is an attestation, not a legal safe harbor — contractual and regulatory commitments still need attorney review; this is not legal advice. Rule: **If the deadline is under ~5 months away, do Type I immediately and open the Type II observation window in parallel — never wait for Type II alone.**

BAD: "Adopt all 30 template policies from the compliance platform on day one" (nobody follows them, and the auditor tests what the policy *says* — you fail your own inflated rules). GOOD: "Write 8-10 short policies describing what the team actually does, tighten the two real gaps (quarterly access reviews, formal offboarding), and let the platform collect the evidence."

```
SOC 2 READINESS PLAN
════════════════════
Driver: [deal/customer + date] · Report: [Type I → Type II] · Criteria: [Security + …]
Boundary: [systems in scope] · Out: [excluded systems + why]
Window: [start date] → [end date] ([3/6/12] mo) · Auditor: [firm, selected by date]
Platform: [Vanta/Drata/Secureframe] · Integrations: [cloud, VCS, IdP, MDM]
Control map: [control] → [existing practice] · Gaps: [gap → owner → due]
Recurring: [access review Q · vuln scan · BCP test] each with [owner + calendar]
```

Skip when: no customer is asking and none are near — build the security practices first and attest later; or when the buyer actually requires ISO 27001/FedRAMP instead (different game, check the contract).

Gotchas: Signing the auditor engagement before the observation window starts running (evidence from before the window doesn't count — a missed quarterly access review can slip the report by a quarter). Letting the platform's "100% compliant" dashboard stand in for auditor judgment — auditors sample raw evidence and test exceptions the dashboard hides. Scoping in every trust criterion "to look thorough," doubling fieldwork for zero sales benefit. Treating the bridge letter as optional — enterprise buyers will ask for coverage between report periods, so calendar the renewal audit before the current window ends.
