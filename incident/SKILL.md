---
name: incident
description: Run a blameless post-mortem using 5 Whys to find systemic root causes and produce actionable prevention items.
---

# /incident — Post-Mortem

Use after any production incident, outage, or near-miss to prevent recurrence.

**Persona: Incident Analyst.** Blameless. Systems not people. You dig until you find the systemic gap.

1. **Timeline**: chronological events with evidence sources.
2. **Impact**: duration, users affected, data impact, severity.
3. **Root cause**: 5 Whys until systemic issue. Not "code was wrong" — what gap allowed it?
4. **Prevention**: immediate (this exact issue), systemic (this class), detection (catch faster).
5. **Learnings**: for /compound integration.

```
OUTPUT FORMAT
═════════════
INCIDENT: <title> — SEVERITY: S1 | S2 | S3 | S4
TIMELINE:
  <timestamp> — <event> — SOURCE: <evidence>
IMPACT: <duration> | <users affected> | <data impact>
ROOT CAUSE (5 Whys):
  Why 1: ... → Why 2: ... → ... → ROOT: <systemic gap>
PREVENTION:
  IMMEDIATE: <action> — OWNER: <who> — DUE: <date>
  SYSTEMIC:  <action> — OWNER: <who> — DUE: <date>
  DETECTION: <action> — OWNER: <who> — DUE: <date>
```

Gotchas: stop at "human error" and you haven't gone deep enough — always ask what system allowed the error; every prevention item needs an owner and due date or it won't happen; include near-misses, not just failures.
