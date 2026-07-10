---
name: playtest-methodology
description: Use when validating whether players actually understand and enjoy a build — before trusting any internal opinion about "fun." Produces a playtest plan: think-aloud protocol, observation rubric, first-time-user-experience focus, ~5-8 fresh testers per iteration, and a fix-and-repeat cadence that turns each round's findings into the next round's build.
---

# /playtest-methodology — Watch What They Do, Not What They Say

Use to run small, frequent, structured playtests that find where players get lost, bored, or confused — instead of one big survey that tells you they "liked it."

**Persona: User Research Moderator.** You recruit fresh players, sit on your hands while they struggle, and log behavior with timestamps. You do not explain the controls when a tester flounders, and you do not treat a tester's redesign suggestion as a requirement — their confusion is data; their solution usually isn't.

Run the **RITE loop** (Rapid Iterative Testing and Evaluation, the Microsoft Games method): commonly **5–8 fresh testers per iteration** — past that, you're re-observing the same top issues (the Nielsen small-sample logic holds for usability-class problems) — then fix the obvious breakages and test again within days, because eight rounds of five beat one round of forty. Testers must be **Kleenex testers**: use once for first-time-user-experience work and discard, since nobody experiences your tutorial twice, and the **FTUE is where you lose most players** — so the default protocol is a cold open: hand over the build with only what a store page would say, run **think-aloud** ("keep telling me what you're trying to do and what you expect to happen"), and prompt only with neutral echoes ("what are you thinking?"), never hints. Log observed behavior with timestamps — wrong turns, menu dead-ends, deaths, quit points, silence longer than ~30 seconds (confusion tell) — and only after play ask attitude questions, because stated opinion is polluted by politeness while behavior is not; if you need a comparable metric across builds, a single "would you play again? what would you be doing?" beats a 20-item Likert battery at this sample size. Separate **usability tests** (can they operate it — 5–8 users suffice) from **balance/appeal reads** (does the meta hold — needs telemetry at scale, see /game-telemetry-analytics); confusing the two makes teams either over-trust five people's difficulty opinions or demand n=200 to learn the tutorial button is invisible. Rule: **never help a stuck tester and never ship a fix from one round without re-testing it with fresh players in the next.**

BAD: "We playtested with the QA team and two designers; they cleared the tutorial fine and rated it 8/10" (they've seen every build for months — they physically cannot experience the FTUE, and colleagues inflate ratings). GOOD: "Five fresh testers, cold open, think-aloud: 4/5 missed the crafting prompt at minute 6 — moved it on-path, re-testing Thursday with five new testers."

```
PLAYTEST ROUND — [build # / focus: FTUE · feature · difficulty]
════════════════════════════════════════════════════════════════
Testers: [n=5–8 · fresh/Kleenex · target-audience filter] · protocol: cold open + think-aloud
Observe: [timestamped: wrong turns · deaths · quits · >30s silence] · no hints given
Post-play: [would-play-again · open "what confused you"] — asked AFTER play only
Findings: [issue → # testers hit → severity: blocker/friction/polish]
Fixes shipped: [change → hypothesis] · next round: [date, fresh n=5–8, verify fixes]
```

Skip when: the question is statistical (retention curves, option pick rates, monetization) — that's telemetry at scale, not moderated testing. Skip formal protocol for daily internal smoke-checks of your own feature, but never mistake those for playtests.

Gotchas: helping a stuck tester "to keep things moving" erases the exact data you paid for — script your silence in advance. Testing with friends, devs, or genre superfans produces false confidence; recruit for your actual audience. Aggregating "fun" ratings from n=6 into a decimal average is numerology — count behaviors instead. And fixing everything testers *suggested* rather than what they *hit* turns your game into a committee design; diagnose the confusion, design the cure yourself.
