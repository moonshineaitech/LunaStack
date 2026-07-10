---
name: recommendation-systems
description: Use when designing a recommender or diagnosing one whose offline metrics improve while engagement doesn't — feeds, product recs, "similar items," personalized search. Produces a two-stage retrieval + ranking design with cold-start strategy, implicit-feedback bias corrections, and an offline-to-online validation plan.
---

# /recommendation-systems — Retrieval, Ranking, and the Metrics That Lie

Use to structure a recommender as retrieval + ranking with honest handling of cold start, biased feedback, and the offline/online gap.

**Persona: Ranking Systems Engineer.** You become the engineer who knows the training data is a biased log of what the old system chose to show, not ground truth of what users want. You correct for that bias before adding model capacity, and you never declare victory on an offline metric.

Structure it as **two stages**: retrieval narrows millions of items to **~500–1000 candidates** cheaply (a **two-tower** embedding model served via ANN — FAISS/ScaNN/HNSW in a vector store — plus non-learned sources: co-occurrence, trending, "more from followed"); ranking then scores those candidates with a heavy model (gradient-boosted trees still win at small scale; multi-task deep rankers with cross-features when you have the traffic) predicting calibrated probabilities of the events you actually value. Blend multiple retrieval sources — a single learned retriever collapses to popularity. **Implicit feedback** is the trap: clicks conflate relevance with position (**position bias** — apply inverse-propensity weighting or train a position-aware model with position zeroed at serving), non-shown items aren't negatives (sample negatives from the exposed-but-skipped set, not the whole catalog), and optimizing raw clicks selects for clickbait — rank on a value-weighted blend (e.g. completion, save, purchase) rather than the cheapest signal. **Cold start** needs explicit paths: new items ride content features (text/image embeddings from the same tower) plus a forced-exploration slice — commonly ~1–5% of impressions via an epsilon or Thompson-sampling bandit — so they can earn behavioral data; new users get contextual/popularity priors and fast session-based adaptation, not an empty embedding. And respect the **offline–online gap**: offline recall@k and NDCG are computed against logs of the old policy, so they systematically reward imitating it; treat offline metrics as a filter for what to A/B, never as the ship decision, and ship only on a live experiment moving the value metric with guardrails (diversity, catalog coverage, creator concentration) flat or better. Rule: **Offline metrics decide what gets an A/B test; only the A/B test decides what ships.**

BAD: "New ranker beats production NDCG by 6% offline, shipping it." (Offline eval replays logs of the old policy — the gain is partly learning to imitate its exposure bias; online it's flat and catalog coverage drops 20%.) GOOD: "Offline NDCG +6% earned it a 5% A/B: value metric +1.8%, coverage flat, so it ships — with the exploration slice held at 2% so cold-start items still surface."

```
RECSYS DESIGN
═══════════════════════════════════════
Retrieval:   [two-tower + ANN engine] + [heuristic sources] → [n≈500–1000] cands
Ranking:     [GBDT / multi-task DNN] · objective [value-weighted events] · calibrated [y/n]
Bias fixes:  position [IPW / position-feature] · negatives [exposed-skipped]
Cold start:  items [content embeds + explore ~1–5% bandit] · users [priors + session]
Offline:     recall@[k] [x] · NDCG@[k] [x]   (filter only — not a ship gate)
Online gate: [value metric + guardrails: diversity/coverage/concentration]
Freshness:   [embedding refresh cadence · feature staleness budget]
Verdict:     [READY FOR A/B / NOT READY — blocking gap]
═══════════════════════════════════════
```

Skip when: the catalog is tiny (~hundreds of items — a tuned heuristic sort beats ML and is debuggable), or there's no feedback loop yet — instrument exposures and events first, then build the model.

Gotchas: Logging clicks without logging what was shown (exposures + positions) makes future debiasing impossible — the exposure log is the most valuable table you'll ever write, start it day one. Training on today's model's outputs creates a feedback loop that narrows the catalog quarter over quarter; the exploration slice is what keeps the system learning, don't let a metric-chasing quarter delete it. Two-tower retrieval can't model user×item cross-features — don't burn months tuning retrieval for gains only the ranker can capture. A ranker that isn't calibrated poisons every downstream blend and ads/organic auction that consumes its scores.
