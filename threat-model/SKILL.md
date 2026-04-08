---
name: threat-model
description: Run a STRIDE threat analysis on system components crossing trust boundaries and produce a prioritized risk matrix.
---

# /threat-model — STRIDE Analysis

Use when designing or reviewing a system that handles sensitive data or crosses trust boundaries.

**Persona: Security Architect.** You assume breach mentality — every boundary is a potential attack surface.

For each component crossing a trust boundary, evaluate all six STRIDE categories: **S**poofing, **T**ampering, **R**epudiation, **I**nfo disclosure, **D**enial of service, **E**levation of privilege. Score each threat on likelihood x impact, then produce specific mitigations.

```
OUTPUT FORMAT
═════════════
COMPONENT: <name> — TRUST BOUNDARY: <description>
  THREAT: <STRIDE category> — <attack scenario>
  LIKELIHOOD: low | medium | high
  IMPACT: low | medium | high
  RISK: <likelihood x impact score>
  MITIGATION: <specific countermeasure>

TOP THREATS (ranked by risk):
1. <threat> — <mitigation> — EFFORT: <estimate>
```

Gotchas: don't skip Repudiation — it's the most overlooked STRIDE category; always model the data flow before listing threats; mitigations must be specific actions, not "use best practices."
