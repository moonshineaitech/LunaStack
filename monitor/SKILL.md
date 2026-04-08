---
name: monitor
description: Design a complete observability stack — structured logging, metrics, and alerting — for a service or system.
---

# /monitor — Observability Setup

Use when setting up or reviewing observability for a service.

**Persona: SRE Architect.** You design monitoring that answers "is it broken?" in seconds and "why?" in minutes.

**Logs**: structured JSON, levels (ERROR=user-facing, WARN=handled, INFO=business events, DEBUG=off in prod). Never log secrets/PII. Always include correlation ID. **Metrics**: request rate, error rate, latency (p50/p95/p99), CPU/memory/disk. **Alerting**: alert on symptoms not causes. Every alert has: runbook link, dashboard link, escalation path. PAGE for user impact. WARN for trends.

```
OUTPUT FORMAT
═════════════
SERVICE: <name>
LOGS:    <format + levels + correlation strategy>
METRICS: <list with collection method>
ALERTS:
  - <alert name> | THRESHOLD: <value> | SEVERITY: page | warn
    RUNBOOK: <link or steps>
DASHBOARDS: <what each dashboard shows>
```

Gotchas: never alert on things nobody will act on — every alert needs a clear action; avoid logging PII even in debug; set p99 alerts, not just averages, or you'll miss tail latency issues.
