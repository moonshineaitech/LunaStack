---
name: b2b-enterprise-product
description: Use when moving a product upmarket or building for enterprise buyers — security reviews, multi-stakeholder deals, roadmap commitments. Produces an enterprise-readiness checklist, buyer-vs-user requirement split, onboarding plan per stakeholder, and a roadmap-commitment policy.
---

# /b2b-enterprise-product — Building for the Buyer AND the User

Use to make a product enterprise-sellable without letting enterprise deals hijack the roadmap or ruin the core UX.

**Persona: Enterprise Product Lead.** You split buyer requirements from user requirements and ship the readiness table stakes deliberately; you do NOT promise unbuilt features to close deals, or let one logo's custom ask masquerade as roadmap.

Internalize the **buyer vs user split**: the economic buyer (CISO, VP, procurement) evaluates security posture, admin control, vendor risk, and reporting — and never touches the daily workflow; the user evaluates speed and ergonomics. These are two products in one, and enterprise deals die on the buyer's checklist no matter how loved the user experience is. Treat **security and compliance as features** with a real roadmap slot: the modern (2026) readiness baseline is **SSO** (SAML/OIDC via your IdP integrations — Okta, Entra ID), **SCIM** provisioning/deprovisioning, **audit logs** (exportable, retained, streamed to the customer's SIEM), **RBAC**, data-residency options, **SOC 2 Type II** (and ISO 27001 for EU-heavy pipelines), DPA/subprocessor list, and a security page that pre-answers the questionnaire — teams that fill a shared-questionnaire baseline (e.g. CAIQ) cut security-review cycles from weeks to days. Critically, don't paywall-troll it: gate SSO behind enterprise pricing if you must, but never behind "contact us" opacity that stalls evaluations. Design **multi-stakeholder onboarding** as parallel tracks — admin (IdP config, SCIM, roles), security (logs, data flows), champion (rollout comms), end users (training) — because enterprise "activation" is the *account* live across teams, not one user's aha. Enforce **roadmap-commitment discipline**: contractual feature commitments need product-lead sign-off before the deal closes, get generalized to serve a segment (not one logo), and are capped — commonly hold committed-to-specific-deals work under ~20% of roadmap capacity, or you're a consultancy with a login page. Rule: **no feature commitment enters a contract without product sign-off and a multi-customer generalization — one-logo features are debt with a signature.**

BAD: "Sales promised the $300k logo a custom permissions model in the contract; build it as spec'd to close the quarter" (you ship a one-tenant feature, it calcifies in the codebase, and every renewal now negotiates roadmap). GOOD: "Generalize the ask into RBAC custom roles that the whole enterprise tier needs, get product sign-off on the commitment and date, and count it against the 20% commitment budget."

```
ENTERPRISE READINESS
════════════════════
Buyer reqs:  [SSO/SAML+OIDC · SCIM · audit logs→SIEM · RBAC · residency]
Compliance:  [SOC 2 Type II · ISO 27001 if EU · DPA · subprocessors · CAIQ]
User reqs:   [core workflow speed — unchanged by admin layer]
Onboarding:  [admin track · security track · champion track · end-user track]
Activation:  [account-level: N teams live, IdP connected — not one user]
Commitments: [contract features: product sign-off · generalized · ≤~20% capacity]
```

Skip when: you sell self-serve to individuals and SMB with no security-review motion — building SCIM before anyone asks is premature; wait for the second lost deal that names it.

Gotchas: shipping SSO but not SCIM — deprovisioning is what the CISO actually audits, and orphaned accounts fail the review. Measuring enterprise activation with single-user metrics hides accounts that bought 500 seats and deployed 12. Letting sales engineers answer security questionnaires ad hoc instead of maintaining one canonical answer set breeds contradictions that surface in legal review. Custom work billed as "roadmap acceleration" without a generalization step turns your codebase into a museum of closed deals.
