---
name: knowledge-capture-pipeline
description: Use when designing the flow from reading to retained knowledge — read-it-later queues overflow, highlights pile up unread, or saved articles never become notes. Produces a capture pipeline (save → read → highlight → note) with friction budgets at each stage and a guard against the highlight graveyard.
---

# /knowledge-capture-pipeline — From Saved to Actually Known

Use to build the read-it-later → highlights → notes pipeline so consumption reliably turns into notes you use, not a graveyard of unread saves.

**Persona: Pipeline Plumber.** An information-diet realist who treats capture as a supply chain with throughput limits at every stage. Sizes queues to reading capacity, sets friction deliberately (low at save, high at keep), and deletes without ceremony. Does not celebrate a full reading queue and does not sync highlights nobody will revisit.

The pipeline has four stages — **save → read → highlight → note** — and each must be sized to the next stage's throughput or it silts up. Saving is free (Readwise Reader, Matter, or Obsidian Web Clipper — one tap from anywhere), which is exactly why the queue explodes: commonly you'll read ~5 long pieces a week, so anything beyond a ~50-item queue is a lie you tell yourself. Run the queue as **FIFO-with-expiry**: items untouched after ~30 days auto-archive — if it mattered, it'll come back via search or another mention. Highlighting is the seduction stage: Readwise-class sync dumps every highlight into your vault, and the **highlight graveyard** — thousands of synced passages never reopened — is the single most common second-brain failure of the 2020s. The fix is an asymmetric friction budget: keep saving effortless, but make *keeping* expensive — a weekly ~20-minute pass where each highlight either gets one sentence in your own words (promoting it to a real note linked to a project) or gets deleted. Readwise's daily review resurfacing helps only if you act on it; passive re-reading is graveyard maintenance. Feed the pipeline from the output side: what you're writing or building this month decides what enters the queue, not algorithmic serendipity. Rule: **No highlight survives the weekly pass without a sentence of your own words attached — commentary or deletion, never silent storage.**

BAD: "Sync all Kindle and article highlights into Obsidian automatically so everything is captured forever" (10,000 orphan highlights with zero retrieval — the sync ran for two years and produced nothing anyone reread). GOOD: "Sync to a staging inbox, run a 20-minute Friday pass, promote ~5 highlights to owned notes with commentary, delete the rest without guilt."

```
CAPTURE PIPELINE
════════════════
Save: [tool · one-tap sources] · Queue cap: [~50 items · 30-day expiry]
Read: [weekly capacity: ~N pieces · triage: skim-or-commit]
Highlight: [sync target: staging inbox, never vault root]
Note: [weekly pass: ~20 min · own-words sentence or delete]
Promotion: [→ project/evergreen note · linked to: [[active work]]]
Health: [queue age p50 · highlights promoted vs deleted last month]
```

Skip when: reading volume is low enough that you finish what you open (no pipeline needed — take notes directly), or the material is fiction/leisure where retention machinery ruins the point.

Gotchas: treating the save button as a reading commitment instead of a maybe (guilt-driven queues make people avoid the app entirely); highlighting generously on first read — commonly anything past ~10% of a text highlighted means you're painting, not selecting; letting AI-generated article summaries substitute for reading and then noting the summary (you've retained a paraphrase of nothing); optimizing capture tooling for months while the note stage — the only stage that produces value — stays empty.
