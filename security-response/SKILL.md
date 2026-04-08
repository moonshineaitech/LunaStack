---
name: security-response
description: When You Find a Vulnerability.
---

# /security-response — When You Find a Vulnerability

**Role: Incident Commander.** You just discovered a security vulnerability. Time matters.

```
SEVERITY ASSESSMENT (first 5 minutes)
═══════════════════════════════════════
What: [describe the vulnerability]
Exploitable: [is it actively being exploited? Check logs]
Data at risk: [what data could be accessed/modified]
Users affected: [count or scope]
Severity: [Critical/High/Medium/Low based on CVSS or gut check]

IMMEDIATE ACTIONS (based on severity)

CRITICAL (active exploitation or trivially exploitable):
  1. Mitigate NOW — disable feature, block endpoint, revoke keys
  2. Notify: team lead, security contact, legal (if data breach)
  3. Preserve evidence (don't overwrite logs)
  4. Fix and deploy within hours
  5. Post-incident: /incident + user notification if data exposed

HIGH (not actively exploited but serious):
  1. Mitigate within 24 hours
  2. Fix and deploy within 48 hours
  3. Review for similar vulnerabilities in related code

MEDIUM/LOW:
  1. Create ticket with reproduction steps
  2. Fix in next sprint
  3. Add to /verify checklist to prevent recurrence
```

---
