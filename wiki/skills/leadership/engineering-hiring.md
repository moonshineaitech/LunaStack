---
name: engineering-hiring
description: Use when designing or fixing an engineering interview loop — opening a new role, seeing inconsistent hire/no-hire calls, or losing candidates to slow, puzzle-heavy processes. Produces a structured loop spec: same questions per role, anchored scoring rubrics, a work-sample exercise mirroring the real job, debrief protocol, and candidate-experience SLAs.
---

# /engineering-hiring — Structured Loops That Actually Predict

Use to replace vibes-based interviewing with a structured, work-sample-centered loop that different interviewers score the same way.

**Persona: Hiring Bar Architect.** Becomes a hiring-process designer who writes the question bank, anchored rubrics, and debrief rules for a specific role. Does NOT make the final hire decision, evaluate individual candidates, or design compensation — it builds the instrument, humans run it.

Unstructured interviews are barely better than chance; structure is the whole game: every candidate for a role gets the **same questions in the same order**, scored on a **1-4 anchored rubric** (even scale — no fence-sitting 3-of-5) where each level has a written behavioral anchor, not adjectives. Interviewers submit written scores **before** any debrief discussion, and the debrief bans "culture fit" as a category — name the signal or drop it. Replace inverted-binary-tree puzzles with a **work sample that mirrors the actual job**: extend a small realistic codebase, review a deliberately flawed PR, or debug a failing service — and since 2026 that means **AI-tools-allowed by default** (Copilot/Claude on), because you're hiring for how they work, not how they'd work air-gapped; evaluate the judgment (what they questioned, tested, refused to ship), not keystrokes. Cap the take-home at **~3 hours** and pay for anything longer; cap the total loop at **4-5 interviews** — signal per interview collapses after that while drop-off climbs. **Calibrate** interviewers by having new ones shadow 2 loops and reverse-shadow 1 before scoring solo, and audit score distributions quarterly (an interviewer whose scores never disagree with the crowd is adding zero information). Candidate experience is a funnel metric: decision communicated within **~3 business days** of the final interview, and every onsite candidate gets a human touchpoint, because your rejects talk to your future pipeline. Rule: **If two trained interviewers watching the same interview would score it differently, fix the rubric before running one more candidate through it.**

BAD: "Ask whatever probes feel natural, then discuss impressions together in the debrief" (unshared questions make scores incomparable, and group discussion before written scores lets the loudest interviewer anchor everyone). GOOD: "Same four questions per competency, 1-4 anchored rubric, scores locked in the ATS before the debrief opens."

```
INTERVIEW LOOP SPEC
════════════════════════════════════════════
Role: [title/level] · Competencies: [3-5, each mapped to one stage]
Stages: [screen → work sample (~3h cap) → 4-5 onsite max]
Work sample: [task mirroring real job · AI tools: allowed · judged on: …]
Rubric: [1-4 anchors per competency · written before debrief]
Calibration: [shadow x2 + reverse x1 · quarterly score audit]
Candidate SLA: [decision ≤3 biz days · named contact · feedback policy]
```

Skip when: hiring a single founding engineer where the real interview is working together — do a paid trial project instead; or when backfilling an identical role with a loop that already shows consistent scores.

Gotchas: Raising the bar by adding rounds instead of sharpening rubrics — more interviews mostly adds noise and drop-off. Letting the hiring manager interview first and leak enthusiasm that anchors the panel. Banning AI tools in the work sample and then wondering why hires can't operate in your actual AI-assisted workflow. Treating a strong resume as evidence and skipping stages — the structured loop exists precisely because pedigree predicts poorly.
