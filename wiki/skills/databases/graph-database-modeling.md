---
name: graph-database-modeling
description: Use when evaluating or designing a graph database (Neo4j, Memgraph, Neptune) — deciding graph vs relational, modeling nodes and relationships, or reviewing slow Cypher. Produces a fit verdict based on traversal depth, a labeled-property-graph model with relationship semantics, supernode mitigations, and Cypher query discipline rules.
---

# /graph-database-modeling — Buy a Graph Only When You Traverse

Use to decide whether a workload deserves a graph database and, if so, to model relationships as first-class citizens instead of foreign keys with better marketing.

**Persona: Graph Data Architect.** Justifies graph adoption with a specific multi-hop traversal the team runs today, models from the questions asked of the data, and profiles every Cypher query before shipping it. Does NOT migrate a working relational schema because "everything is a graph," and does NOT use a graph store as a primary system of record for tabular CRUD.

The honest fit test: graphs win when queries traverse **variable-depth or ≥3-hop paths** — fraud rings, dependency chains, access-control inheritance, recommendation walks — because relational recursive CTEs and join chains degrade with depth while a native graph's index-free adjacency makes each hop O(1) per neighbor. If every query in the inventory is 1–2 hops with fixed shape, Postgres with good indexes wins on cost, tooling, and hiring; adopt a graph only when ~30%+ of query value comes from 3+ hop or pathfinding queries. Model the **labeled property graph** from questions: nouns become node labels, verbs become typed, directed relationships (`(:User)-[:APPROVED {at}]->(:Expense)`), and anything you filter or aggregate on mid-traversal belongs as a relationship property, not buried in JSON on the node. Intermediate events (a payment, a review) should usually be nodes, not relationship blobs, so they can connect to more than two things later. Watch for **supernodes**: any node expected to exceed ~10k–100k relationships (a "USA" node, a viral post) turns traversals through it into scans — mitigate by refining relationship types (`:LIVES_IN_CA` beats `:LIVES_IN` → USA), interposing bucket nodes, or questioning whether that hub carries information at all. Query discipline in Cypher (now aligned with the **ISO GQL** standard): always anchor with a label + indexed property (`MATCH (u:User {id: $id})`), bound variable-length patterns (`[:KNOWS*1..4]`, never unbounded `*`), and `PROFILE` anything shipping to production — a plan showing `AllNodeScan` or `CartesianProduct` is a defect, not a tuning opportunity. On the platform side, Neo4j 5.x/Aura and Memgraph cover OLTP traversal; Neptune Analytics or Neo4j GDS cover whole-graph algorithms (PageRank, communities) — don't run those over the transactional store. Rule: **No graph database without a named, currently-painful query that traverses 3+ hops or variable depth — otherwise stay relational.**

BAD: "Migrate the whole e-commerce schema to Neo4j so recommendations are possible later" (95% of the workload is 1-hop CRUD that gets slower and more expensive; the one recommendation query didn't need the migration). GOOD: "Keep Postgres as system of record; sync the user–product interaction subgraph to a graph store via CDC and serve only the traversal queries from it."

```
GRAPH MODELING WORKSHEET
════════════════════════
VERDICT: [graph / relational / hybrid-CDC] · killer query: [3+ hop question]
QUERY INVENTORY: [question → hops · depth fixed/variable · rate]
MODEL: nodes [labels + key props] · rels [TYPE, direction, props] · event nodes: [list]
INDEXES: [label.prop anchors] · constraints [uniqueness]
SUPERNODES: [risky hubs · expected degree] · mitigation [type-split/bucket/remove]
CYPHER RULES: bounds [*1..n] · PROFILE gate [no AllNodeScan/CartesianProduct]
ANALYTICS: [GDS/Neptune Analytics jobs or none]
```

Skip when: queries are aggregations over columns (that's OLAP — use a warehouse) or fixed 1–2 hop lookups (relational with join indexes); or the "graph" is really vector similarity — that's an embedding index, not a traversal problem.

Gotchas: modeling entities as relationship properties locks them to exactly two endpoints — the day a review needs a moderator link, you're rewriting the model; unbounded variable-length patterns (`[*]`) work in the demo and melt down on the first dense cluster in production; treating relationship direction as decoration then querying both directions doubles traversal cost silently; and the everything-is-a-graph trap is real — teams spend a quarter migrating tabular data into nodes only to reimplement GROUP BY badly in Cypher.
