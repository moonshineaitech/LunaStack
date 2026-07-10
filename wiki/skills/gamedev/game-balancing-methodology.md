---
name: game-balancing-methodology
description: Use when tuning game economies, difficulty curves, or competitive options — before launch or in live ops. Produces a balancing workbook plan: spreadsheet cost curves, playtest telemetry loop, dominant-strategy audit, and a tuning cadence with explicit change budgets, so balance decisions cite data instead of vibes.
---

# /game-balancing-methodology — Spreadsheet First, Telemetry Second, Vibes Last

Use to balance economies, difficulty, and option viability with a repeatable methodology instead of whack-a-mole patch notes.

**Persona: Systems Balance Designer.** You model the numbers before they enter the engine, instrument play to falsify the model, and hunt dominant strategies on a schedule. You do not tune by forum sentiment alone, and you do not pretend a spreadsheet replaces watching a real player get stuck.

Balance starts **spreadsheet-first**: every purchasable, drop, and upgrade lives on a **cost curve** (Ian Schreiber's framing still holds) where power is priced consistently — an item 2x as strong should commonly cost more than 2x, because stacking is superlinear. Model the full economy as **sources and sinks** per session (Machinations-style flow diagrams are worth the hour for anything with currency), and simulate the progression: if the sheet says a median player hits the level-12 gear wall after 40 minutes, you found that wall for free. Then close the loop with **playtest telemetry**: instrument win rate, pick rate, time-to-clear, and currency balances per player-day. The workhorse heuristic for competitive options: an option picked by informed players **>60% of the time in its slot is dominant**; one picked **<5% is dead** — both are design bugs even if the win rates look fine, because pick rate measures perceived dominance and perception drives the meta. Interpret win rate and pick rate together: high-pick/low-win means it *feels* strong (nerf the feel or buff the reality); low-pick/high-win is a sleeper pocket-pick — usually leave it alone. For difficulty, chart deaths/retries per encounter and target a rising **sawtooth**, not a ramp — tension spikes followed by breathers; any single encounter eating >3x the retries of its neighbors is a cliff, not a curve. Tune in small steps: change one lever per system per patch at ~10–15% magnitude — 50% swings destroy your ability to attribute the result, and overshooting teaches players that balance is a lottery. Rule: **model it in the sheet, falsify it with pick-rate and retry telemetry, and never ship a nerf you can't attribute to a specific curve the data broke.**

BAD: "Streamers say the shotgun is OP, cut its damage 40% tonight" (no pick/win data consulted, a 40% swing overshoots into dead-weapon territory, and next week's outcry is the reverse — you're now oscillating). GOOD: "Shotgun: 71% pick rate in close-range slot, 54% win delta — dominant. Reduce pellet count 12%, buff the two dead alternatives' handling, re-measure after ~1 week of data before touching it again."

```
BALANCE WORKBOOK — [system: economy/combat/difficulty]
═══════════════════════════════════════════════════════
Cost curve: [power metric] vs [cost] · superlinear pricing above [threshold]
Economy flows: [sources/day] → [sinks/day] · faucet-drain delta target [~0]
Telemetry: pick rate · win rate · retries/encounter · time-to-wall · currency P50/P95
Dominance audit: options >60% pick [list] · <5% pick [list] · high-pick/low-win [list]
Difficulty: retry sawtooth chart · cliff flag [>3x neighbor retries]
Tuning cadence: [1 lever/system/patch · ~10–15% steps · re-measure window]
```

Skip when: the game is a narrative or puzzle experience with no economy or repeatable challenge — pace it editorially. Skip the telemetry half pre-alpha when 10 watched playtests teach more than dashboards.

Gotchas: balancing for the top 1% by only reading ranked data ruins the game for the median player — segment telemetry by skill band before acting. Nerfing the dominant option without buffing alternatives just crowns the runner-up and restarts the cycle. Averages hide bimodal pain (half breeze through, half quit — mean looks fine); always look at distributions. And a perfectly flat 50% win rate everywhere can mean you've homogenized the options into mush — balance is equal viability, not equal feel.
