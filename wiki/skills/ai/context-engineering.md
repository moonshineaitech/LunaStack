---
name: context-engineering
description: Use when an LLM feature's context window is bloated, expensive, or degrading output quality, and you must decide what lives in the system prompt vs retrieval vs history. Produces a context budget with layer allocations, a compaction strategy, and cache-aligned prompt layout.
---

# /context-engineering — Budget the Window Like Memory

Use to allocate a model's context window across system prompt, retrieved content, tools, and conversation history — and keep it there.

**Persona: Context Budget Owner.** You treat the window as scarce, cache-priced memory with an explicit budget per layer. You do NOT tune prompt wording or pick retrieval models — you decide what gets in, in what order, and when it gets evicted.

Long context is not free real estate: models exhibit measurable degradation as windows fill ("context rot"), so budget to use roughly ≤60-70% of the advertised window at steady state and treat the rest as headroom for spikes. Layer by volatility, because **prompt caching** prices are brutal about ordering: providers charge cached reads at ~0.1x and cache writes at ~1.25x of base input price, and any byte changed invalidates everything after it. So layout is: (1) **stable prefix** — system prompt, tool definitions, few-shot examples: identical across all users, cached, never interpolate a timestamp or username here; (2) **session-stable** — user/workspace profile; (3) **volatile tail** — retrieved chunks, then conversation history, newest-dependent content last. Put in the system prompt only what is true for every request; everything request-specific belongs in retrieval or the turn itself — a fact pasted into the system prompt is a fact you can never update without a cache miss and a redeploy. For history, don't truncate blindly: **compact** — when history crosses ~50% of budget, summarize the oldest turns into a structured state note (decisions made, open questions, artifacts produced) and keep recent turns verbatim; for agents, prefer writing durable state to files/memory tools over re-narrating it in-window. Measure tokens per layer in production; the usual pathologies are tool definitions (dozens of verbose schemas nobody calls — load tools dynamically or trim to the ~10 actually used) and retrieval over-stuffing (k=20 chunks when reranked k=5 scores the same). Rule: **Order context by volatility — stable, cacheable content first, volatile content last — and compact history before it crosses half your budget.**

BAD: "We inject the user's name and today's date at the top of the system prompt so the model always knows them" (one volatile line at position zero invalidates the prompt cache for every request — you pay full input price on your largest, most stable content, forever). GOOD: "Static 4k system prefix cached across all users; user profile in a second block; date passed in the final user turn; cache hit rate 94%, input cost down ~5x."

```
CONTEXT BUDGET — [feature]
══════════════════════════
Window:      [model] · [n]k advertised · [n]k working budget (≤70%)
L1 stable:   system+tools+examples [n]k tok · cached · hit rate [x%]
L2 session:  profile/workspace [n]k tok
L3 volatile: retrieval [n]k (k=[n] chunks) · history [n]k
Compaction:  trigger @[50]% of budget · method [summary-note/file-state]
Eviction:    [oldest-turns → summary · tool results > n tok clipped]
Measured:    avg fill [x%] · cost/req [$] · cache hit [x%]
```

Skip when: single-turn calls with short prompts that never approach the budget — layering ceremony adds nothing under ~10% window use.

Gotchas: "the window is 1M tokens now" is not a strategy — retrieval quality still beats raw stuffing on cost and accuracy for large corpora. Summarizing history with a lossy one-liner destroys agent state; compact into structured notes (decisions, constraints, file paths), not prose vibes. Tool results are the stealth budget-killer — a single verbose API response can dwarf your system prompt; clip or offload them to files. Cache TTLs are short (~5 min default on Anthropic); bursty traffic patterns can silently pay write prices repeatedly.
