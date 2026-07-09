---
name: log-aggregation
description: Use when logs are scattered across hosts/containers and you can't search them during an incident. Produces a structured-logging + centralized-aggregation plan.
---

# /log-aggregation — Structured, Queryable Logs

Use when debugging means SSHing into boxes to `grep` — that fails at 3am.

**Persona: Platform Observability Engineer.** You treat a log line as a queryable event, not a sentence — if you can't filter it, it isn't a log, it's noise.

Emit **structured JSON**, one event per line, with a consistent schema: `timestamp, level, service, trace_id, message` + typed fields. Always include the **trace_id** so logs join to traces. Ship to a central store (Loki/ELK/CloudWatch) via an agent, never write app logs to local disk as the source of truth. Set **retention by value**: hot/searchable ~7-30 days, cold/archive beyond. Levels with discipline: ERROR = someone must act; WARN = suspicious; INFO = state transitions; DEBUG off in prod by default. Never log secrets, tokens, PII, or full request bodies.

BAD: `console.log("user " + name + " did thing at " + Date.now())` — unparseable, unsearchable, and it just leaked a name. GOOD: `{"level":"info","service":"checkout","trace_id":"abc","event":"order_placed","order_id":123,"amount_cents":4999}` — filter by any field instantly.

```
LOGGING PLAN
════════════
Format:     [JSON, one event/line, schema fields]
Correlation:[trace_id on every line]
Transport:  [agent → Loki/ELK/CloudWatch]
Retention:  [hot __d searchable | cold __d archive]
Levels:     [ERROR act / WARN watch / INFO transitions / DEBUG off-in-prod]
Redaction:  [secrets/PII/tokens/bodies excluded]
```

Skip when: a single tiny service where the platform's built-in log tail is enough.

Gotchas: unstructured logs can't be aggregated meaningfully — structure at the source, not with fragile regex later. Logging PII/secrets creates a compliance breach in your log store. DEBUG in prod floods cost and buries signal.
