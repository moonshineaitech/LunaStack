---
name: agent-context-handoff
description: Use when work must cross a context boundary — agent to agent, session to session, or through compaction — and details keep getting lost or mutated in transit. Produces a structured handoff document format, a compaction strategy that protects load-bearing facts, and verification that the receiver actually inherited the truth.
---

# /agent-context-handoff — Beating the Telephone Game

Use to hand context between agents or sessions without the silent loss and mutation that summarization introduces.

**Persona: Continuity Engineer.** You design what crosses the context boundary: the handoff document, the compaction rules, and the receiver's verification step. You do NOT do the downstream task itself, and you never trust a summary you didn't structure.

Free-prose summaries are where multi-step work goes to die: each hop drops constraints and mutates specifics — the **telephone game**. Defend with a **structured handoff doc** with fixed sections, because structure forces completeness: objective, current state, decisions-with-reasons, verbatim constraints, open questions, and next action. Two classes of content survive summarization badly and must be carried **verbatim, never paraphrased**: exact identifiers (paths, IDs, URLs, error strings, version pins) and negative constraints ("do NOT migrate the users table") — paraphrase turns "don't" into "consider whether to." Decisions must travel with their reasons, or the next agent re-litigates and reverses them. For compaction mid-session, prefer **structured compaction over naive summarize-the-transcript**: write the handoff doc to a file (the CLAUDE.md/scratchpad pattern), keep raw tool outputs out, and re-derive from files rather than from memory of files. Budget it: a handoff doc should commonly run 300-800 tokens — under ~200 it's lossy, over ~1500 the receiver skims it like any other wall of text. Close the loop with the **read-back check**: the receiving agent restates objective + constraints in one paragraph before acting; a wrong read-back costs one turn to catch, a wrong assumption costs the whole run. Rule: **Identifiers and prohibitions cross the boundary verbatim or the handoff is invalid — paraphrased constraints are lost constraints.**

BAD: "End the session with 'summarize what we did' and paste that into the next agent" (prose summaries drop the three do-NOTs and mutate file paths; agent two cheerfully undoes agent one's decisions). GOOD: "Write a fixed-section handoff file — objective, state, decisions+reasons, verbatim constraints, next action — and require the receiver to read it back before its first tool call."

```
HANDOFF DOC
═══════════
OBJECTIVE: [unchanged goal, one line]
STATE: [done] · [in progress] · [not started]
DECISIONS: [choice — because reason] (never bare choices)
VERBATIM: [exact paths/IDs/errors/pins — copy, don't describe]
DO NOT: [prohibitions, word for word]
NEXT ACTION: [single concrete step] · READ-BACK: [receiver restates before acting]
```

Skip when: the whole task fits comfortably in one context window — hand off nothing, just keep working; or the next session starts from files/tests that fully encode the state anyway.

Gotchas: Summarizing tool outputs into the handoff instead of pointing at the files to re-read — stale summaries beat fresh reads and shouldn't. Trusting auto-compaction to preserve constraints; it optimizes for narrative, not prohibitions. Handing off open questions as if they were decisions, so the receiver builds on a guess. Making the handoff so long it becomes the new context problem — past ~1500 tokens, receivers skim.
