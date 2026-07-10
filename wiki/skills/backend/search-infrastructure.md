---
name: search-infrastructure
description: Use when building or fixing full-text search on Elasticsearch/OpenSearch-class engines (or Typesense/Meilisearch/pg full-text) — index and mapping design, analyzer choices, relevance tuning, hybrid lexical+vector ranking, or reindexing without downtime. Produces an index design with explicit mappings and analyzers, an alias-based zero-downtime reindex plan, and a measurable relevance tuning loop with a judged query set.
---

# /search-infrastructure — Search Is a Product Loop, Not a Database Feature

Use to design search infrastructure where relevance is measured, mappings are deliberate, and reindexing is routine.

**Persona: Search engineer who knows relevance work is 20% engine config and 80% measurement discipline.** You design mappings explicitly, wire aliases before the first document, and refuse to "tune" ranking without a judged query set to score against. You do NOT dynamic-map production indexes, and you never tweak boosts based on the one query a VP complained about.

Design the index around queries, not source tables: **denormalize** at index time (search engines don't join), map every field explicitly with `dynamic: strict` — dynamic mapping guesses wrong once (a numeric-looking ID becomes a long) and locks the mistake in, since **mappings are immutable; changing one means reindexing**. Analyzers are where search quality is won: language-specific stemmers, `keyword` subfields for exact match/aggregations/sorting, `search_as_you_type` or edge n-grams for prefix (bounded — n-gram explosion bloats indexes 3–10×), synonyms via **search-time** synonym_graph filters so updating the synonym list doesn't force a reindex. Wire the **zero-downtime reindex** pattern on day one: clients only ever see `products_read` / `products_write` aliases; to migrate, create `products_v2`, dual-write via the write alias (or replay from a change stream/outbox), `_reindex` history, verify counts and a sampled diff, then atomically swap the read alias — keep v1 for ~a week before deleting. Relevance tuning is a loop, not a session: build a **judged query set** (~50–200 real queries from logs with graded results), track **NDCG@10** or MRR plus zero-results rate, and accept a ranking change only if offline metrics improve and an online A/B or interleaving test doesn't regress click-through — then layer BM25 first, business signals (recency, popularity) via `function_score`/`rank_features` second, and **hybrid vector retrieval** (kNN + BM25 fused with RRF, native in current Elasticsearch/OpenSearch) only after lexical is measured and solid. Rule: **No ranking change ships without a judged query set showing improvement — anecdote-driven boosting is how search gets worse one fix at a time.**

BAD: "CEO's query ranks wrong — boost the title field 5x and hotfix it" (fixes one query, silently degrades hundreds; six months of stacked anecdote-boosts make relevance untunable). GOOD: "Add the query to the judged set, run the boost candidate offline — NDCG@10 +0.04, zero-results flat — then A/B it behind the ranking config flag."

```
SEARCH DESIGN — [index]
═══════════════════════════════════════
Engine:    [Elasticsearch|OpenSearch|Typesense|Meilisearch|pg FTS] — fit: [reason]
Mapping:   dynamic=strict · fields=[explicit list] · denormalized joins=[which]
Analyzers: [lang stemmer] · exact=[keyword subfield] · prefix=[edge n-gram, bounded]
           synonyms=[search-time graph]
Reindex:   aliases=[read/write] · dual-write=[stream|outbox] · swap=atomic · keep old=[7d]
Relevance: judged set=[n queries, graded] · metric=[NDCG@10 | MRR] · zero-results=[%]
           layers: BM25 → function_score signals → hybrid kNN+RRF=[phase]
Freshness: index lag SLO=[s] · source of truth=[DB, rebuildable]
═══════════════════════════════════════
```

Skip when: <~100k rows with simple filter/prefix needs — Postgres FTS or `pg_trgm` avoids running a second stateful system; or purely key-value lookup traffic mislabeled as "search."

Gotchas: treating the search engine as a source of truth — it must always be rebuildable from the database or event log, or a mapping mistake becomes data loss. Sharding defaults (or one shard per index "for later") — oversharding below ~10–50GB per shard wastes heap; plan shard count from data size, not superstition. Index-time synonyms freeze your synonym list into the segments. Adding vectors before fixing analyzers — hybrid search built on broken tokenization just fuses two bad rankings.
