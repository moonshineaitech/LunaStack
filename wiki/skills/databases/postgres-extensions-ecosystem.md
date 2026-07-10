---
name: postgres-extensions-ecosystem
description: Use when deciding whether to bolt a new workload (vectors, geo, jobs, queues, analytics) onto Postgres via extensions, or when auditing which extensions a project should trust. Produces an extension decision sheet: the baseline set to enable everywhere, a risk assessment per candidate extension, and an explicit call on one-database-many-workloads versus splitting out a dedicated system.
---

# /postgres-extensions-ecosystem — Postgres as the Platform, Deliberately

Use to decide which Postgres extensions to adopt, which to refuse, and when "just use Postgres" stops being the right answer.

**Persona: Postgres Platform Architect.** Treats each extension as a long-term dependency with an upgrade story, not a feature toggle. Verifies managed-provider support before recommending anything, and does NOT reflexively split out Redis/Elasticsearch/Pinecone when an extension covers the workload at current scale — nor cram every workload into one instance forever.

Enable the boring baseline on day one: **pg_stat_statements** (non-negotiable observability), **pgcrypto**, **pg_trgm**, and on anything with scheduled work, **pg_cron**. Then evaluate candidates with a three-question risk screen: (1) is it on your managed provider's allowlist (RDS/Aurora, Cloud SQL, Supabase, Neon each support different sets — check the actual list, not the extension's README); (2) who maintains it — core/contrib and company-backed extensions (**pgvector**, **PostGIS**, **pg_partman**, **TimescaleDB**, ParadeDB's **pg_search**) are safe bets, a solo-maintainer C extension is a fork-it-yourself commitment; (3) does it block major-version upgrades — every extension must have a release for the Postgres version you're upgrading to before you can move. The one-database call is about scaling axes, not purity: pgvector comfortably serves ~1–10M vectors with HNSW, PostGIS handles most geo workloads outright, and a `SELECT ... FOR UPDATE SKIP LOCKED` queue (or pgmq) beats adding Redis for modest job volume — but when a single workload sustains more than roughly a third of instance CPU/IO or needs its own scaling schedule, give it its own database (often still Postgres) before it takes down OLTP. Rule: **Adopt an extension only if it is on your managed provider's allowlist AND has a maintainer who ships releases for new Postgres majors — otherwise it is an upgrade blocker wearing a feature's clothes.**

BAD: "Add Elasticsearch, Redis, and Pinecone to the MVP stack so each workload has a best-of-breed tool" (three more systems to operate, back up, and keep consistent before product-market fit). GOOD: "pg_trgm + tsvector for search, SKIP LOCKED for jobs, pgvector for embeddings — one backup, one transaction boundary; split out the first workload that measurably starves the others."

```
EXTENSION DECISION SHEET
════════════════════════
BASELINE: pg_stat_statements · pgcrypto · pg_trgm · pg_cron [enabled? y/n each]
CANDIDATE: [extension] · workload: [vectors/geo/jobs/search/…]
PROVIDER SUPPORT: [RDS/CloudSQL/Neon/Supabase: yes/no/version]
MAINTENANCE: [core-contrib/company-backed/solo] · last release: [date]
UPGRADE RISK: [blocks PG major? data migration on upgrade?]
SCALE CEILING: [est. limit, e.g. ~10M vectors] · current: [n] · headroom: [x×]
VERDICT: [adopt in main DB / adopt in dedicated DB / use external system]
```

Skip when: you're on a platform that already dictates the stack (e.g., Supabase ships its curated set — use it), or the workload is definitively past Postgres scale (billions of vectors, planet-scale tile serving) and the split decision is already made.

Gotchas: extensions install per-database, not per-cluster, so staging "works" while production lacks the extension until someone runs `CREATE EXTENSION` there too; `pg_cron` on managed services often runs only in one designated database and silently no-ops elsewhere; extension upgrades (`ALTER EXTENSION ... UPDATE`) are separate from package upgrades and get forgotten for years; and pgvector index choice matters — an IVFFlat index built on 1k rows then grown to 5M gives garbage recall, so default to HNSW and reindex after bulk loads.
