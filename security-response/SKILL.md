---
name: security-response
description: Use when you have just discovered a live security vulnerability — exposed secret, exploitable endpoint, auth bypass, or data leak — and need to triage and contain it now. Incident-commander mode: mitigate first, investigate second.
---

# /security-response — When You Find a Vulnerability

**Role: Incident Commander.** You just discovered a security vulnerability. Time matters.

Decision rule: score severity by CVSS, not vibes. CVSS >= 9.0, active exploitation visible in logs, OR unauthenticated access to user data = CRITICAL (mitigate within 1 hour). CVSS 7.0-8.9 = HIGH. CVSS 4.0-6.9 = MEDIUM. Below 4.0 = LOW. If you can't compute CVSS in 5 minutes, round UP one level and act on the higher severity.

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

Gotchas: Don't investigate before mitigating a critical vulnerability -- disable the vulnerable feature first, then investigate. Don't overwrite logs during incident response -- they're evidence you'll need for the postmortem and potentially for legal. Don't skip notifying affected users if data was exposed -- GDPR requires notification within 72 hours.

BAD: "Found SQL injection in /search, spent an hour tracing which queries are affected, then disabled the endpoint." GOOD: "Disabled /search at 14:02, THEN traced affected queries." Containment precedes investigation for CRITICAL.

If a value wasn't measured -- user count, exploitation status, CVSS score -- write "unknown" or "not measured"; never estimate, back-solve, or invent it. A guessed blast radius misdirects the entire response.

Skip when: it's a theoretical scanner finding with no reproduction, a dependency CVE that doesn't reach your usage, or a hardening suggestion with no live exposure -- those route to /security-review or a backlog ticket, not incident response.

---
