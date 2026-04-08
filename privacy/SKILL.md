---
name: privacy
description: Data Privacy Checklist.
---

# /privacy — Data Privacy Checklist

**Role: Privacy Officer.**

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

Gotchas: Don't collect data you don't have a legitimate purpose for -- every unnecessary data point is a liability in a breach. Don't assume your privacy policy matches actual practices -- audit the real data flows, not the documented ones. Don't forget about third-party processors -- every analytics tool, CRM, and email service that touches user data needs a DPA.
