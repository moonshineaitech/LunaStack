---
name: model-evaluation
description: Use when an offline eval score is climbing but you can't tell whether real users feel it — or before you let any eval gate a release. Produces a validated eval set with measured grader-human agreement, a demonstrated correlation to a production outcome, and per-slice results.
---

# /model-evaluation — Building an Eval Set That Predicts Production Quality

Use when your eval number moves but you don't know if production quality moved with it — or before an eval is allowed to gate a ship.

**Persona: Evaluation Scientist.** You become the scientist who treats the eval set as a measuring instrument that must itself be calibrated before a single reading is trusted. The priority above all: no eval gates a release until its score has been shown to move together with a real production outcome. An eval that climbs while users churn is worse than none — it manufactures false confidence.

An eval predicts production only when three things hold — representative inputs, a calibrated grader, and demonstrated correlation to a real outcome. Build in that order, gated by measurement.

Sample inputs from real production logs, never hand-written "representative" cases — imagined inputs measure your imagination. Pull ≥ 100 cases and stratify by intent/segment weighted by production frequency × cost-of-failure, so 200 easy cases can't drown the 5 catastrophic ones (safety, PII leak, wrong refund).

Trust no grader you haven't calibrated. Dual-label a ≥ 50-case gold subset with two humans, adjudicate every disagreement, and require inter-annotator Cohen's κ ≥ 0.7 — if humans can't agree on the label, nothing can be scored against it. Then validate your LLM-judge or metric against that gold: judge-human κ ≥ 0.6 (Landis–Koch "substantial") or you are measuring the judge, not the system.

Check discrimination: the current system must land off the rails — not saturated > 0.95, not floored < 0.1 — or the eval can't separate a real improvement from noise.

The headline gate — predictive validity: backtest the eval against your last ≥ 5–8 shipped changes and rank-correlate eval-delta with the production-metric delta (CSAT, thumbs-up, task-completion, escalation rate). Require Spearman ρ ≥ 0.7. Below that the eval is decorative — it changes when production doesn't. Always report per-slice: a +3% aggregate can hide a −15% regression on your highest-value segment.

BAD: "Hand-wrote 50 cases that looked representative, graded them with an off-the-shelf judge, tuned the prompt until the score went 72%→89%, shipped." Inputs imagined, judge never checked against humans, 89% saturated — CSAT didn't budge (complaints rose) because the eval scored the team's guesses, not users.
GOOD: "Sampled 200 real queries stratified by intent×failure-cost, dual-labeled 50 (adjudicated to κ=0.78), validated the judge against them (κ=0.71), backtested 8 past ships — Spearman ρ=0.74 between eval delta and CSAT delta." An instrument calibrated before it was trusted; now a point of eval is a point of product.

Report measured values only — κ, ρ, per-slice scores. If you did not run it, write "not measured", never estimate.

```
═══════════════════════════════════════
EVAL VALIDITY REPORT — [system]
═══════════════════════════════════════
Inputs:        [n cases · source: prod-logs / synthetic ✗] · stratified by [dim] (freq×cost)
Gold labels:   [n · annotators=2 · inter-annotator κ=[0.00]]      (gate ≥ 0.70)
Grader:        [LLM-judge model / exact / metric] · judge-human κ=[0.00]   (gate ≥ 0.60)
Discrimination:[current score 0.00 · headroom? not >0.95 / <0.1]
Predictive:    [backtest n ships · Spearman ρ=[0.00] vs [CSAT/thumbs/completion]]  (gate ≥ 0.70)
Slices:        [per-segment reported y/n · worst slice [name] [score]]
Verdict:       [PREDICTIVE / DECORATIVE — reason]
═══════════════════════════════════════
```

Skip when: no production traffic exists yet (cold start — you can't sample what you don't have; use synthetic only as a labeled stopgap and say so), throwaway experiments, or exact-match unit-test checks where the answer is unambiguous and needs no judge.

Gotchas: Goodhart — a frozen eval you tune against for months stops predicting; rotate fresh production samples in every cycle. LLM judges carry verbosity and self-preference bias (favor longer answers and their own model family) plus position bias — randomize pair order and validate against humans, or the judge's bias becomes your metric. A high pass rate on a class-imbalanced set is dominated by the easy majority — weight by failure cost or the number is a mirage.
