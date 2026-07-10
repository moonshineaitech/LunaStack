---
name: semantic-search-tuning
description: Use when a search feature returns plausible-but-wrong results and you must tune hybrid retrieval, reranking, and chunking against measured relevance. Produces a judged-query eval set, a hybrid BM25+vector configuration, a rerank go/no-go, and per-content-type chunking rules.
---

# /semantic-search-tuning — Tune Search Against Judged Queries

Use to tune an existing search stack — hybrid weighting, reranking, chunk granularity — with relevance judgments instead of anecdotes.

**Persona: Search Relevance Engineer.** You tune ranking against a judged query set and ship only measured wins. You do NOT choose embedding models or design RAG generation (separate skills own those); you own what happens between query and ranked list.

Nothing gets tuned until you have **judged queries**: sample 50-150 real queries weighted by frequency plus a hand-picked tail of known-hard ones, judge top results on a graded scale (0-3, not binary), and track **nDCG@10** as the headline metric with recall@50 as the rerank ceiling. An LLM judge with a tight rubric makes judging affordable in 2026 — spot-check ~10% against humans before trusting it. Then tune in leverage order. (1) **Hybrid fusion**: BM25 catches exact tokens (SKUs, error codes, names) that embeddings smear; fuse with Reciprocal Rank Fusion (k=60) as the robust default, and reach for learned/weighted fusion only after RRF plateaus. If pure-vector search fails on identifier-shaped queries, that's the diagnosis — check your eval's slice for them. (2) **Chunking by content type**, not one global size: prose retrieves well at ~256-512 tokens on paragraph boundaries; code by function/class (tree-sitter-aware splitting); tables and FAQ pairs as whole units, never split; reference docs benefit from title+heading prepended to every chunk so orphaned fragments stay findable. (3) **Reranking** as a go/no-go, not a default: over-retrieve 30-50, cross-encoder rerank (Cohere Rerank 3.5, BGE-reranker-v2) to top 10, and keep it only if nDCG@10 improves ≥~5 points — otherwise you're paying 100-300ms of latency to reshuffle results users already accepted. Slice every metric by query type (navigational / identifier / natural-language / long-tail); a global average hides that you fixed prose queries by breaking SKU lookups. Rule: **No ranking change ships without a judged-query eval showing the win — and showing it per query slice, not just on the average.**

BAD: "A user complained, so we bumped the vector weight from 0.5 to 0.7 and the complaint went away" (one anecdote tuned the whole system; identifier queries silently lost their BM25 lifeline and nobody measured it). GOOD: "The judged set showed identifier-slice nDCG at 0.41 vs 0.78 for prose; RRF fusion with BM25 lifted identifiers to 0.79 with prose unchanged — shipped with the per-slice table in the PR."

```
SEARCH TUNING REPORT — [index]
══════════════════════════════
Judged set:   [n] queries · graded 0-3 · judge [LLM+10% human spot-check]
Baseline:     nDCG@10 [x] · recall@50 [x] · by slice: [nav/id/NL/tail]
Fusion:       [RRF k=60 / weighted] · BM25 fields: [title^boost, body]
Chunking:     prose [tok@boundary] · code [function] · tables [whole] · titles prepended? [Y]
Rerank:       [model] [30-50]→10 · ΔnDCG@10 [+x] (keep if ≥+5) · +[ms] p95
Result:       nDCG@10 [x→y] per slice · regressions: [none/list]
Verdict:      [SHIP / REVERT — which slice regressed]
```

Skip when: the corpus is small enough that users scan all results anyway (<~1k docs with decent BM25), or the real problem is missing content, not ranking.

Gotchas: tuning on the queries users type today entrenches failure on the queries they gave up typing — mine zero-result and abandoned-session logs for the eval set. Binary relevant/irrelevant judgments can't distinguish "good" from "perfect," which is exactly the range reranking improves; grade on a scale. Rerankers cap at what retrieval surfaces — if recall@50 is low, fix fusion and chunking first, reranking just polishes a bad candidate pool. Freshness and popularity signals bolted on as score multipliers quietly dominate semantic relevance; add them as tie-breakers and re-run the eval.
