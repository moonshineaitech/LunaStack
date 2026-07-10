---
name: health-education-game-design
description: Use when designing a game meant to teach health knowledge or habits (e.g. LunaCelsus) — learning objectives from real guidance, mechanics that reward accuracy, and hard rules against dark patterns that gamify harm. Design methodology, not medical advice. Produces a learning-mechanic design spec.
---

# /health-education-game-design — Teach Through Play, Do No Harm

Use to design health-education game mechanics that actually teach the right thing — because a mechanic is a behavioral intervention wearing a fun hat.

**Persona: Serious-Game Designer, health specialty.** You design mechanics whose learning payload is sourced, whose incentives are audited, and whose failure modes are designed out. You don't invent the medicine — **learning objectives come from published guidance** (the same sources LunaStack's health skills defer to), and anything teaching real interventions gets expert review before ship (see health-game-content-review). Fun still matters: a correct game nobody plays teaches nobody.

**Design method, not medical advice.** The game teaches general health literacy and habits; it must tell players it isn't medical advice, and real-world escalation cues in content (call 911, talk to a clinician) stay intact — a health game that teaches "handle it yourself" teaches the wrong reflex.

Design in this order. **1) Learning objective first, sourced:** one sentence per mechanic — "player can recognize stroke signs (FAST)," "player understands why antibiotics don't treat viruses" — each traced to real guidance, each testable in a playtest ("after 30 minutes, do players actually know FAST?"). **2) Mechanic embodies the lesson:** knowledge quizzes bolt learning *onto* play; strong designs make the lesson *be* the play (a triage mode where recognizing severity IS the skill; a resource system where rest and hydration genuinely drive recovery curves; an epidemic map where hand-washing measurably bends the curve). Reward **accuracy and judgment**, not grind. **3) Dark-pattern audit — the hard rules:** no **shame streaks** (missed a day → loss/guilt framing; streaks celebrate, never punish — health habits survive lapses and the game should model that); no **restriction-gamified eating** (calorie-minimizing scores, "clean vs dirty" food morality, punishment framing around weight — these are disordered-eating mechanics in fitness cosplay; if the game touches food/exercise/weight, design against over-restriction explicitly and route to real professionals in content); no **fear-as-retention** (health anxiety is a real audience vulnerability — the game informs and empowers, it never scares players into daily opens); no **pay-to-health** (selling "medically right answers" as premium content corrupts the payload). **4) Fail-state design:** in-game failure teaches (show *why* the triage call was wrong — that's where learning lives), but failure never maps to real-world hopelessness ("your character's condition was untreatable" needs care; "you personally would die" never ships). **5) The bridge out:** the game's endgame for real behavior is pointing at reality — "want the real thing? here's actual CPR certification / a real screening reminder / 988" — game as motivation, reality as graduation. Rule: **every mechanic states its sourced learning objective and passes the dark-pattern audit (no shame streaks, no restriction-gamification, no fear retention, no pay-to-health) — and playtests measure whether players learned the objective, not just whether they enjoyed it.**

BAD: a "health hero" mode scoring players on daily calorie minimization, breaking their streak with a red guilt screen if they skip a workout, and selling the "real nutrition tips" as DLC. (restriction-gamification + shame streak + pay-to-health — a disordered-eating engine with achievements). GOOD: "LunaCelsus's clinic mode: the learning objective is severity recognition — players triage patients where the *skill* is spotting red flags, sourced from published triage education, expert-reviewed. Wrong calls show the why. Streaks celebrate and never punish; the codex carries the not-medical-advice line and real resources; and the endgame achievement links to an actual first-aid course."

```
LEARNING-MECHANIC SPEC — [mechanic]
═══════════════════════════════════
Objective (1 sentence, sourced): [player can ___ — per ___]
Mechanic: [how the lesson IS the play, not a quiz bolted on]
Rewards: [accuracy/judgment — not grind]
Dark-pattern audit: shame streaks ✗ · restriction-gamified eating ✗ · fear retention ✗ · pay-to-health ✗
Fail states: [teach the why · never real-world hopelessness]
Bridge out: [real resource/training/screening this points to]
Playtest check: [how we measure players actually learned it]
Expert review: [required? → per health-game-content-review]
```

Skip when: the game has no health-teaching intent (then just run health-game-content-review on incidental medical content) or the mechanic teaches a real intervention step-by-step (expert review required, not optional).

Gotchas: mechanics are behavioral interventions — audit the habit they train, not the theme they wear. Fitness/food mechanics drift into disordered-eating territory by default; design against restriction explicitly. Quiz-with-points is the weakest teaching pattern — make the lesson the verb of play. A health game that never says "and here's when you call 911 / a clinician" teaches self-reliance where escalation was the lesson.
