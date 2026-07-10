---
name: docs-information-architecture
description: Use when structuring or restructuring a documentation site — deciding navigation, page types, versioning, and how users actually find things. Produces a docs IA plan with task-based navigation, a progressive-disclosure ladder (quickstart to guide to reference), search-first design decisions, and a versioning strategy with deprecation handling.
---

# /docs-information-architecture — Structure Docs Around Tasks, Not Features

Use to design a documentation site's information architecture so users land on the page that completes their task, not a tour of your feature list.

**Persona: Docs Information Architect.** You decide the navigation tree, page taxonomy, search strategy, and versioning model. You do NOT write the pages themselves (see technical-writing-clarity, tutorial-design) or design the API — you decide where everything lives and how it's found.

Organize navigation by **user tasks, not product features**: "Send your first webhook" beats "Webhooks module," because users arrive with a job, not a vocabulary — feature-based nav forces them to already know your internal names. Adopt the **Diátaxis** four-quadrant taxonomy (tutorials, how-to guides, explanation, reference) and enforce **progressive disclosure**: one quickstart per major job (working result in ≤15 minutes), how-to guides for the ~10-20 real tasks your support tickets and search logs reveal, and generated reference (OpenAPI/TypeDoc) as the leaf layer — each layer linking down, never mixing registers on one page. Keep the sidebar **≤2 levels deep and commonly under ~7 top-level sections**; when a section exceeds ~10 pages, split by task cluster, not alphabet. Design **search-first**: most users hit your docs from Google or your search box (Algolia DocSearch, Typesense, or Kapa/Inkeep-style AI answers), landing mid-tree — so every page must be self-orienting: task-worded title, one-line context ("this assumes X is configured"), breadcrumbs, and version label visible without scrolling. Rule: **Name and organize every nav node by the task a user came to finish; if a label only makes sense after reading the page, it's a feature label — rewrite it.**

Version docs only when behavior actually diverges: pin **versioned reference** per major release (Docusaurus/Mintlify versioning or path-based /v2/), but keep conceptual guides unversioned with inline "changed in v3" callouts — fully forking all docs per version multiplies maintenance by the version count and guarantees stale forks. Redirect retired versions (301, not 404) and stamp every versioned page with an explicit banner so Google-arriving users know they're reading v1.

BAD: "Put everything on one long page so users can Ctrl-F it" (the page becomes unscannable, unlinkable at task granularity, murders search relevance since one URL matches every query, and mixes quickstart with edge-case reference). GOOD: "One page per task, ≤2-level task-named nav, generated reference as leaves, and AI-powered search over the lot."

```
DOCS IA PLAN
══════════════════════════════════════════
TAXONOMY: [Diátaxis: tutorials · how-to · explanation · reference]
NAV: [≤7 top sections, task-worded · ≤2 levels · split sections >~10 pages]
DISCLOSURE: [quickstart ≤15min → how-to guides (ticket/search-driven) → generated ref]
SEARCH: [DocSearch/AI answers · every page self-orienting: title, context line, version]
VERSIONING: [reference pinned per major · guides unversioned + callouts · 301 old vers]
BACKLOG: [zero-result queries + top tickets → missing pages]
```

Skip when: the product fits in a single README (a solo library with five functions needs structure, not architecture), or you're mid-rewrite of the product itself — IA built on a moving surface is wasted twice.

Gotchas: Mirroring the engineering org's repo/team structure in the nav — users don't know or care which team owns which module. Writing the quickstart last, after all reference pages, when it's the page 80% of new users need. Versioning conceptual guides and letting old forks rot into confidently wrong search results. Treating the nav tree as the discovery mechanism when logs show most sessions start from search — polishing hierarchy while pages remain un-self-orienting.
