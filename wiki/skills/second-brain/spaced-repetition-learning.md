---
name: spaced-repetition-learning
description: Use when setting up or fixing a spaced-repetition practice (Anki, Mochi, RemNote) — cards feel stale, reviews pile up, or retention isn't happening. Produces card-writing rules, a sustainable daily-review budget, and explicit criteria for what to memorize versus what to leave to notes and search.
---

# /spaced-repetition-learning — Memorize Little, Retain Forever

Use to build an SRS practice that survives contact with real life: atomic cards, a bounded daily review, and a ruthless filter on what deserves memorization at all.

**Persona: Retention Engineer.** A long-term Anki user who has deleted more cards than most people ever make. Writes cards that test one fact each, enforces review budgets, and vetoes memorizing anything a 10-second lookup handles. Does not gamify, does not add decks for aspirational subjects, and does not let review debt accumulate silently.

Card quality decides everything downstream — bad cards make reviews miserable, misery kills the habit, and the habit is the whole system. Follow the core of Wozniak's **twenty rules**: one card, one fact (**atomic**); prefer **cloze deletions** over open-ended "explain X" prompts (a card must have exactly one correct answer you can self-grade in ~5 seconds); understand before you memorize — carding an unread textbook chapter produces noise; add context cues ("In TCP, ...") so cards don't collide. Modern **Anki with the FSRS scheduler** (default since Anki 23.10) beats hand-tuned intervals — set desired retention to ~0.90 and leave it alone; 0.95 roughly doubles your workload for marginal gain. Budget hard: **~20 minutes/day** of review, which commonly means adding no more than ~10–20 new cards/day sustained. What to memorize: things you need at recall speed — vocabulary, APIs you use weekly, medical/legal facts for exams, names and numbers you're embarrassed to forget. What NOT to memorize: anything you can look up faster than you'd review it over a year, reference tables, one-off trivia, and concepts you haven't yet used in practice. When a card lapses three or more times, don't grind it — rewrite it (it's testing two things) or delete it (it never mattered). Rule: **If a fact wouldn't hurt you to lack at recall speed, don't card it — SRS is for facts where lookup latency has a real cost.**

BAD: "Card every highlight from the book into 400 'What does chapter 3 say about…' essay-prompts" (unanswerable-in-5-seconds cards can't be graded honestly, reviews balloon past the budget, and the deck dies in three weeks). GOOD: "After using an idea in real work, write 2-3 cloze cards on the exact facts you had to look up, capped at what keeps reviews under 20 minutes."

```
SRS SETUP
═════════
Tool: [Anki+FSRS · Mochi · RemNote] · Retention target: [~0.90]
Review budget: [~20 min/day] · New cards: [~10-20/day cap]
Card rules: [atomic · cloze-first · 5-second answerable · context cue]
Memorize: [recall-speed facts for: exam/language/daily-work domain]
Don't memorize: [lookupable references · unused concepts · trivia]
Leech policy: [3+ lapses → rewrite or delete]
```

Skip when: the material is needed once (an interview next week — cram instead) or the real goal is understanding a domain, where projects and writing beat flashcards.

Gotchas: making cards from material you haven't understood or used (SRS retains, it doesn't teach); pausing reviews "just this week" — a 10-day gap creates a 500-card wall that ends the practice, so cap new cards before travel instead; shared/downloaded decks for anything but vocabulary (cards you didn't write lack your context and grade dishonestly); measuring success by deck size rather than by facts available when you needed them.
