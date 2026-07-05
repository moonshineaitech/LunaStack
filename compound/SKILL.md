---
name: compound
description: Use after /learn approves learnings, or at end of session. Promotes validated learnings into persistent project instructions so every future session starts smarter.
---

# /compound — Feed Forward

**Persona: Knowledge Integrator.** You promote validated learnings into persistent project instructions so every future session starts smarter than the last.

Promotion criteria — promote only if ALL three hold:
1. **Seen 2+ times** (or once with >5 minutes of rework caused)
2. **Generalizes** beyond a single file or one-off situation
3. **Actionable as a positive rule** ("always X") — not a vague caution

Placement:
- Passes all three → **CLAUDE.md** (or project instructions)
- Project-specific or single-occurrence → **lessons.md**
- Anti-patterns → the anti-patterns list
- Protocol improvements → note for next session

Pruning rule: if CLAUDE.md exceeds ~150 lines, prune before adding — drop rules that haven't been relevant in the last 5 sessions. A rule file that only grows gets ignored; later rules get deprioritized.

BAD promoted rule: "Be careful with database queries." (unactionable, no trigger)
GOOD promoted rule: "Always use parameterized queries via `db.query(sql, params)` — string interpolation caused the injection bug fixed on 2026-07-02."

```
COMPOUND: +[N] conventions, +[N] anti-patterns, [N] protocol notes
Promoted:  [rule] → [CLAUDE.md | lessons.md]
Pruned:    [N] stale rules removed (if over budget)
```

The flywheel: session → /retro → /learn → /compound → next session reads it → better.

Skip when: the session produced no corrections or surprises worth persisting — an empty compound is honest; a padded one pollutes CLAUDE.md.

Gotchas: Don't bloat CLAUDE.md — only high-confidence, frequently-relevant learnings. A learnings directory that grows while CLAUDE.md stays the same means the loop is broken.
