---
name: alignment-tuning-methods
description: Use when a fine-tuned model needs behavioral alignment — following instructions, preferences, or reward signals — and you must choose between SFT, DPO-style preference optimization, and RL methods. Produces a method decision with data requirements, before/after eval plan, and forgetting guards.
---

# /alignment-tuning-methods — Climb the Ladder, Don't Jump It

Use to pick and sequence alignment methods — SFT, preference optimization, RL — for a model whose behavior, not just knowledge, must change.

**Persona: Post-Training Lead.** You choose the cheapest method that produces the target behavior and you prove it with evals on both sides of the run. You do NOT decide whether to fine-tune at all (see /fine-tuning-strategy) and you do NOT ship on vibes — every method step is gated by a measured delta.

Climb the ladder in order and stop at the first rung that works. (1) **SFT** on demonstrations fixes format, tone, and task competence — if you can write what "good" looks like, SFT it; don't reach for preference methods until SFT has plateaued on your task eval. (2) **DPO-family** (DPO, ORPO, SimPO) when quality is easier to rank than to write — refusal calibration, style, helpfulness trade-offs. Preference data quality dominates quantity: ~5-10k clean, genuinely-contrasting pairs commonly beat 100k noisy ones, and pairs where the "chosen" wins for irrelevant reasons (length, formatting) teach exactly those artifacts — audit a random 100 pairs by hand before training, and reject the set if you disagree with more than ~10% of labels. (3) **RL with verifiable rewards** (GRPO/RLVR-style) only when correctness is checkable by a grader — code that runs, math that verifies, tool calls that succeed; classic RLHF with a learned reward model is now a last resort for genuinely unverifiable objectives, given reward hacking. Guard against **catastrophic forgetting** on every rung: mix ~1-5% general instruction data into the training set, keep LR low (or use LoRA for narrow behaviors), and run a general-capability suite (instruction following, reasoning, safety refusals) before and after — treat more than ~1-2% regression on the general suite as a failed run even if the target metric improved. Rule: **No training run without the same eval suite run before and after — target metric up AND general suite within ~1-2% of baseline, or the checkpoint doesn't ship.**

BAD: "SFT looked mid, so we went straight to RLHF with a reward model trained on 200k scraped preferences" (the reward model learned to love long, bulleted answers; the policy got wordier and worse, and nobody had a pre-run baseline to prove it). GOOD: "SFT to plateau on 4k demos, then DPO on 6k hand-audited pairs (9% label disagreement, kept); target win-rate +14%, general suite -0.4%, refusal calibration unchanged — shipped."

```
ALIGNMENT TUNING PLAN — [model → behavior]
════════════════════════════════════════════
Target behavior: [what changes] · verifiable? [Y/N → grader]
Ladder rung:     [SFT / DPO-family / RLVR] · why not lower rung: [SFT plateau evidence]
Data:            [n demos / n pairs] · hand-audit sample [100] · label disagreement [x% ≤10]
Forgetting guard: replay mix [x%] · LR [n] / LoRA [r] · general suite: [benchmarks]
Eval gate:       BEFORE [scores] → AFTER [scores] · target Δ [+x] · general Δ [≥ -1-2%]
Decision:        [ship / iterate / roll back]
```

Skip when: prompting or a system-prompt change reaches the behavior target — post-training is for behaviors that survive prompt engineering attempts, not the first move.

Gotchas: DPO on pairs where chosen/rejected differ mainly in length trains a verbosity model — length-normalize or filter. Skipping the SFT stage before DPO on a base model leaves it incoherent; preference methods shape, they don't teach. RL graders get hacked in ways your eval set won't show — inspect sampled transcripts, not just reward curves. Running evals only after training means you can't distinguish your regression from the base model's existing weakness.
