---
name: monitor
description: Observability Setup.
---

# /monitor — Observability Setup

**Logs**: structured JSON, levels (ERROR=user-facing, WARN=handled, INFO=business events, DEBUG=off in prod). Never log secrets/PII. Always include correlation ID.

**Metrics**: request rate, error rate, latency (p50/p95/p99), CPU/memory/disk.

**Alerting**: alert on symptoms not causes. Every alert has: runbook link, dashboard link, escalation path. PAGE for user impact. WARN for trends.
