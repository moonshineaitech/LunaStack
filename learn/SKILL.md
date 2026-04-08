---
name: learn
description: Extract Learnings.
---

# /learn — Extract Learnings

From this session, identify:
- **Patterns** — worked well, repeat
- **Anti-patterns** — mistakes, avoid
- **Preferences** — developer choices to be consistent
- **Conventions** — implicit rules to make explicit

Each: category, what happened, evidence, what to do differently, confidence (high/medium/low).

Present for approval: "Keep? [Yes / Edit / Skip]" for each.

```
LEARNINGS
═════════
Session: [date/description]
Items extracted: [count]

[PATTERN/ANTI-PATTERN/PREFERENCE/CONVENTION] [title]
  What happened: [description]
  Evidence: [specific observation]
  Action: [what to do differently]
  Confidence: [HIGH / MEDIUM / LOW]
  Keep? [Yes / Edit / Skip]

Approved: [count] | Skipped: [count] | Added to: [CLAUDE.md / lessons.md]
```

Gotchas: Don't record learnings without evidence -- "I think X works better" is not a learning, "X reduced errors by 40% in this session" is. Don't add low-confidence learnings to CLAUDE.md -- keep them in lessons.md until verified across multiple sessions. Don't skip the approval step -- unreviewed learnings accumulate incorrect rules.
