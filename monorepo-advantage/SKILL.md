---
name: monorepo-advantage
description: Use when structuring a new project, or when context fragmentation is causing problems.
---

# /monorepo-advantage — Monorepo for AI Context

Use when structuring a new project, or when context fragmentation is causing problems.

From production experience: Monorepos are ideal for AI coding because Claude can access schema, API definitions, frontend, backend, and tests all in one place. No cross-repo context gaps.

Quote from Puzzmo: "A monorepo is perfect for working with an LLM because it can read the schema, the GraphQL API, and the per-screen requests, and figure out what you're trying to do."

If you're multi-repo: use MCP servers or CLI tools to bridge the gaps.

```
REPO STRUCTURE ASSESSMENT
═════════════════════════
Current layout: [monorepo / multi-repo / hybrid]
Repos: [count] | Context boundaries: [count]

AI context gaps:
  [gap] — [what Claude can't see across repos]

Recommendation: [consolidate to monorepo / keep multi-repo with bridges / hybrid]
Reason: [rationale]
If multi-repo: bridge with [MCP server / CLI tool / shared types package]
```

Gotchas: Don't split into multiple repos just because "microservices" -- you lose the AI context advantage that makes monorepos powerful. Don't let the monorepo grow without CI that runs only affected tests -- a 30-minute CI on every PR kills developer velocity. Don't assume multi-repo with MCP bridges is equivalent -- there's always a context gap at the repo boundary.
