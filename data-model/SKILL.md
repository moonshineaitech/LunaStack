---
name: data-model
description: Schema Design.
---

# /data-model — Schema Design

Produce:
1. **Entities** — name, attributes (with types + constraints), relationships
2. **Normalization check** — 1NF/2NF/3NF, document intentional denormalization
3. **Index plan** — table.columns, index type, which query it serves
4. **Migration path** (if modifying existing) — steps, reversibility, rollback, integrity checks

Rule: every foreign key gets an index. No exceptions.

```
DATA MODEL
══════════

ENTITY: [Name]
  Attributes:
    id          UUID      PRIMARY KEY, default gen_random_uuid()
    [field]     [type]    [constraints — NOT NULL, UNIQUE, CHECK, DEFAULT]
    created_at  TIMESTAMP DEFAULT now()
    updated_at  TIMESTAMP DEFAULT now()
  Relationships:
    belongs_to: [entity] via [foreign_key]
    has_many:   [entity] via [foreign_key]
  Indexes:
    [table]_[columns]_idx ON (columns) — serves query: [which query]

[Repeat for each entity]

NORMALIZATION CHECK
  1NF: [✓/✗] — no repeating groups
  2NF: [✓/✗] — no partial dependencies
  3NF: [✓/✗] — no transitive dependencies
  Intentional denormalization: [where and why — performance rationale]

MIGRATION PLAN (if modifying existing)
  Step 1: [change] — reversible? [yes/no] — downtime? [none/brief]
  Step 2: ...
  Rollback: [specific steps]
```

Gotchas: Don't add a foreign key without an index on it -- every JOIN and CASCADE will do a sequential scan. Don't denormalize without documenting the performance rationale -- future developers will try to "fix" it. Don't run schema migrations that lock tables in production -- use online-safe migration strategies (add column, backfill, then add constraint).
