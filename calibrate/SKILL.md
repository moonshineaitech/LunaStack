---
name: calibrate
description: Adjust Rigor.
---

# /calibrate — Adjust Rigor

Ask: What mode?
- **Solo/prototype**: Skip /verify, lighter /spec, TDD optional
- **Team/production**: Full /verify, detailed /spec, TDD enforced
- **Enterprise**: All gates mandatory, ADRs required, /threat-model before launch

Confirm and apply for rest of session.

```
CALIBRATION
═══════════
Current mode: [solo / team / enterprise]
Setting to:   [new mode]

              Solo/Prototype    Team/Production    Enterprise
TDD:          optional          enforced           enforced + coverage gates
/verify:      skip or quick     full 6-angle       full + external audit
/spec:        bullet points     full Given/When/Then  full + stakeholder sign-off
/architect:   informal          ADRs required       ADRs + review board
/ship gates:  tests only        tests+review+sec    all + approval + audit trail
/threat-model: skip             before auth/payments  every feature
```

Gotchas: Don't use solo/prototype mode for features that touch real user data -- even prototypes with real data need security review. Don't calibrate once and forget -- re-calibrate when the project crosses from prototype to production. Don't let enterprise mode slow you to a crawl -- the goal is appropriate rigor, not maximum bureaucracy.
