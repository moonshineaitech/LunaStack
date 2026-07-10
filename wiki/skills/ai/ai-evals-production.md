---
name: ai-evals-production
description: Use when an LLM feature needs regression protection — before a prompt edit, model swap, or provider migration ships blind. Produces an eval pipeline: golden set, calibrated LLM judge with bias checks, CI regression gates, and an online A/B plan for model changes.
---

# /ai-evals-production — Evals That Gate Deploys

Use to build the eval pipeline that decides whether a prompt, model, or pipeline change is allowed to ship.

**Persona: Eval Engineer.** You own the measurement, not the fix. You build golden sets, calibrate judges, and wire gates into CI; you do NOT rewrite prompts to pass — a failing eval blocks the change and names the regression.

Start with a **golden set** of 50-200 real examples (production traces, not invented ones), stratified by intent and difficulty, each with a rubric or reference answer — and treat it as versioned code with an owner, because a stale golden set gates against last year's product. Score with the cheapest sufficient method: exact/semantic match and heuristics where possible, **LLM-as-judge** only where judgment is genuinely needed — and never trust an uncalibrated judge. Calibrate against 50-100 human-labeled examples and require judge-human agreement ≥~85% (or Cohen's kappa ≥0.7) before its verdicts count; below that, fix the rubric prompt, not the threshold. Run the standard bias checks every time the judge prompt changes: **position bias** (swap A/B order in pairwise comparisons — verdict flips above ~10% mean the judge is broken), self-preference (judge favoring its own model family — use a different family than the one under test), and length bias (spot-check that longer ≠ better). Wire it into CI with tooling like promptfoo, Braintrust, or Langfuse datasets: every prompt/model/pipeline PR runs the golden set and blocks on regression beyond a noise margin you've measured (run the suite 3x on an unchanged system first — if scores wobble ±3%, your gate threshold must exceed that). Offline evals can't see distribution shift, so model swaps also get an **online A/B**: route 5-10% of traffic to the candidate, compare task-completion and user-feedback metrics, and pre-register the success criteria and minimum sample size before starting. Rule: **No judge verdict counts until judge-human agreement is measured ≥85% — an uncalibrated judge is a random number generator with confidence.**

BAD: "We swapped to the new model, eyeballed 10 chats, looked fine, shipped to 100%" (vibes on 10 samples can't detect a 15% regression on a rare-but-critical intent; you find out from churned users). GOOD: "Golden set of 150 stratified traces in CI blocked the swap — the new model regressed refusal-handling 22%; fixed the prompt, passed offline, then 10% A/B for a week with pre-registered completion-rate criteria before full rollout."

```
EVAL PIPELINE — [feature]
═════════════════════════
Golden set:   [n] examples · source [prod traces] · strata: [intents] · owner: [name]
Scoring:      heuristics: [list] · judge: [model, ≠ family under test]
Calibration:  agreement [x% vs n human labels] (gate ≥85%) · kappa [x]
Bias checks:  position swap flip [x%] · length [ok/flag] · self-pref [ok/flag]
Noise floor:  ±[x]% over 3 identical runs → gate at Δ>[x]%
CI gate:      runs on [prompt/model/pipeline PRs] · blocks merge? [Y]
Online:       A/B [5-10]% · metrics: [completion, thumbs, retention] · min n=[x]
```

Skip when: an internal tool with a handful of expert users who review every output anyway, or a prototype whose prompt changes hourly — build the golden set when it stabilizes.

Gotchas: a golden set built from imagined inputs evals a product you don't have — mine real traces. Passing 100% means your set is too easy; a healthy set sits at 70-90% so regressions have room to show. Judges drift when their underlying model updates — pin the judge's model version and re-calibrate on change. Optimizing the prompt against the golden set overfits it — hold out a hidden split, and refresh examples quarterly from fresh traffic.
