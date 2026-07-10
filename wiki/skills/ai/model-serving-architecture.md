---
name: model-serving-architecture
description: Use when designing or capacity-planning a self-hosted LLM serving deployment — picking parallelism, sizing KV-cache memory, or setting autoscaling signals. Produces a serving architecture with the memory math, a tensor/replica parallelism decision, and token-based autoscaling policy.
---

# /model-serving-architecture — Size the Fleet Before You Rent It

Use to architect an LLM serving deployment: parallelism layout, KV-cache capacity math, and autoscaling that tracks tokens, not requests.

**Persona: Serving Platform Architect.** You decide how a model maps onto GPUs and how the fleet scales. You do NOT tune per-engine flags like quantization or speculative decoding (see /llm-inference-optimization) and you do NOT choose the model — you make a given model serve a given traffic shape without falling over.

Start with the memory ledger, because serving capacity is KV-cache capacity. Per-token KV bytes = 2 (K+V) × layers × kv_heads × head_dim × dtype_bytes; a Llama-3-70B-class GQA model at FP16 needs ~320 KB/token, so one 8k-context sequence eats ~2.6 GB and an 80 GB H100 minus ~140 GB of weights (already needs 2 GPUs) leaves room for far fewer concurrent sequences than request-count intuition suggests. Run this math before choosing hardware — it tells you max concurrency per replica, which is your real capacity unit. **Tensor parallelism** is a fit tool, not a speed tool: use the smallest TP degree that fits weights + target KV headroom, keep TP inside one NVLink domain (a single node), and never span TP across Ethernet/InfiniBand between nodes — scale out with **data-parallel replicas** behind a KV-aware router (llm-d, NVIDIA Dynamo, vLLM production stack) instead. Consider **disaggregated prefill/decode** only past roughly ~10k req/min or when long-prompt prefill visibly spikes decode latency for others; below that it's operational complexity for nothing. Autoscale on token-denominated signals — KV-cache utilization and queue depth (e.g., scale out when cache utilization sustains above ~80%, or on pending-token backlog), never on requests/sec or CPU: a 200-token chat and a 100k-token RAG prompt are the same "request" and a 50x different load. Rule: **Capacity-plan and autoscale in tokens and KV-cache bytes; requests/sec is a lie your load balancer tells you.**

BAD: "We set TP=8 across two nodes so the 70B would be fast, and HPA scales on requests/sec" (inter-node all-reduce over the network throttled every token; RPS scaling thrashed because long-context requests carry 100x the load of short ones). GOOD: "TP=2 on one NVLink pair fits weights + 40 GB KV headroom; 6 replicas behind a prefix-aware router; scale-out trigger: KV utilization >80% for 2 min or pending tokens >200k."

```
SERVING ARCHITECTURE — [model @ traffic]
═════════════════════════════════════════
Memory ledger: weights [GB] · KV [KB/token] · max ctx [tok] → concurrency/replica [n]
Parallelism:   TP=[n] (intra-node only) · replicas [n] · router [llm-d/Dynamo/custom]
Disagg P/D:    [yes/no — trigger: req/min, long-prefill interference]
Autoscaling:   signal [KV util % / pending tokens] · out @[x] · in @[y] · cooldown [min]
Failure plan:  replica loss → [drain/retry] · overload → [shed/queue, priority]
Validated:     replayed prod trace [date] · p95 TTFT [ms] · tok/s/GPU [n]
```

Skip when: you're on a managed API or a single-GPU model that fits with headroom — one vLLM replica and a plain load balancer is the whole architecture.

Gotchas: forgetting activation and CUDA-graph overhead in the memory ledger, then wondering why the engine OOMs at 90% of your computed concurrency — leave ~10% slack. Scaling in aggressively evicts warm KV/prefix caches and spikes TTFT for everyone; set long cooldowns. TP across nodes "works" in benchmarks with batch size 1 and collapses under load. Routing round-robin instead of prefix-aware throws away cache hits that your capacity math silently assumed.
