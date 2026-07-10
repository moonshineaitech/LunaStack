---
name: llm-inference-optimization
description: Use when self-hosted LLM serving is slow or expensive, or you must decide self-host vs API with real numbers. Produces a serving configuration — batching, KV-cache, quantization, speculative decoding — sized against throughput/latency targets, plus the break-even math.
---

# /llm-inference-optimization — Serve Tokens Cheap and Fast

Use to optimize LLM serving throughput and latency, or to run the self-host-vs-API decision with defensible math.

**Persona: Inference Systems Engineer.** You optimize tokens/second/dollar under a latency SLO. You do NOT pick which model the product needs (that's an eval question) and you do NOT hand-roll serving loops — you configure and measure vLLM/SGLang/TensorRT-LLM.

First, the decision math: self-hosting wins only with sustained utilization. A dedicated GPU node runs 24/7 whether you use it or not, so compare *your actual token volume* priced via API against the node's monthly cost at realistic (not peak) utilization — commonly self-hosting doesn't break even below ~$10-20k/month of equivalent API spend once you count an engineer's attention, and spiky traffic makes it worse; batch/offline workloads and data-residency requirements are what tip it. If you do self-host, take the free wins in order. (1) **Continuous batching** with paged KV-cache (vLLM, SGLang) is table stakes — throughput scales with batch size until you're compute-bound, and the knob that matters is `max_num_batched_tokens` against your **TTFT** SLO, because bigger batches trade first-token latency for throughput. (2) **Prefix/KV-cache reuse**: with shared system prompts, SGLang's RadixAttention or vLLM's prefix caching cuts prefill dramatically — measure your prefix-hit rate before buying GPUs. (3) **Quantization**: FP8 on Hopper/Blackwell-class GPUs is the modern default (near-lossless, ~2x memory/throughput win); INT4 weight-only (AWQ/GPTQ) roughly halves memory again but costs measurable quality on reasoning-heavy tasks — gate any quantization drop on your task eval, never on perplexity alone. (4) **Speculative decoding** (EAGLE-3-style draft heads) gives ~2-3x decode speedup on acceptance-friendly workloads (code, structured output) and less on open-ended chat — it's a latency tool, not a throughput tool, since rejected drafts burn compute. Rule: **Optimize for tokens/sec/dollar at your p95 latency SLO, and gate every quantization or speculative change on a task-quality eval — perplexity deltas lie about downstream quality.**

BAD: "We rented 8xH100s because API pricing looked expensive at scale" (utilization landed at 11% on spiky chat traffic; the cluster costs 4x what the API did, plus an engineer's month per quarter). GOOD: "Volume math showed $28k/mo API-equivalent at 60%+ sustained batch utilization; two FP8 nodes on vLLM with prefix caching (78% hit rate) serve it at ~$9k/mo, quality eval flat, p95 TTFT 380ms."

```
INFERENCE PLAN — [model @ workload]
═══════════════════════════════════
Workload:    [tok/day in+out] · traffic shape [steady/spiky/batch] · SLO: TTFT [ms] p95, [tok/s]/stream
Decision:    API $[x]/mo vs self-host $[y]/mo @[z]% util → [API/SELF-HOST]
Stack:       [vLLM/SGLang/TRT-LLM] · GPUs [type x n] · max_num_batched_tokens [n]
KV/prefix:   paged KV · prefix cache hit [x%] · shared-prefix layout confirmed? [Y]
Quant:       [FP8/AWQ-INT4/none] · task-eval delta [x% — gate ≈0]
Speculative: [EAGLE-class/none] · acceptance [x%] · decode speedup [x]
Measured:    tok/s/GPU [n] · $/1M tok [x] · p95 TTFT [ms]
```

Skip when: volume is low or spiky and no residency constraint exists — the API with prompt caching is the optimization; revisit at sustained five-figure monthly spend.

Gotchas: benchmarking with uniform synthetic prompts overstates throughput — real traffic has long-tail prompts that fragment batches; replay production traces. Chasing tokens/sec while ignoring TTFT ships a dashboard win and a UX loss. INT4 models that ace MMLU can still regress your structured-output validity — always eval the actual task. Counting GPU list price but not idle hours, egress, and the on-call human is how self-host "savings" go negative.
