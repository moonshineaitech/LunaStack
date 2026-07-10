---
name: full-text-search-database
description: Use when adding text search to an application and deciding between in-database search (Postgres tsvector, trigram, BM25 extensions) and a dedicated engine (Elasticsearch/OpenSearch, Typesense, Meilisearch). Produces a search implementation plan: index DDL, query pattern, ranking configuration, and an explicit threshold for when a dedicated engine is earned.
---

# /full-text-search-database — Search Inside the Database Until It's Earned

Use to implement full-text search in Postgres correctly, and to know the honest line where a dedicated search engine becomes worth its operational cost.

**Persona: Search Pragmatist.** Ships tsvector + trigram search that stays transactionally consistent with the data, tunes ranking with evidence from real queries, and does NOT stand up an Elasticsearch cluster because "we might need facets someday" — nor pretend `ILIKE '%term%'` is search.

The modern Postgres pattern: a **generated column** `tsvector` (`GENERATED ALWAYS AS (setweight(to_tsvector('english', title),'A') || setweight(to_tsvector('english', body),'D')) STORED`) with a **GIN index**, queried via `websearch_to_tsquery` — it parses user-typed syntax (quotes, OR, minus) safely, unlike `to_tsquery` which throws on raw input. Pair it with **pg_trgm** (`gin_trgm_ops`) for typo-tolerant and prefix matching, and union the two for a decent hybrid. Rank with `ts_rank_cd` on weighted fields, but know its two real limits: it has no corpus-wide statistics (no IDF — "the" and "kubernetes" score alike beyond weights), and ranking reads every matching row's tsvector, so always filter first and rank a bounded set (`LIMIT` a few hundred candidates, then order). This setup honestly serves most apps to roughly ~1M documents and p95 under ~100ms; if you need real **BM25** relevance without leaving Postgres, ParadeDB's **pg_search** covers the middle ground, and pgvector alongside gives hybrid semantic + lexical with one `JOIN`. A dedicated engine (OpenSearch/Elasticsearch, or Typesense/Meilisearch for product search) is earned by requirements, not vibes: faceted navigation over many attributes, per-field boosting with A/B-tuned relevance, search-as-you-type at high QPS, or a corpus past the ~1M-doc / sub-50ms bar — and it costs you an indexing pipeline (CDC via Debezium or transactional outbox) that WILL drift and needs reconciliation. Rule: **Stay in-database until you have a named requirement Postgres ranking cannot express — corpus size alone below ~1M docs never justifies the second system.**

BAD: "Sync everything to Elasticsearch from day one so search is 'done right'" (you now own cluster ops plus an eventually-consistent sync pipeline; deleted rows will haunt search results). GOOD: "Generated tsvector column + GIN, websearch_to_tsquery, trigram fallback for typos — consistent with every write, zero pipelines; revisit at 1M docs or the first faceting requirement."

```
FTS IMPLEMENTATION PLAN
═══════════════════════
CORPUS: [n docs] · growth: [rate] · languages: [list]
DDL: [generated tsvector col + setweight map A–D] · index: [GIN/GIN trgm]
QUERY: websearch_to_tsquery · fuzzy: [pg_trgm similarity ≥ ~0.3]
RANKING: [ts_rank_cd weights / BM25 via pg_search] · candidate LIMIT: [n]
LATENCY TARGET: p95 [ms] · measured: [ms]
ENGINE TRIGGER: [named requirement that forces ES-class] · status: [not met/met]
```

Skip when: search is exact-match lookup over codes/emails/IDs (a btree or trigram index, not FTS), or you're already operating a search engine for another product — marginal cost of one more index is low.

Gotchas: forgetting `unaccent` (wrapped in an IMMUTABLE function so it's indexable) makes "café" unfindable by "cafe"; the `simple` config skips stemming while `english` stems aggressively — mismatched configs between index and query return silently empty results; GIN indexes make writes noticeably slower and `fastupdate` pending lists can cause periodic latency spikes on hot tables; and ranking every match without a candidate LIMIT turns a 20ms query into a seq-scan-priced one the day the corpus grows.
