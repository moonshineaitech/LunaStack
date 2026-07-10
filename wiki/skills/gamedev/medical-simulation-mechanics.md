---
name: medical-simulation-mechanics
description: Use when building simulation mechanics with medical content — triage systems, vitals models, first-aid sequences, diagnosis gameplay — choosing the right fidelity tier so the sim is directionally faithful, fun, and never credibly wrong. Design methodology for games (e.g. LunaCelsus), not medical simulation for training. Produces a fidelity-tier spec per mechanic.
---

# /medical-simulation-mechanics — Simulate Honestly at the Right Fidelity

Use to design medical simulation gameplay — vitals, triage, procedures, diagnosis — where the craft question is *which fidelity tier*, and the safety question is *never credibly wrong*.

**Persona: Simulation-Mechanics Designer, medical flavor.** You pick fidelity deliberately per mechanic and keep the sim's claims honest. This designs *entertainment* simulation: it is **not** a medical training device, doesn't certify anyone, and says so in-game. Anything approaching real procedural teaching escalates to expert review (see health-game-content-review); the game's diagnosis play stays a *game* — like the health domain itself, it renders probabilities and puzzles, never real-world verdicts.

**Game sim, not training sim.** Directional faithfulness is the bar: systems behave with the right *shape* (shock worsens untreated; rest aids recovery; wrong-priority triage costs). Precision cosplay — fake decimal vitals implying clinical accuracy — is dishonesty, not fidelity.

Design per mechanic on the **fidelity ladder**, and pick a rung on purpose. **Tier A — Abstract** (health bars, "stabilize" buttons): safest and often best; teaches nothing procedural, claims nothing, can't mislead — right answer for background content. **Tier B — Directional** (the workhorse): real *relationships* without real *procedures* — a triage mode where breathing-problems outrank broken arms (true and worth learning), vitals that trend plausibly (falling and fast-dropping reads as "bad and urgent" without fabricated precision), interventions at verb-level granularity ("give oxygen," "control bleeding") where sequencing/judgment is the gameplay but no rung teaches hand placement. Tier B is where LunaCelsus-style clinic play lives: source the relationships from published guidance, and let wrongness *in the fiction* teach (the deteriorating NPC shows why airway came first). **Tier C — Procedural** (step-by-step real interventions): the expensive rung — accurate end-to-end, expert-reviewed, and worth it only when teaching-the-real-thing is the design goal; half-remembered Tier C is the credibly-wrong disaster the content review exists to block. Cross-cutting rules: **diagnosis gameplay renders differentials, not verdicts** (the fun *is* uncertainty — evidence accumulates, hypotheses shift; a sim that rewards leaping to one answer trains the real-world error clinicians are trained out of); **death/failure has dignity** (patients are people even as NPCs — no comedy corpses in a mode claiming medical seriousness); **the sim admits its edges** (codex: "simplified for play; real triage is run by trained professionals — here's the real version"); and **crisis-adjacent scenarios carry real resources** (a psychiatric-crisis patient in the clinic mode surfaces 988-style help by the same rule as all crisis content). Rule: **choose the tier per mechanic — Abstract when content is background, Directional (sourced relationships, verb-level actions) as the default for play, Procedural only with expert review — and never ship the middle-tier lie: procedural-looking steps with made-up medicine.**

BAD: vitals with four decimal places, a "diagnose in one guess for bonus XP" mechanic, and a defibrillator minigame with invented paddle steps — precision cosplay + verdict-rewarding + credibly-wrong procedure, the full trifecta. GOOD: "Clinic triage is Tier B: severity relationships from published triage education, actions at 'open airway / control bleeding' verb level, vitals as trends not decimals, differential-based diagnosis where premature certainty costs you, dignified fail states that show the why — and the codex says 'simplified for play' and links real first-aid training. The one Tier C sequence (hands-only CPR rhythm) shipped only after our medical reviewer signed off."

```
SIM-MECHANIC FIDELITY SPEC — [mechanic]
═══════════════════════════════════════
Tier: [A abstract | B directional (DEFAULT) | C procedural → expert review REQUIRED]
Sourced relationships: [what real guidance the behavior-shape comes from]
Action granularity: [verb-level ("control bleeding") — no procedural steps unless Tier C]
Vitals honesty: [trends/states, no fake precision]
Diagnosis play: [differential + evidence, uncertainty rewarded — no one-guess verdicts]
Fail states: [teach the why · dignity preserved]
Edges admitted: [codex "simplified for play" + pointer to the real thing]
Crisis content: [988-style resources where the rule applies]
```

Skip when: the mechanic has no medical content, or it's meant to actually train real procedures — that's a regulated training-sim problem with medical educators, not a game-design skill.

Gotchas: the middle-tier lie — procedural look, invented medicine — is the one unshippable thing; abstract harder or review harder. Fake precision (decimal vitals) claims accuracy the sim doesn't have; trends are honest and read better anyway. One-guess diagnosis mechanics train overconfidence — make accumulating evidence the fun. Tier B relationships still need sourcing; "feels medical" is how other games' errors propagate.
