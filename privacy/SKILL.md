---
name: privacy
description: Use when a feature collects, stores, or shares user data, or before launching anything that touches personal, financial, or sensitive information. Audits the real data flows against GDPR/CCPA/COPPA obligations.
---

# /privacy — Data Privacy Checklist

**Role: Privacy Officer.**

Skip when: the change touches no personal data — a pure-internal script, a UI copy tweak, or reading data already cleared by a prior audit within the last quarter.

Decision rule: any sensitive field (health, religion, ethnicity, biometric, precise geolocation, under-13 identity) with no explicit legal basis is a CRITICAL, and any personal data retained past 24 months with no documented reason is a CRITICAL — one CRITICAL blocks launch. Any third-party processor without a signed DPA is a hard blocker on its own.

BAD: "We're GDPR-compliant, we have a privacy policy." GOOD: "Signup logs email + IP, stored in Supabase eu-west-1, 14-month retention, deletable via /account/delete; Stripe holds card data under a signed DPA."

```
DATA PRIVACY AUDIT
══════════════════
WHAT DATA WE COLLECT
  Personal: [name, email, phone, address, etc.]
  Behavioral: [page views, clicks, search queries, etc.]
  Financial: [payment info — how stored, by whom]
  Sensitive: [health, religion, ethnicity, biometric — requires extra care]

FOR EACH DATA POINT
  □ Why we collect it (legitimate purpose)
  □ Where it's stored (which database, which region)
  □ Who has access (which team members, which services)
  □ How long we keep it (retention policy)
  □ How to delete it (user request workflow)
  □ Encrypted at rest and in transit?

COMPLIANCE
  □ Privacy policy exists and is current
  □ Cookie consent banner (for EU users)
  □ Data export available (right to portability)
  □ Account deletion available (right to erasure)
  □ Data Processing Agreements with all third-party processors
  □ Breach notification plan (72 hours for GDPR)
  □ Children's data? (COPPA if under 13)
```

For every field above — storage region, retention period, access list — if you did not verify it against the real system, write "not verified"; never assume a region, a duration, or who has access.

Gotchas: Don't collect data you don't have a legitimate purpose for -- every unnecessary data point is a liability in a breach. Don't assume your privacy policy matches actual practices -- audit the real data flows, not the documented ones. Don't forget about third-party processors -- every analytics tool, CRM, and email service that touches user data needs a DPA.
