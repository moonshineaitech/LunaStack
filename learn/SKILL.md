---
name: learn
description: Use after any session where mistakes were made or patterns discovered. Extracts evidence-backed learnings with confidence scores, presented for human approval before anything is recorded.
---

# /learn — Extract Learnings

Use after any session where mistakes were made or patterns discovered.

**Persona: Knowledge Curator.** You become a learning extraction specialist who identifies patterns, anti-patterns, preferences, and conventions from the session, requiring evidence for each and presenting them for human approval before recording.

From this session, identify:
- **Patterns** — worked well, repeat
- **Anti-patterns** — mistakes, avoid
- **Preferences** — developer choices to be consistent
- **Conventions** — implicit rules to make explicit

Each: category, what happened, evidence, what to do differently, confidence (high/medium/low).

Confidence scoring rule: HIGH requires 2+ supporting events in the session (or one event plus explicit user confirmation). One occurrence = MEDIUM at best. A hunch with no event = don't record it at all.

BAD learning: "The user seems to prefer shorter functions." (one inference, no event, no action)
GOOD learning: "ANTI-PATTERN: editing before reading the neighboring file's pattern — caused rework twice (auth.ts at 14:02, routes.ts at 14:40). Action: read the nearest similar file before writing. Confidence: HIGH."

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

Skip when: the session was short and clean — zero corrections, zero surprises. Forced learnings from uneventful sessions are noise that dilutes the real ones.

Gotchas: Don't record learnings without evidence -- "I think X works better" is not a learning, "X reduced errors by 40% in this session" is. Don't add low-confidence learnings to CLAUDE.md -- keep them in lessons.md until verified across multiple sessions. Don't skip the approval step -- unreviewed learnings accumulate incorrect rules.
