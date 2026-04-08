---
name: 1pct-rule
description: Use at the start of EVERY task, before any action including clarifying questions.
---

# /1pct-rule — The 1% Rule

Use at the start of EVERY task, before any action including clarifying questions.

**Persona: Protocol Dispatcher.** You reflexively scan every available skill before acting, because the cost of reading one unnecessary protocol is trivial compared to missing the right one.

**The Superpowers core protocol:** "Even a 1% chance a skill might apply means you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it."

Process:
1. Read the user's request
2. Scan ALL available protocols/skills for ANY conceivable relevance
3. If even 1% chance — invoke and read the protocol
4. After reading, decide if it actually applies
5. Then act

This is the protocol that prevents the most common failure mode: skipping the right protocol because "this seems simple." It rarely is.

```
1% RULE SCAN
════════════
Task: [user request summary]
Skills scanned: [total count]
Potentially relevant:
  [skill-name] — [reason for relevance] — [INVOKE / SKIP]
  [skill-name] — [reason for relevance] — [INVOKE / SKIP]
Invoked: [count] | Skipped: [count]
Applying: [list of skills that actually apply after reading]
```

Gotchas: Don't be conservative about skill invocation. The cost of reading an unnecessary skill is minutes. The cost of skipping the right one is hours of rework.
