---
name: dynamodb-single-table-design
description: Use when designing or reviewing a DynamoDB data model — before the first table is created, or when queries are turning into Scans and GSI sprawl. Produces an access-pattern inventory mapped to a PK/SK scheme, a GSI budget, hot-partition analysis, and an honest verdict on whether single-table design (or DynamoDB at all) fits the workload.
---

# /dynamodb-single-table-design — Model the Queries, Not the Entities

Use to design a DynamoDB table from an exhaustive access-pattern list instead of an entity diagram.

**Persona: NoSQL Data Modeler.** Refuses to write a single key schema until every read and write pattern is enumerated with its expected cardinality and rate. Does NOT port a relational ERD into DynamoDB, does NOT reach for Scan as a query strategy, and will recommend Postgres or Aurora when the access patterns are genuinely unknowable.

DynamoDB is a query-first database: you buy O(1) cost-at-any-scale by giving up ad-hoc queries, so the modeling session starts with a table of access patterns — "get user by id", "list orders for user, newest first", "find order by external ref" — each with read/write rate and item count. Then design keys: generic `PK`/`SK` attributes with typed prefixes (`USER#123`, `ORDER#2026-07-10#...`), **item collections** to satisfy "fetch parent + children" in one Query, and **sparse GSIs** (populate the GSI key only on items that need it) for secondary lookups. Budget GSIs like money: each one doubles write cost and adds eventual-consistency lag; if a design needs more than ~4–5 GSIs, the workload is relational and you are fighting the tool. Respect physics: a single partition caps at ~1,000 WCU / 3,000 RCU and an item collection at 10 GB — any key that concentrates traffic (a celebrity tenant, `STATUS#pending`, today's date) needs **write sharding** (`PK = STATUS#pending#<0-9>`) or a rethink. Use on-demand capacity by default in 2026 (its price cut made provisioned-with-autoscaling a niche optimization), model in code with **ElectroDB** or **DynamoDB Toolbox** rather than hand-rolled prefixes, and prefer several purpose-built tables over one mega-table when entities never share access patterns — single-table's payoff is joining related items in one request, not aesthetic minimalism. Rule: **If you cannot list every access pattern before launch, do not choose DynamoDB — and if two entities are never fetched together, do not force them into one table.**

BAD: "Store each entity type in its own table and Scan with a FilterExpression to find pending orders" (Scan reads and bills every item in the table; filters run after the read — cost and latency scale with table size, not result size). GOOD: "Sparse GSI with `GSI1PK = STATUS#pending#<shard 0-9>` set only on pending orders; Query all ten shards in parallel, remove the attribute on completion so the index stays tiny."

```
DYNAMODB MODEL WORKSHEET
════════════════════════
VERDICT: [single-table / multi-table / use relational] · why: [reason]
ACCESS PATTERNS: [#] enumerated · [name → Query/GetItem · rate/s · cardinality]
KEYS: PK=[scheme] · SK=[scheme] · item collections: [parent+children groups]
GSI BUDGET: [n]/5 · [GSIname: keys · sparse? · pattern served]
HOT PARTITIONS: [risky keys] · mitigation: [shard n / cache / redesign]
CAPACITY: [on-demand/provisioned] · streams: [consumer or none]
OPEN RISKS: [unknown future pattern → migration cost]
```

Skip when: access patterns are exploratory or analyst-driven (ad-hoc queries mean relational or a lakehouse, not DynamoDB); or the dataset is small and low-traffic enough (commonly <10 GB, <100 req/s) that Postgres with indexes does everything with none of the modeling tax.

Gotchas: teams model entities first and bolt on GSIs per missed query until write costs triple — patterns come before keys, always; timestamps or dates as raw partition keys create a rolling hot partition that autoscaling cannot fix; GSIs are eventually consistent, so a read-after-write through a GSI can miss the write you just made — pin read-your-writes paths to the base table; and "single-table design" applied to five unrelated entities buys you nothing but unreadable keys and painful migrations — the pattern exists to serve item collections, not dogma.
