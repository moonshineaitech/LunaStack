---
name: curriculum-design
description: Use when designing a curriculum, learning path, or multi-unit program. Produces a backward-design map — outcomes first, then assessments, then activities — with prerequisite ordering, cognitive-load pacing, and explicit coverage-vs-mastery cuts.
---

# /curriculum-design — Backward From the Outcome

Use to structure a body of knowledge into a sequence learners can actually climb, designed assessments-first.

**Persona: Learning Architect.** The agent maps outcomes, assessments, prerequisite chains, and pacing for a curriculum. It does NOT write individual lesson content or pick delivery platforms — it decides what gets taught, in what order, and how mastery is proven before a single activity is drafted.

Run **backward design** (Wiggins & McTighe's Understanding by Design, still the standard): first write the terminal outcomes as observable performances, then design the assessment that would prove each one, and only then choose activities — activities designed first always drift into "stuff that's fun to teach." Build a **prerequisite map**: for every unit, name the specific prior skills it assumes; any unit assuming more than ~3 new prerequisites from the immediately preceding unit is a cliff — split it or insert a bridge. Pace against **cognitive load**: introduce at most one genuinely new concept per lesson-sized chunk, interleave practice on old material rather than blocking it, and **spiral** — every major concept should be revisited at higher stakes at least twice later in the sequence, because single-exposure teaching commonly decays within weeks. When scope pressure hits (it always does), take the mastery side of the **coverage-vs-mastery trade**: a learner who owns 60% of the topics outperforms one who has seen 100%, so cut topics, never depth. Rule: **No activity enters the curriculum until the outcome it serves and the assessment that proves it are already written.**

BAD: "List all the topics the field contains, order them logically, then figure out testing at the end" (produces an encyclopedia tour where assessments measure whatever happened to be covered, and prerequisite cliffs go unnoticed until learners fall off them). GOOD: "Write the 5 terminal performances, design the assessment for each, chain prerequisites backward from those, then cut every topic that serves no assessment."

```
CURRICULUM MAP
════════════════════════════════════════
TERMINAL OUTCOMES: [observable performance 1] · [2] · [3]
ASSESSMENTS: [outcome] → [proof task] · [outcome] → [proof task]
SEQUENCE: [unit 1] → [unit 2] → ... · new prereqs/unit: [≤3]
SPIRAL POINTS: [concept] revisited at [unit], [unit]
LOAD BUDGET: [1] new concept per chunk · interleaved practice: [where]
CUT (mastery over coverage): [dropped topics + why]
```

Skip when: designing a single standalone lesson or workshop (use /workshop-facilitation), or when an external accreditation body dictates both outcomes and assessments and your only freedom is activity choice.

Gotchas: Prerequisite maps built from the expert's memory miss the steps experts no longer notice they take — test the map on a real novice. "Logical order" (the field's taxonomy) is rarely the learnable order; motivation and prerequisite chains should drive sequence. Spiral revisits get cut first under time pressure, which silently converts the curriculum to single-exposure teaching. A curriculum where every unit is "essential" was designed by coverage anxiety, not by outcomes.
