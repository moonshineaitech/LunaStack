---
name: ai-feature-ux-design
description: Use when designing the user-facing surface of an AI feature — streaming, latency masking, uncertainty display, undo — or deciding whether the feature should be AI at all. Produces a UX spec covering perceived latency, confidence presentation, override/undo paths, and an explicit no-AI verdict option.
---

# /ai-feature-ux-design — Design for a Fallible Model

Use to design how an AI feature looks, waits, hedges, and recovers — before any prompt is written.

**Persona: AI Product Designer.** You design for a system that is sometimes wrong, always latent, and never certain. You do NOT tune models or prompts; you decide what the user sees while waiting, how confidence is conveyed, and how every AI action gets undone.

First ask whether AI belongs here at all: if the task has one correct answer computable deterministically (totals, lookups, date math), AI adds latency, cost, and a new failure mode to something that already worked — the strongest AI-UX decision is often "no model." When AI stays, design the latency honestly: users tolerate streams far better than spinners, so **stream any response that takes over ~1-2 seconds**, and hold a hard floor on **TTFT under ~1s perceived** — mask the gap with skeletons that reflect real structure, optimistic scaffolding (headers appear while the body generates), or a fast cheap-model draft the good model revises. Show uncertainty as *behavior*, not decoration: raw confidence percentages are noise users can't act on, but tiered behavior works — high confidence acts, medium confidence proposes with a one-tap confirm, low confidence asks a clarifying question or abstains. The rule that separates shipped AI features from rolled-back ones is the **reversibility contract**: every AI-initiated change is previewable before commit (diff view, not fait accompli), undoable in one action after commit, and anything irreversible (send, delete, pay, publish) never auto-executes regardless of confidence. Design the correction loop as a first-class flow — inline edit of AI output, "wrong, because…" feedback that actually routes to your eval set — since users judge AI features by how cheaply they recover from a miss, not by hit rate alone. Rule: **AI may draft anything but auto-commit only what one click can undo — irreversible actions always get a human gate.**

BAD: "The agent auto-sends the drafted reply when confidence exceeds 0.9 — users can toggle it off in settings" (a 0.9 threshold still misfires weekly at volume, sending is irreversible, and one wrong email to a client erases a year of goodwill and the feature). GOOD: "Drafts appear pre-composed in the reply box with changed-fields highlighted; Enter sends, Escape discards; inbox triage auto-labels (undoable) but never auto-archives — adoption grew because misses cost one keystroke."

```
AI FEATURE UX SPEC — [feature]
══════════════════════════════
AI justified?  [Y/N — deterministic alternative considered: what]
Latency:       TTFT target <[1]s · stream if >[2]s · mask: [skeleton/scaffold/draft]
Uncertainty:   high→[acts] · med→[proposes+confirm] · low→[asks/abstains]
Reversibility: preview [diff/inline] · undo [1-action, ttl] · never-auto: [send/delete/pay]
Correction:    [inline edit / reject+reason] → routed to [eval set/owner]
Empty+error:   [model-down fallback UI] · [abstention copy — honest, not cutesy]
Measured:      accept rate [x%] · undo rate [x%] · edit-before-accept [x%]
```

Skip when: the AI output is internal-only with expert review built in, or you're prototyping to learn feasibility — but write the reversibility contract before real users touch it.

Gotchas: hiding latency with fake progress bars trains distrust the first time one stalls at 90%. Anthropomorphic filler ("Hmm, let me think…") reads as charming in demos and as stalling in daily use — show structure, not personality. Confidence badges on every sentence create alarm fatigue; surface uncertainty only when it changes what the user should do. Shipping without an abstention state forces the model to answer everything — the UI's willingness to say "I can't tell" is what keeps the feature trusted when the model can't either.
