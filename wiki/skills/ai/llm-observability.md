---
name: llm-observability
description: Use when an LLM feature is in production and you cannot answer "which prompt version broke, what does a request cost, is quality drifting." Produces a tracing + eval-in-prod design: span structure, sampling rates, cost/latency/quality dashboards, and drift alerts.
---

# /llm-observability — Trace, Sample, Score in Production

Use to instrument a production LLM system so every regression is attributable to a prompt, model, or retrieval change.

**Persona: LLM Reliability Engineer.** You make LLM behavior queryable — traces, scores, and diffs. You do NOT define what "good output" means (product owns that rubric) and you do NOT tune prompts; you make it obvious which prompt to tune.

Instrument with the **OpenTelemetry GenAI semantic conventions** so traces are portable across backends (Langfuse, Braintrust, Arize Phoenix, LangSmith — all speak OTel in 2026). One user request = one trace; every LLM call, tool call, retrieval, and guardrail check is a span carrying: model id, **prompt version** (a hash or registry tag — unversioned prompts make regressions unattributable), token counts split by cached/uncached, latency (TTFT and total), and cost computed at ingest. Capture full input/output payloads on a sample plus 100% of errors and user-flagged sessions; redact PII at the SDK level before export, not in the dashboard. Quality can't wait for offline evals: run **eval-in-prod** — score a sample of live traffic with an LLM judge and cheap heuristics (schema validity, citation presence, refusal detection). Commonly ~1-5% judged sampling balances cost and statistical power at moderate traffic; go 100% on heuristic checks since they're near-free. Dashboard the triad per feature and per prompt-version: cost/request, p50/p95 TTFT and total latency, and quality score — plus the leading indicators of silent degradation: refusal rate, output length distribution, retry rate, and tool-error rate. Alert on distribution shift (e.g., >2σ move in a daily score or refusal rate held for 2+ hours), because **drift** arrives via upstream model updates and shifting user traffic, not your deploys. Rule: **Every production LLM call must carry a prompt version and land in a trace — an unversioned, untraced call is a regression you will never diagnose.**

BAD: "We log prompts to stdout and check the API billing page weekly" (no request-level cost attribution, no quality signal, and when output degrades you can't tell a model update from a prompt edit from new traffic). GOOD: "OTel spans with prompt-version tags into Langfuse; 3% of traffic LLM-judged + 100% heuristic-checked; dashboard per prompt version; alert fired when refusal rate jumped 4σ the day the provider silently updated the model snapshot."

```
LLM OBSERVABILITY PLAN
══════════════════════
Backend:     [Langfuse/Braintrust/Phoenix/LangSmith] via OTel GenAI conventions
Trace:       request → spans: [llm/tool/retrieval/guardrail] · prompt ver tagged? [Y]
Payloads:    [x]% sampled + 100% errors/flags · PII redacted at [SDK]
Eval-in-prod: judge on [1-5]% · heuristics on 100%: [schema/citations/refusals]
Dashboards:  cost/req · TTFT+total p95 · quality by prompt-version · refusal rate
Drift alert: [metric] > [2σ] for [2h] · pager: [owner]
Gaps:        [what's still unattributable]
```

Skip when: the feature is pre-launch with zero real traffic (build offline evals first), or a throwaway internal script where a log line is honestly enough.

Gotchas: logging only your side of the call misses provider-side model snapshot changes — pin model versions and alert on the pin. Judging 100% of traffic with a frontier judge can cost more than serving; sample, and stratify the sample toward errors and long conversations. Averages hide bimodal failure — a mean quality score of 0.8 can be 80% perfect + 20% catastrophic; alert on the tail. Storing raw payloads without retention limits turns your tracing backend into a PII liability.
