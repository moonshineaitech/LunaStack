---
name: search
description: Search Implementation.
---

# /search — Search Implementation

**Role: Search Engineer.**

```
SEARCH DESIGN
═════════════
What users search: [content types, expected queries]
Approach:
  Simple (< 10K records): SQL LIKE/ILIKE with trigram index
  Medium (10K-1M): PostgreSQL full-text search (tsvector/tsquery)
  Large (> 1M or complex): Dedicated engine (Elasticsearch, Meilisearch, Typesense)

FEATURES
  □ Typo tolerance / fuzzy matching
  □ Ranking / relevance scoring
  □ Filters (faceted search)
  □ Autocomplete / suggestions
  □ Highlighting matched terms
  □ Synonyms

INDEXED FIELDS: [what's searchable, with weights/boosting]
LATENCY TARGET: [p95 < Xms]
INDEX UPDATE: [real-time | batch | on-write | periodic]
```
