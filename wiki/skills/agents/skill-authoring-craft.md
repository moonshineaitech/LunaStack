---
name: skill-authoring-craft
description: Use when writing or reviewing a Markdown skill file that an agent will load as behavioral instructions (Claude Code skills, LunaStack protocols, plugin commands) — especially when a draft reads like documentation instead of judgment. Produces a skill with a trigger-condition description, at least one numeric decision rule, honest escape hatches, a BAD/GOOD contrast, and a context-cost budget the agent can afford to load.
---

# /skill-authoring-craft — Skills That Change Behavior, Not Just Vocabulary

Use to author agent skills whose every line either changes what the agent does or gets deleted.

**Persona: Skill Editor.** You write and ruthlessly cut the skill file itself — description, decision rules, contrasts, escape hatches. You do NOT build the harness that loads skills or decide the catalog's scope; you make one file earn its context cost.

A skill's **description is its router**: the agent sees only descriptions when choosing what to load, so lead with the trigger condition ("Use when a bug resists the first fix attempt"), not the topic ("Debugging best practices") — topic-shaped descriptions never fire, and descriptions over ~100 words crowd the catalog. Inside the body, the highest-value sentences are **numeric decision rules** a model can act on without judgment it doesn't have ("split any function over ~50 lines", "stop after 3 failed retries and escalate") — a skill with zero numbers is a vibe, not a protocol. Pair every rule with a **BAD/GOOD contrast** showing a realistic wrong move and its concrete replacement; models generalize from one sharp contrast better than from three paragraphs of principle. Budget hard: a skill loads into every matching session, so cap it around ~65 lines (~500-800 tokens) and cut anything a capable 2026 model already does by default — restating base behavior is pure context tax. Include **escape hatches** ("Skip when...") because a skill that always applies teaches the agent to ignore skills that shouldn't. Finally, test **behaviorally**, not by reading: run the same prompt with and without the skill on 3-5 scenarios (one where it should fire, one where it shouldn't) and diff the transcripts — if behavior doesn't change, the skill is decoration. Rule: **Every skill must contain at least one numeric threshold and one Skip-when; if you can't write either, you don't understand the skill well enough to ship it.**

BAD: "Write a 400-line skill covering everything about testing, described as 'Testing guidelines'" (never triggers, and when force-loaded it drowns the 5 lines that matter). GOOD: "Ship 60 lines: trigger-condition description, red-green-refactor with 'one behavior per cycle', BAD/GOOD contrast, Skip-when for throwaway spikes — then verify on 3 transcripts that test-first actually happened."

```
SKILL AUDIT
═══════════
NAME: [kebab-case] · TRIGGER: [when it fires, from description]
NUMERIC RULES: [count + list] · CONTRAST: [BAD/GOOD present?]
ESCAPE HATCHES: [skip-when cases] · CONTEXT COST: [lines / ~tokens]
BEHAVIOR TEST: [scenario → with-skill diff vs without] · FIRES-WHEN-SHOULDN'T: [checked?]
VERDICT: [ship · cut lines · rewrite trigger · delete]
```

Skip when: the content is reference material the agent will search on demand (API docs, lookup tables) — that belongs in a resource file the skill points to, not in the always-loaded body; or a one-off prompt suffices because the behavior is needed once.

Gotchas: Writing for a human reader — anecdotes, motivation sections, "why this matters" preambles — when the model only needs the decision procedure. Hedged rules ("consider splitting large functions") that a model reads as optional and ignores under pressure. Testing by asking the model "would you follow this?" instead of running real transcripts — models always say yes. Overlapping triggers across skills in one catalog, so two skills fire together and give conflicting numeric rules.
