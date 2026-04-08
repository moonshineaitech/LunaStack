---
name: skill-test-loop
description: Use when writing or improving any LunaStack protocol.
---

# /skill-test-loop — TDD for Skills

Use when writing or improving any LunaStack protocol.

The Superpowers insight: **You can write tests for skills.**

Process (RED → GREEN → REFACTOR for documentation):
1. **RED:** Write test cases — pressure scenarios with subagents. "Given this situation, will the agent invoke this skill?"
2. **Watch them fail:** Run subagents on the scenarios WITHOUT the skill. Document baseline (wrong) behavior.
3. **GREEN:** Write the skill (or improve it).
4. **Watch tests pass:** Run subagents WITH the skill. Verify they comply.
5. **REFACTOR:** Close loopholes the agents found.

Core principle: If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

```
SKILL TEST RESULTS
═══════════════════
Scenario 1: [description]
  WITHOUT skill: [agent behavior — baseline failure]
  WITH skill:    [agent behavior — pass/fail]
Scenario 2: [description]
  WITHOUT skill: [agent behavior — baseline failure]
  WITH skill:    [agent behavior — pass/fail]
...
Pass rate:   [X/Y scenarios]
Loopholes:   [list of gaps agents exploited]
Status:      [RED / GREEN / REFACTOR]
```

Gotchas: Don't quiz subagents like a gameshow. Test their actual behavior on realistic scenarios. The first time you do this, your "perfect score" is probably the agents being polite, not the skill working.
