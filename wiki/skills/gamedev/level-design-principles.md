---
name: level-design-principles
description: Use when designing a game level or diagnosing one where playtesters get lost, bored, or exhausted. Produces a blockout-first plan with landmark (weenie) placement, an intensity pacing curve, guided-freedom navigation techniques, and a playtest protocol with concrete iteration gates before any art dressing begins.
---

# /level-design-principles — Guided Freedom, Blockout First

Use to design or fix a level using landmark-driven navigation, deliberate pacing curves, and playtest-gated iteration — before a single art asset is placed.

**Persona: Senior Level Designer.** Becomes the designer who sculpts player attention and flow in greybox, watches silent playtests, and cuts beloved spaces that don't serve pacing. Does NOT dress levels in art, write narrative, or defend a layout against playtest data.

Practice **guided freedom**: players should feel free while being steered. The primary tool is the **weenie** (Disney's term) — a dominant visible landmark that orients from anywhere; every navigable space needs one, and any playtest where a player can't point toward their objective within ~3 seconds of being asked marks a landmark failure. Layer the quieter tools: light draws (players walk toward brightness), contrast and color-coding (Mirror's Edge red, The Last of Us yellow), framing through doorways, breadcrumb pickups, motion, and denial-and-reward (show the goal, take it away, route the player scenically back). Design the **pacing curve** before geometry: plot intensity over time as rising action with valleys — commonly no more than ~3-5 minutes of sustained high intensity before a deliberate calm pocket (vista, safe room, loot alcove), because tension without release reads as noise and exhausts players. Enforce **blockout-first discipline**: greybox in ProBuilder/UE modeling tools/CSG, playtest in greybox, and hold a hard gate — no art pass until the blockout survives ~5+ playtests with navigation and pacing goals met, since art on a broken layout makes every fix 10x costlier and teams stop fixing. Run playtests silent: no hints, no steering; record where testers look, stall, and backtrack (heatmaps or just timestamps), then change ONE variable per iteration so you know what worked. Rule: **No art dressing until the greybox passes silent playtests — if a tester gets lost in grey boxes, they'll get lost in the finished level, just more expensively.**

BAD: "Testers keep missing the exit — add an objective marker and a bigger arrow" (UI band-aids over spatial failure; the level still reads wrong and every future space will need the same crutch). GOOD: "Rework the sightline: raise the exit, backlight it, add a vertical landmark visible from the confusion point — retest with markers off."

```
LEVEL DESIGN BRIEF
══════════════════
Fantasy/beat: [what this level is about, one line]
Weenie: [primary landmark · visible from where]
Guidance: [light/color/framing/breadcrumb techniques per junction]
Pacing: [intensity curve beats · calm pockets every ≤3-5 min]
Critical path: [target time] · optional: [% space off-path]
Blockout gate: [≥5 silent playtests · lost-check pass · stall points fixed]
Iteration log: [test # · one change · result]
```

Skip when: procedurally generated layouts (invest in the generator's grammar and validators instead) or linear cinematic corridors where scripting, not navigation, carries the experience.

Gotchas: designing for yourself — after 50 hours in the editor you cannot experience being lost, so your own runthroughs prove nothing; explaining the level to playtesters mid-test destroys the data (shipped copies don't come with you attached); polishing one favorite room while the macro flow is unproven; treating backtracking as free — the same corridor walked twice without new content is where players quit; adding freedom by deleting guidance, which yields aimlessness, not agency.
