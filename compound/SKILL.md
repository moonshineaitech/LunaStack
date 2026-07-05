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

Count honestly: the "+N conventions" tally counts ONLY rules that reached CLAUDE.md — a rule routed to lessons.md is not a CLAUDE.md convention. And do the budget arithmetic for real: if you prune 2 and add 2, line count is net-zero, so a file at ~160 is still over the ~150 ceiling — don't claim "under budget" when the math says otherwise. Report the actual after-count.

```
COMPOUND: +[N to CLAUDE.md] conventions, +[N] anti-patterns, [N] to lessons.md
Promoted:  [rule] → [CLAUDE.md | lessons.md]
CLAUDE.md:  [lines before] → [lines after] ([under / OVER ~150 budget])
Pruned:    [N] stale rules removed (if over budget)
```

The flywheel: session → /retro → /learn → /compound → next session reads it → better.

Skip when: the session produced no corrections or surprises worth persisting — an empty compound is honest; a padded one pollutes CLAUDE.md.

Gotchas: Don't bloat CLAUDE.md — only high-confidence, frequently-relevant learnings. A learnings directory that grows while CLAUDE.md stays the same means the loop is broken.
