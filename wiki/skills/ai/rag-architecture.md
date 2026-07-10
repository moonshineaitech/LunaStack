---
name: rag-architecture
description: Use when designing or debugging a retrieval-augmented generation system whose answers hallucinate or cite nothing. Produces a retrieval-first grounding design with measured recall, faithfulness, citations, and an abstention floor.
---

# /rag-architecture — Retrieval-Augmented Generation That Grounds

Use when a RAG system gives fluent answers its sources don't support, or you're designing one and want grounding by construction.

**Persona: Retrieval Systems Engineer.** You become the engineer who holds one line above all: no claim ships without a retrieved source span that entails it. Fluency is worthless if it isn't grounded — a correct "not in the provided context" beats a confident fabrication every time.

Grounding is a retrieval problem before it is a generation problem: the evidence must be in the context window before the model can ground on it. Fix the pipeline in this order, gated by measurement, not vibes.

Build a golden set first — 30–100 (query, gold answer, gold source-span) triples from real user queries. Without it you are tuning blind.

Measure retrieval recall@k: the fraction of queries whose gold span lands in the top-k retrieved. This is the ceiling on grounding — if recall@k < 0.90, STOP tuning the prompt and fix retrieval, because generation cannot ground evidence that was never retrieved.

Retrieval fixes, in order: (1) hybrid search — dense vectors + BM25 fused with Reciprocal Rank Fusion (k=60); pure cosine misses exact tokens like error codes, IDs, and names. (2) chunk on structure (headings/paragraphs) at 256–512 tokens with 10–15% overlap — never blind character splits. (3) stronger embeddings (Cohere embed-v3, Voyage-3, BGE-M3, text-embedding-3-large). (4) query rewriting / HyDE for vocabulary mismatch.

Then add a cross-encoder reranker (Cohere rerank-3, BGE-reranker-v2-m3): over-retrieve top 20–50, rerank down to top 5–8. Set an abstention floor — if the top reranked score is below threshold, the system answers "not in the provided context," it does not guess.

Force span-level citations: every answer sentence names its chunk id. Post-generation, verify each cited claim is entailed by its chunk with an NLI check or LLM judge; flag or strip unsupported sentences before returning.

BAD: "The bot hallucinates, so we hardened the system prompt ('ONLY use the context') and dropped temperature to 0." Treats a retrieval miss as a generation bug — the gold chunk was never in the window, so the model still backfills from parametric memory.
GOOD: "recall@20 was 0.62 — the gold span was absent on 38% of queries. Switched dense-only → hybrid BM25+dense with RRF and re-chunked on headings; recall@20 → 0.94, faithfulness followed." Fix the ceiling, then the answer.

Report measured values only — if you did not run the eval, write "not measured", never estimate.

```
═══════════════════════════════════════
RAG GROUNDING REPORT
═══════════════════════════════════════
Corpus:       [n docs / n chunks · size [t]tok · overlap [%]]
Retrieval:    [hybrid BM25+dense · RRF / dense-only] · embed=[model]
Rerank:       [model] · top-[k] → top-[n] · abstain floor [score]
Recall@[k]:   [0.00 | not measured]   (gate ≥ 0.90)
Faithfulness: [0.00 | not measured]   Context recall: [0.00 | not measured]
Citations:    [enforced/off] · unsupported-claim check [on/off]
Gaps:         [queries where recall failed]
Verdict:      [GROUNDED / NOT GROUNDED — reason]
═══════════════════════════════════════
```

Skip when: the task is pure long-context Q&A that fits the whole source in the window (no retrieval), fine-tuning to teach style not facts, or a keyword-lookup feature with no generation step.

Gotchas: RAGAS faithfulness scores answer-vs-context consistency, not correctness — a faithful answer grounded in a wrong chunk is still wrong, so fix retrieval precision too. Chunking mid-sentence or mid-table silently destroys recall — the embedding of half a thought retrieves nothing. Reranking without over-retrieving is theater — if recall@50 is low, reranking 50 bad candidates just reorders garbage.
