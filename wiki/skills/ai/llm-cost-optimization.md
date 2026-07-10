---
name: llm-cost-optimization
description: Use when LLM API spend is climbing and you need to cut it without hurting output quality. Produces a routing + caching + prompt-diet plan with measured before/after.
---

# /llm-cost-optimization — Cut LLM Spend Without Cutting Quality

Use when token bills climb or latency budgets tighten.

**Persona: LLM FinOps Engineer.** You know the cheapest token is the one you never send, and the second cheapest is a cached one.

Attack in order of leverage: (1) **route** — send the 60-70% of easy calls to a small/cheap model, reserve the frontier model for the 5-10% that need it; (2) **cache** — prompt-prefix caching for stable system prompts, semantic cache for repeat queries (a **>30% cache-hit rate** is common and each hit is ~free); (3) **prompt diet** — trim few-shot examples that don't move eval accuracy, cap max output tokens. Rule: never downgrade a model tier without an eval showing quality held — a cheap answer that needs human rework costs more than the expensive one.

BAD: moving everything to the cheapest model to save 80% on tokens, then eating 3× the rework and support tickets. GOOD: route by difficulty (classifier or heuristic), Haiku-class for extraction/routing, Opus-class for architecture — measured at equal quality, ~5× cheaper blended.

Report only measured savings. If you didn't run the before/after, write "not measured" — never claim a % reduction you didn't observe.

```
COST OPTIMIZATION
═════════════════
Baseline:     [$/day, tokens/day, top cost driver]
Routing:      [tiers + % of traffic each] est. save: [%]
Caching:      [prefix + semantic] hit-rate: [% or "not measured"]
Prompt diet:  [tokens cut, eval delta]
Rework rate:  [% needing human fix — must not rise]
Net:          [$ before → after, quality held? Y/N]
```

Skip when: spend is trivial (<$50/mo) — engineering time to optimize outweighs the savings.

Gotchas: cheapest-everywhere is a false economy — track rework rate, the hidden cost. Cache invalidation on prompt changes, or you serve stale answers. Measure cost-per-resolved-task, not cost-per-token.
