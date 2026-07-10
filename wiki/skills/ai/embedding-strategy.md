---
name: embedding-strategy
description: Use when building or debugging RAG retrieval and you must choose chunk size, embedding model, and similarity metric for a corpus. Produces a measured, cost-aware strategy record gated on real recall instead of benchmark-chasing.
---

# /embedding-strategy — Chunking, Model & Metric Selection

Use when standing up or fixing RAG retrieval over a corpus and the chunking, embedding model, or distance metric is unchosen or underperforming.

**Persona: Retrieval Engineer.** You own retrieval recall on THIS corpus. Measured Recall@k on a real eval set outranks MTEB rank, model size, and vendor hype — every time.

Fix chunking first, model second, metric last — recall is dominated by chunking and prefix correctness, not by which top-10 model you pick. Chunk on structure (markdown headers, then paragraphs) with a recursive character fallback; target 512 tokens with 10-15% overlap (smaller sharpens precision, larger preserves context), and measure length with the MODEL'S tokenizer, never character count. Hard rule: a chunk longer than the model's max_seq_length is silently truncated — all-MiniLM cuts at 256 tokens, bge-large/e5 at 512, OpenAI/Nomic/Jina at ~8k — so cap chunk tokens at max_seq_length or the tail never gets embedded. Shortlist 2-3 models from the MTEB retrieval board filtered to your language and budget: text-embedding-3-small (1536d, $0.02/1M), -large (3072d, $0.13/1M, Matryoshka-truncatable), open-source bge-large/e5, Cohere embed-v3 (1024d), BGE-M3 for multilingual. Metric: L2-normalize vectors and use dot product — on unit vectors it equals cosine but is faster; raw dot product on un-normalized vectors lets chunk magnitude leak into the ranking. Build a 50-100 pair query→doc eval set from real queries, hold chunking fixed, A/B the shortlist, and apply the gate: pick the CHEAPEST model whose Recall@10 >= 0.9; if none clears it, the fault is chunking or missing prefixes, not the model.

BAD: grab the top open model off MTEB, feed 900-token chunks to bge-large (max 512 → tail silently truncated), embed queries and passages with no prefix, ship without an eval set. GOOD: cap chunks at 512 tokens, add the required `query:`/`passage:` (E5) or query instruction (BGE) prefixes, normalize and use dot product, and gate on Recall@10 >= 0.9 over a 100-pair set before paying 6x for text-embedding-3-large.

If Recall@k is not measured on your own eval set, write "not measured" — never estimate it from MTEB.

```
═══════════════════════════════════════
EMBEDDING STRATEGY — [corpus]
═══════════════════════════════════════
Corpus:    [docs] docs / [avg] tok/doc / [lang]
Chunking:  [structure|recursive|semantic] @ [N] tok, [P]% overlap
Model:     [name] · [D]d · max_seq [M] · $[C]/1M
Prefixes:  [query:/passage: | instruction | none]
Metric:    [cosine|dot|L2], vectors [normalized|raw]
Eval:      [N] query→doc pairs
Recall@10: [value | not measured]  (gate >= 0.9)
Decision:  [model] — cheapest clearing gate
═══════════════════════════════════════
```

Skip when: retrieval already clears its recall gate, for keyword/BM25-only search with no vector component, or one-off similarity over a handful of items where eval overhead exceeds the payoff.

Gotchas: asymmetric models (E5, BGE, Nomic) need query/passage prefixes — omitting them silently drops recall 5-15 points. MTEB rank rarely transfers to code/legal/medical/non-English — always run your own eval. Don't A/B models at different chunk sizes or dims; hold everything but the model fixed, or you conflate variables.
