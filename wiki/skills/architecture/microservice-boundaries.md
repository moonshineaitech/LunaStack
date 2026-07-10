---
name: microservice-boundaries
description: Use when splitting a system into services or reviewing an existing split that hurts. Draws service boundaries from team ownership and change-coupling evidence, not entity nouns, and produces a boundary map with an explicit distributed-monolith risk check and a merge/split recommendation.
---

# /microservice-boundaries — Cut Along Teams, Not Nouns

Use to decide where service boundaries go — or whether they should exist at all.

**Persona: Skeptical Systems Architect.** Becomes the reviewer who demands evidence before every cut: team ownership, deploy independence, and commit-level change-coupling data. Draws and defends boundaries; does NOT write service scaffolding, pick frameworks, or bless a split just because the org already announced one.

The durable heuristic is inverse Conway: a service boundary is only real if exactly one team owns it end-to-end and can deploy it without a calendar invite. Before cutting, mine change-coupling from git history (tools like CodeScene, or `git log --format` co-change analysis): files that change together in >~30% of commits belong in the same service, whatever the domain model says. Entity-per-service ("UserService, OrderService, ProductService") is the classic trap — nouns share data, so you get a **distributed monolith**: N services, one lockstep release train, every request fanning out over the network. Run the litmus test on any proposed split: if a routine feature touches 3+ services, or services share a database schema, or you need **saga-style** coordination for everyday writes, the boundary is wrong — merge, don't add orchestration. Start with fewer: commonly 1 service per ~8-person team, and never more services than teams; a 15-engineer org rarely justifies more than 3-4 deployables. Extract only when a boundary has proven itself — divergent scaling profile, divergent release cadence, or a compliance blast-radius you must isolate — and extract along seams that already exist as modules (see /modular-monolith). Rule: **Never create more services than teams that can each own one outright; when a feature routinely spans 3+ services, merge boundaries instead of adding coordination.**

BAD: "One microservice per domain entity — Users, Orders, Payments, each with its own repo" (nouns co-change constantly, yielding a distributed monolith with network calls where function calls were). GOOD: "Mine 12 months of git history for co-change clusters, map clusters to owning teams, cut 3 services for 3 teams, keep the rest as modules."

```
SERVICE BOUNDARY MAP
════════════════════
Teams: [count] · Proposed services: [count] · Ratio check: [pass/fail]
Boundary: [name] · Owner: [team] · Deploys independently: [y/n] · Data owned: [stores]
Change-coupling: [top cross-boundary co-change pairs + %]
Distributed-monolith flags: [shared schema? · lockstep releases? · 3+ hop features?]
Verdict: [keep / merge X into Y / defer extraction until <trigger>]
```

Skip when: a single team owns the whole system (stay a monolith, use /modular-monolith), or the split is mandated by a hard compliance/isolation requirement that overrides coupling evidence.

Gotchas: splitting before the domain is understood locks in wrong boundaries at network cost — boundaries are cheap to move inside a monolith, brutal across services; shared libraries of domain models quietly re-couple "independent" services into lockstep upgrades; sizing services by lines of code ("it's too big") instead of ownership and change-rate; forgetting that every new boundary converts a refactor into a versioned API migration with deprecation windows.
