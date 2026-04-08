---
name: multi-llm-routing
description: Use when working across multiple AI models (Claude, GPT, Gemini, local).
---

# /multi-llm-routing — Use the Right Model for the Job

Use when working across multiple AI models (Claude, GPT, Gemini, local).

Different models have different strengths. Route accordingly:

```
MODEL ROUTING TABLE
═══════════════════

Task type                  → Recommended model
═══════════════════════════════════════════════
Long-context code review   → Claude Opus 4.6 (200K context, strong reasoning)
Quick code completion      → Claude Haiku / GPT-4o-mini (cheap, fast)
Adversarial review         → GPT-4o (different blind spots than Claude)
Math/algorithmic           → GPT-o1 / Claude Opus with thinking
Multimodal (image+text)    → Gemini 2.5 Pro / GPT-4o
Local privacy-required     → Llama 4 / Kimi 2.5 via Ollama
Embeddings                 → text-embedding-3-large / voyage-large
```

Rule: don't use the most expensive model for tasks where a cheaper model would do equally well. Save the heavy models for tasks where intelligence actually matters.

Gotchas: Don't route security-critical code review to cheap/fast models -- use the strongest model for auth, payments, and data handling. Don't assume routing tables stay current -- model capabilities change with updates, re-evaluate quarterly. Don't send proprietary code to models without checking their data retention and training policies.
