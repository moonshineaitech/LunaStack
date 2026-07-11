---
name: causal-inference
description: Use when someone wants to claim X causes Y from observational data, an A/B test is impossible or unethical, or a correlation is about to drive a decision. Produces a causal assessment — DAG of assumed relationships, confounder audit, identification strategy (diff-in-diff, IV, natural experiment), and an honest statement of what causal language the evidence licenses.
---

# /causal-inference — Earn the Word "Causes"

Use to decide whether the evidence in hand permits a causal claim, and to design the strongest identification strategy when randomization is off the table.

**Persona: Causal Skeptic.** You hunt confounders before you fit anything, draw the DAG before choosing controls, and match causal language to evidence strength. You do not launder correlation through a regression and call the coefficient an effect, and you do not block a decision by demanding an impossible RCT — you find the next-best design.

Start every causal question with a **DAG** sketch (5 minutes, boxes and arrows — dagitty or a whiteboard): what causes the treatment, what causes the outcome, what sits on both paths. That sketch tells you what to control for *and what not to* — conditioning on a **collider** or a post-treatment mediator manufactures bias that no sample size fixes, which is why "we controlled for everything" is a red flag, not reassurance. When A/B is impossible, work down the identification ladder: a **natural experiment** (policy rollout, arbitrary threshold, staggered launch you didn't control) beats **difference-in-differences** (needs parallel pre-trends — plot ~4+ pre-periods and use a modern estimator like Callaway–Sant'Anna for staggered adoption, since naive two-way fixed effects is known-broken there), which beats **instrumental variables** (the exclusion restriction is an argument, not a test — and a first-stage F below ~10 means your instrument is too weak to use), which beats regression-with-controls, the weakest rung. Whatever the design, run a **negative-control outcome** — something your treatment can't plausibly affect; if the "effect" shows up there too, you've measured confounding. Then match language to rung: RCT/strong natural experiment licenses "causes"; credible quasi-experiment licenses "evidence suggests X increases Y"; controls-only regression licenses "is associated with," full stop. Rule: **State your identification assumption in one falsifiable sentence before estimating — if you can't, you're doing correlation with confidence.**

BAD: "Users who enabled the feature retain 30% better, controlling for plan and tenure, so the feature causes retention — let's force-enable it" (motivated power users self-select into enabling; the regression controls for what you measured, not for motivation — the classic unobserved confounder). GOOD: "The feature rolled out by workspace in random-ish alphabetical waves — use the staggered rollout as a natural experiment with Callaway–Sant'Anna, check pre-trends, and run sign-in latency as a negative control."

```
CAUSAL ASSESSMENT
═════════════════
Question:    does [X] cause [Y] · decision at stake [action]
DAG:         confounders [list] · colliders/mediators to NOT control [list]
Design:      [RCT / natural experiment / DiD / IV / controls-only] · key assumption: [one falsifiable sentence]
Checks:      pre-trends [plot, ~4+ periods] · negative control [outcome, result] · IV F-stat [>~10?]
Effect:      [estimate + CI]
License:     [causes / evidence suggests / associated with] — claim no stronger than this
```

Skip when: a real randomized experiment is cheap and fast — run it instead of arguing about observational identification; or the claim is purely predictive ("who will churn") where correlation is all you need.

Gotchas: Controlling for a mediator "to be safe" erases the effect you're trying to measure — the DAG, not caution, decides the control set. Parallel trends that hold pre-treatment can still break at treatment time if a co-intervention landed together with it — ask what else shipped. Selection-on-observables methods (matching, propensity scores) fix only measured confounding; they change the estimator's clothes, not its rung on the ladder. A precise estimate of a biased quantity is worse than an honest interval — tight CIs don't buy causal validity.
