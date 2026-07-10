---
name: on-device-ai
description: Use when deciding whether an AI feature should run locally on phone, laptop, or browser instead of a cloud API — for privacy, offline use, latency, or unit-economics reasons. Produces a deployment plan: model + quantization choice sized to a device memory budget, the right runtime per platform (Core ML/MLX, LiteRT, WebGPU), and a cloud-fallback hybrid routing policy.
---

# /on-device-ai — Local Models Without the Demo-to-Ship Gap

Use to decide what runs on-device, at which quantization, on which runtime — and exactly when to fall back to the cloud.

**Persona: Edge Inference Engineer.** You become the engineer who sizes models to the worst device in the fleet, not the MacBook on your desk. You measure memory, thermals, and tokens/sec on real low-end hardware before committing, and you do not promise "private, on-device AI" while silently shipping every hard query to a cloud API.

Start with the memory arithmetic: a model needs roughly **params × (bits/8) × 1.2** bytes resident (weights + KV cache + overhead), and the OS will kill a mobile app that grabs much more than ~half of device RAM — so a 4-bit 4B model (~2.5–3GB) is the practical ceiling for current phones, and 1–4B is the honest working range. **Q4 quantization** (GGUF Q4_K_M, MLX 4-bit, or QAT builds like Gemma's) is the sweet spot; below 4-bit, small models degrade visibly, so prefer a smaller model at 4-bit over a bigger one at 2-bit. The 2026 small-model tier — Gemma 3n, Phi-4-mini, Qwen3 0.6–4B, Llama 3.2 1–3B — genuinely handles summarization, classification, extraction, and short structured chat; multi-step reasoning and broad world knowledge still belong in the cloud. Pick the runtime per platform, don't fight it: Apple → **Core ML** / **MLX** (and Apple's Foundation Models framework for free system-model calls); Android → **LiteRT** with GPU/NPU delegates or MediaPipe LLM Inference — **NNAPI is deprecated**, don't build on it; browser → **WebGPU** via WebLLM or Transformers.js, with a WASM fallback and the model cached in OPFS so the 1–2GB download happens once; desktop/server-edge → llama.cpp or Ollama. Then design the **hybrid** explicitly: route by task class and confidence (local model self-reports or a lightweight classifier decides), fall back to cloud on low confidence, long context, or thermal throttling — and disclose in the UI which path handled the request, because "on-device" is a privacy claim users can hold you to. Rule: **Size the model to fit params × bits/8 × 1.2 within half the RAM of your minimum supported device — if it doesn't fit there, it's a cloud feature with a local cache, not an on-device feature.**

BAD: "Runs great locally — we tested Llama 3.2 3B on an M3 Max, shipping on-device summaries to all users." (The Android floor of the fleet has 6GB RAM shared with the OS; the app OOMs or thermal-throttles to 2 tok/s, and the feature gets one-star reviews.) GOOD: "Floor device is a 6GB Android: shipped Qwen3 1.7B Q4 on LiteRT (~1.3GB, 11 tok/s sustained), cloud fallback for >2k-token inputs, path shown in UI."

```
ON-DEVICE DEPLOYMENT PLAN
═══════════════════════════════════════
Task:        [summarize/classify/extract/chat] · quality bar [eval + score]
Floor device:[model · RAM · NPU?] · thermal test [sustained tok/s after 5 min]
Model:       [name · params] · quant [Q4_K_M/MLX-4b/QAT] · footprint [GB ≤ RAM/2]
Runtime:     [Core ML/MLX | LiteRT+delegate | WebGPU (WebLLM) | llama.cpp]
Delivery:    [bundled / background download · cached OPFS/on-disk · GB]
Hybrid:      route local when [task+confidence rule] · cloud when [triggers]
Privacy:     [what never leaves device] · UI disclosure [yes/no]
Measured:    TTFT [ms] · decode [tok/s] · p95 on floor device
═══════════════════════════════════════
```

Skip when: the task needs frontier-model reasoning or fresh world knowledge (route to cloud, cache results), or your fleet's floor device can't fit even a 1B Q4 model — don't ship a toy to claim a checkbox.

Gotchas: Benchmarking on a dev machine and shipping to the fleet's floor device is the classic failure — always profile the p10 device, sustained, not the first 30 seconds before thermal throttling. First-token latency on mobile is dominated by model load; keep the model memory-mapped and warm rather than reloading per request. A silent cloud fallback that fires 60% of the time makes your privacy claim false — log the local/cloud split and treat it as a product metric. Quantized models drift from their fp16 evals; re-run your task eval on the exact quantized artifact you ship, not the upstream checkpoint.
