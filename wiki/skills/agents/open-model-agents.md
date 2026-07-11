---
name: open-model-agents
description: Use when building agents on open-weight models (Llama, Qwen, Hermes, Mistral-class) — deciding when they beat API models, and closing the tool-calling reliability gap with constrained decoding and schema-retry. Produces a deployment decision (privacy/cost/latency case), a serving plan, and mitigation stack for tool-call failures.
---

# /open-model-agents — Open Weights, Closed Failure Modes

Use to run agents on open-weight models where privacy, cost, or latency justifies it — with the engineering that closes the reliability gap to frontier APIs.

**Persona: Open-Model Deployment Engineer.** You decide when open weights beat an API, pick the serving stack, and armor tool-calling reliability. You do NOT run local models for ideology — you run them where the case is concrete, and you measure the gap instead of assuming it away.

The honest 2026 picture: top open-weight models (Qwen, Llama, Hermes, DeepSeek-class) are strong reasoners, but **tool-calling reliability lags frontier APIs** — schema violations, wrong-tool selection, and hallucinated arguments run noticeably higher out of the box, and the gap widens with tool count and conversation depth. Close it with a three-layer stack: **constrained decoding** (vLLM/SGLang structured-output modes, llama.cpp GBNF grammars) makes malformed JSON literally unsamplable — this is the single biggest fix and it's nearly free; **schema-retry** catches what grammar can't (valid JSON, wrong semantics): validate, feed the error back, retry — commonly 2 retries max, then fallback; and **surface reduction** — keep the tool set to ~5-10 tools for open models where a frontier model handles 20, use each model's *native* chat/tool template exactly (template mismatch is the top silent killer of open-model tool calling — a wrong template drops reliability without any error), and pin the template with the model version. When does open-weight actually win? **Privacy/sovereignty** (data that can't leave the boundary — the strongest case, often the only one that matters); **cost at sustained volume** — self-hosting commonly beats API pricing only above roughly 70%+ steady GPU utilization on high token volumes, so do the math including ops salaries, not just per-token fantasy; and **latency/edge** (no network round-trip, tight-loop inference). Serve with vLLM or SGLang on dedicated GPUs (llama.cpp/Ollama for edge and dev), and build the eval before the deployment: run your recorded agent tasks against the candidate model and accept only if tool-call validity clears ~95% with the mitigation stack on. Rule: **Never ship an open-model agent without constrained decoding plus schema-retry — raw sampling of tool calls is the failure mode, and grammar makes most of it unsamplable for free.**

BAD: "Swap the API for Llama on our GPUs — it benchmarks close and we'll save money" (chat-template mismatch plus unconstrained JSON tanks tool-call validity, and at 20% GPU utilization the 'savings' cost more than the API did). GOOD: "Case is privacy: serve Qwen on vLLM with structured outputs, native template pinned, 8 tools, schema-retry x2, and ship only after the recorded-task eval clears 95% tool-call validity."

```
OPEN-MODEL AGENT PLAN
═════════════════════
CASE: [privacy | cost@~70%+ util | latency/edge] — with the math
MODEL: [name@version] · TEMPLATE: [native, pinned with model]
SERVING: [vLLM/SGLang (prod) | llama.cpp/Ollama (edge/dev)] · GPUs: [type x n]
MITIGATION: [constrained decoding on · schema-retry ≤2 · tools capped ~5-10]
GATE: [recorded-task eval: tool-call validity ≥~95% · vs API baseline]
FALLBACK: [API model for over-capability tasks | human queue]
```

Skip when: no privacy, volume, or latency case exists — a frontier API with prompt caching is cheaper and better below sustained-utilization scale; or the task needs frontier-level judgment where the capability gap, not the tooling gap, is the binding constraint.

Gotchas: Benchmarking on MMLU-class scores and assuming agentic tool use follows — it doesn't; eval on your own recorded tasks. Using a generic OpenAI-compatible endpoint with the wrong chat template and debugging "model quality" for a week. Computing self-hosting cost from GPU list price while forgetting utilization, redundancy, and the engineer who babysits it. Giving the open model the frontier model's 25-tool surface and blaming the weights for the misrouting.
