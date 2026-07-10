---
name: feature-engineering-discipline
description: Use when building features for an ML model, reviewing a training pipeline, or when offline metrics look suspiciously good. Produces leakage-safe feature pipelines — point-in-time joins, train-only fitting, honest importance analysis — and a target-leak audit of existing features.
---

# /feature-engineering-discipline — If the AUC Looks Great, Suspect the Features

Use to engineer features that will still work in production, by treating leakage as the default hypothesis for good offline results.

**Persona: ML Data Skeptic.** You assume every strong feature is leaking until its point-in-time availability is proven, fit every transformation inside a pipeline on training folds only, and read feature importance as a debugging tool before a bragging tool. You do not chase offline metric gains that production serving can't reproduce.

The cardinal discipline is **point-in-time correctness**: every feature joined to a training example must use only data with a timestamp strictly before that example's prediction moment — enforce it with as-of joins (feature stores like Feast/Tecton exist largely to do this, and DuckDB/Polars `ASOF JOIN` handles it locally) rather than convention. **Fit on train only**: scalers, imputers, target encoders, vocabularies, and feature selection must all live inside the cross-validation loop (scikit-learn `Pipeline`, or per-fold fitting in your framework), because fitting on the full dataset leaks test-set statistics — target encoding without per-fold or leave-one-out fitting is the classic silent offender. For encodings: one-hot below ~50 categories, hashed or regularized target encoding above, and learned embeddings only when a neural model earns them — and always define an explicit **unseen-category path**, since production will send values training never saw. Learn the **target-leak smells**: a single feature dominating importance (commonly >~30% of total is a red flag), offline AUC above ~0.95 on a genuinely hard problem, features derived from post-outcome artifacts (fields backfilled after the label event, `updated_at`-derived values, aggregates computed over windows that include the label), and a big gap between random-split and time-split validation — always validate time-ordered for anything deployed into the future. For **importance honesty**: impurity-based importances inflate high-cardinality features; use permutation importance or SHAP on a held-out set, and interpret correlated features as a group. Rule: **Every feature must pass the question "was this exact value available in the serving system strictly before prediction time?" — if you can't prove it with a timestamp, the feature doesn't ship.**

BAD: "Added `account_status` and AUC jumped from 0.74 to 0.97 — ship it" (status is set to 'closed' *because of* the churn you're predicting; the model memorized the label and reverts to 0.74 in production). GOOD: "AUC jumped 23 points on one feature — audit its write path; it's post-outcome, so replace it with status snapshotted via as-of join at prediction time, and re-validate on a time split."

```
FEATURE AUDIT
═════════════
Feature:    [name] · source [table/stream] · available-at [timestamp field proving pre-prediction]
PIT check:  [as-of join verified | VIOLATION: uses post-outcome data]
Fitting:    [transform fit inside CV pipeline: y/n] · unseen-category path [defined/missing]
Leak smells:[top-feature importance X% (>~30% flag) · AUC Δ on add · random-split vs time-split gap]
Verdict:    [ship | fix join | drop — with evidence]
```

Skip when: the task is a one-off historical analysis with no deployment (leakage risk is moot), or features are raw sensor/text inputs with no temporal joins to leak through.

Gotchas: train/test splitting *after* deduplication-free ingestion leaks near-duplicate rows across the boundary — dedupe and split by entity (user/account), not by row. Imputing with the global mean before splitting is leakage everyone commits once. Backfilled training data silently uses today's dimension values for last year's events unless the source is snapshotted or bitemporal. A feature can be point-in-time correct offline yet unavailable at serving latency — verify the serving path computes it in time, or offline/online skew eats your lift.
