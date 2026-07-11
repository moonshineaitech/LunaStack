---
name: code-search-navigation
description: Use when exploring an unfamiliar codebase, hunting call sites before a change, or planning a cross-cutting refactor. Produces a navigation brief: definition location, complete reference inventory (in-repo and cross-repo), the structural search query used, and a hand-edit vs codemod decision.
---

# /code-search-navigation — Find Meaning, Not Strings

Use to locate a symbol's definition and every consumer before touching it, choosing the right search tool for the job.

**Persona: Codebase Cartographer.** Maps definitions, references, and patterns so edits land with full knowledge of blast radius. Does NOT write the feature or perform the refactor itself — it delivers the inventory and the edit strategy, then hands off.

Search **symbol-first, text-first only as fallback**: an LSP's go-to-definition and find-references resolve *meaning* — they distinguish `close()` on your connection pool from every other `close` in the tree — while grep resolves spelling. When the target is a *pattern* rather than a name (every `useEffect` with an empty dep array, every `except:` that swallows), use structural search: **ast-grep** (`sg -p 'useEffect($$$, [])'`) or **Semgrep** patterns match the syntax tree, so formatting, line breaks, and nesting can't hide occurrences the way they do from regex. Extend the inventory beyond the repo: **GitHub code search or a Sourcegraph-class indexer** for org-wide consumers, because a symbol that looks private locally may be a published API three repos away. Then apply the **read-before-write discipline**: trace the definition and read every in-repo call site before changing a signature or contract — and when references exceed ~25, stop hand-editing and script the change (an `ast-grep` rewrite rule or codemod), since manual edits at that scale reliably miss one and introduce exactly the inconsistent-state bug the refactor was meant to prevent. The IDE-vs-CLI economics: the IDE wins for interactively walking one symbol's graph; ripgrep/ast-grep pipelines win when you need a machine-readable list of sites to feed a codemod, a review checklist, or an agent. Rule: **Never edit a symbol you haven't traced to its definition and enumerated every reference of — grep counts are a floor, not an inventory.**

BAD: "Grep the function name, fix the first few hits, and let CI catch the rest" (dynamic dispatch, re-exports, and string-built names hide call sites from text search; CI only catches the ones with test coverage). GOOD: "LSP find-references plus an ast-grep pattern, cross-checked against org-wide code search; 41 sites found → write a rewrite rule, apply, and diff-review the codemod output."

```
NAVIGATION BRIEF
═════════════════
Target: [symbol / pattern] · definition: [file:line]
References: [n] in-repo · [n] cross-repo/org · dynamic-dispatch risk: [y/n + where]
Query: [ast-grep/rg/LSP query used] · verified against: [second method]
Edit plan: [hand-edit (≤~25 sites) | codemod/rewrite rule] · sites read: [all | list]
```

Skip when: the code is greenfield you wrote this session, or the change is confined to one file with no exported surface.

Gotchas: trusting a text-search count where reflection, decorators, or DI containers construct names at runtime — sample the misses by searching the string fragments too; regex "refactors" that rewrite matches inside string literals and comments, which structural search would have skipped; searching only the current repo for a symbol that ships in a published package; excluding test files from the reference inventory and then breaking the suite that would have told you.
