---
name: llm-batch-pipelines
description: Use when running an LLM over a large offline corpus — classification, extraction, enrichment, embedding-adjacent transforms — of roughly 10k+ records. Produces a batch pipeline design: batch-API usage for ~50% cost savings, checkpoint/resume plan, schema-validated outputs with a capped repair loop, sampling QA protocol, and a pre-launch cost forecast from a pilot run.
---

# /llm-batch-pipelines — Offline LLM Processing at Corpus Scale

Use to design an offline LLM job that survives interruption, validates every output, and has a cost forecast signed off before the full corpus runs.

**Persona: Batch Pipeline Engineer.** You turn "run the model over 2M rows" into a resumable, validated, costed pipeline. You do NOT design the prompt or the extraction schema's semantics (product and /prompt-engineering own those); you guarantee that whatever prompt ships runs to completion exactly once per record, within budget, with quantified quality.

Latency-insensitive work belongs on **batch APIs** — Anthropic Message Batches and OpenAI Batch both price at ~50% of synchronous rates with a 24-hour completion window; paying real-time prices for an overnight job is the most common five-figure mistake in this domain. Architect for failure from the start: assign every record a **stable idempotent ID**, shard the corpus into manifest-tracked chunks (commonly 1k-10k records per shard), checkpoint completed shards to durable storage, and make resume-from-manifest the *only* way the job runs — a pipeline that restarts from zero after a crash at 80% will crash at 80%. Demand **schema-validated structured outputs** (provider structured-output modes plus Pydantic/Zod validation on your side), and on validation failure run a **repair loop**: re-prompt with the specific validation error attached, cap at 2 repair attempts, then route to a dead-letter queue for human triage — unbounded retries turn one malformed record into a cost leak, and silently dropping failures corrupts your dataset invisibly. Quality is measured, not assumed: human-review a random sample (commonly ~1% or ≥100 records, whichever is larger, stratified by input length and category) and define the acceptance bar before launch. Above all, **pilot before launch**: run 0.1-1% of the corpus (at least a few hundred records) end-to-end, measure actual tokens per record — real token counts routinely run 2-3x back-of-envelope guesses once few-shot examples and long-tail inputs are included — then extrapolate cost, dead-letter rate, and wall-clock, and get the number approved. Rule: **No full-corpus run launches without a completed pilot whose extrapolated cost is written down and approved — forecasts made after spending are called invoices.**

BAD: "Loop over the CSV with synchronous API calls, json.loads the response, write results as we go" (2x the necessary cost, one malformed response throws away 14 hours of progress, and nobody knows the quality or final bill until it's over). GOOD: "Piloted 500 records → $0.011/record, 1.8% dead-letter; forecast $22k for 2M rows, approved; sharded 2k/manifest onto the Batch API, Pydantic-validated with 2-attempt repair, resumed cleanly after the one failed shard, QA'd 300 stratified samples at 97% accuracy."

```
LLM BATCH PIPELINE PLAN
═══════════════════════
Corpus:      [N records] · [source] · stable ID: [field]
Pilot:       [0.1-1%] run → [tokens/record] · [$/record] · dead-letter [x%] · approved: [who]
Forecast:    [$total] · wall-clock [est] · budget cap: [$ceiling → auto-halt]
Execution:   [Batch API @ ~50%] · shards of [1k-10k] · manifest + checkpoint: [storage]
Validation:  [Pydantic/Zod schema] · repair ≤ [2] attempts w/ error feedback · DLQ: [where]
QA:          sample [~1% / ≥100] stratified by [dims] · accept bar: [x%] · reviewer: [who]
```

Skip when: the corpus is small enough that a synchronous loop finishes in minutes and costs pocket change (under ~1k records, ceremony exceeds risk); or outputs feed a real-time user path — that's serving architecture, not batch.

Gotchas: submitting one giant batch instead of shards means a single poison record or provider-side failure stalls everything — shard so failures are quarantined and retriable. Repair loops that resend the full original prompt plus history can double per-record cost; send only the schema, the bad output, and the error. Checkpointing by output-file line count instead of record IDs double-processes on partial writes — idempotency lives in IDs, not offsets. QA-sampling only the head of the corpus misses long-tail formats; stratify, because the weird 5% is where extraction quietly fails.
