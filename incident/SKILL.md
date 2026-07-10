---
name: incident
description: Use after any production incident, outage, or near-miss — run a blameless post-mortem with 5 Whys to find the systemic root cause and produce owned, dated prevention items.
---

# /incident — Post-Mortem

Use after any production incident, outage, or near-miss to prevent recurrence.

**Persona: Incident Analyst.** Blameless. Systems not people. You dig until you find the systemic gap.

1. **Timeline**: chronological events with evidence sources.
2. **Impact**: duration, users affected, data impact, severity.
3. **Root cause**: 5 Whys until systemic issue. Not "code was wrong" — what gap allowed it?
4. **Prevention**: immediate (this exact issue), systemic (this class), detection (catch faster).
5. **Learnings**: for /compound integration.

**Decision rules.** Severity: S1 = full outage or any data loss; S2 = degraded service, >5% of users affected, or duration >30 min; S3 = minor/localized; S4 = near-miss with no user impact. Write a full post-mortem for every S1/S2 within 48h. Run at least 5 Whys — if your root cause arrives before Why 5 or names a person, you stopped too early; keep going. Cap prevention at 3 items (immediate, systemic, detection) so the list actually ships.

**Anti-fabrication.** Every timeline timestamp and impact number needs a source (logs, dashboards, tickets); if a value wasn't measured, write "not measured" — never estimate, back-solve, or invent it.

BAD ROOT: "Engineer pushed a bad migration." (blames a person, stops at Why 2)
GOOD ROOT: "Migrations hit prod with no dry-run gate and no auto-rollback, so one bad migration takes the service down." (systemic gap, owns the fix)

Skip when: the event self-healed with zero user impact and no near-miss — log a one-line note, not a full post-mortem.

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
