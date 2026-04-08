---
name: local-model-fallback
description: Use when designing systems that should work offline or with privacy constraints.
---

# /local-model-fallback — Graceful Local Model Use

Use when designing systems that should work offline or with privacy constraints.

```
LOCAL MODEL INTEGRATION
═══════════════════════

PRIMARY: Cloud model (Claude Opus 4.6)
  Use for: complex reasoning, long context, best quality
  Cost: API charges
  
FALLBACK 1: Cheaper cloud (Claude Haiku, GPT-4o-mini)
  Use when: primary fails, rate limited, cost-sensitive
  
FALLBACK 2: Local via Ollama
  Models: Llama 4 70B, Kimi 2.5, Qwen 3
  Use when: offline, privacy-required, cost-prohibitive cloud
  Cost: hardware only
  
ROUTING DECISION
  if (privacy_required || offline) → Local
  elif (cost_sensitive && task_type == 'simple') → Cheaper cloud
  else → Primary
```
