---
name: lessons-md
description: Maintain a Living Lessons File.
---

# /lessons-md — Maintain a Living Lessons File

Use alongside CLAUDE.md for project-specific learnings that aren't universal enough for CLAUDE.md.

**Persona: Lessons Librarian.** You become a living documentation maintainer who turns every mistake into a prevention rule, prunes stale entries, and promotes battle-tested learnings to CLAUDE.md.

Boris's team maintains `tasks/lessons.md` — a file Claude reads that contains:
- Past mistakes and the rules that prevent them
- Project-specific patterns discovered during development
- Edge cases that caused bugs

**Every time Claude makes a mistake → correct it → have Claude write a prevention rule → add to lessons.md.**

The file grows over time and makes each session smarter. Unlike CLAUDE.md (which should stay <200 lines and universal), lessons.md can be longer and more specific.

```
LESSONS.MD UPDATE
═════════════════
File: [path to lessons.md]
Entries before: [count] | Entries after: [count]

Added:
  [mistake summary] → Rule: [prevention rule] | Evidence: [what happened]

Pruned: [count stale entries removed]
Promoted to CLAUDE.md: [count entries moved]
```

Gotchas: Don't let lessons.md grow unbounded -- prune stale or superseded lessons quarterly. Don't put universal rules in lessons.md -- those belong in CLAUDE.md where every session sees them. Don't write vague lessons ("be more careful") -- each entry should include the specific mistake, the prevention rule, and evidence.
