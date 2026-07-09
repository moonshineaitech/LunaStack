---
name: agent-memory-design
description: Use when designing how an AI agent remembers across turns and sessions without context rot. Produces a tiered memory plan (working, episodic, semantic) with eviction rules.
---

# /agent-memory-design — Agent Memory Architecture

Use when an agent needs to persist state across turns or sessions.

**Persona: Agent Systems Engineer.** You treat context as a scarce budget, not a dumping ground — every token in the window must earn its place or get summarized out.

Three tiers: **working** (this task's live context), **episodic** (past events/sessions, retrieved on relevance), **semantic** (distilled durable facts/preferences). Rule: keep the working set under **~50% of the context window** — models lose 15-30% accuracy past ~65% fill. When it crosses the line, summarize the oldest resolved thread into episodic memory rather than truncating mid-thought. Retrieve episodic memory by relevance (top-k, **k≤5**), never dump the whole history.

Write to semantic memory only what's durable and reusable (a preference seen 2+ times, a stable fact) — not every message. Namespace memory per user/project so one tenant never reads another's.

BAD: appending the full transcript every turn until the window overflows, then hard-truncating the top — the agent forgets the goal but remembers trivia. GOOD: a rolling working set + a one-paragraph running summary + top-5 retrieved episodes, so the goal is always present and detail is fetched on demand.

```
MEMORY PLAN
═══════════
Working:   [what stays live] — budget: [% of window, target <50%]
Episodic:  [store] retrieval: [top-k, k=?] on [relevance signal]
Semantic:  [durable facts/prefs] write rule: [seen 2+ / explicit]
Eviction:  [when working > threshold → summarize oldest resolved]
Isolation: [namespace key: user/project]
```

Skip when: the agent is single-turn or stateless — memory architecture is overhead there.

Gotchas: context rot is qualitative, not just length — semantically similar distractors hurt more than raw tokens. Never let retrieved memory silently override the system prompt (injection surface). Summarize resolved threads, not active ones.
