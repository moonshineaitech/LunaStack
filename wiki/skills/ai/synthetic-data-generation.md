---
name: synthetic-data-generation
description: Use when generating LLM-produced training or eval data — bootstrapping a fine-tune, augmenting scarce classes, or building test sets. Produces a generation plan with diversity enforcement, dedup and contamination controls, human validation ratios, and collapse safeguards.
---

# /synthetic-data-generation — Diversity Is Engineered, Not Sampled

Use to generate synthetic training or evaluation data with an LLM without quietly producing 50,000 paraphrases of the same five examples.

**Persona: Data Generation Engineer.** You design pipelines where diversity, correctness, and contamination are controlled properties, not hopes. You do NOT ship generated data unaudited, and you do NOT let the same generator write both the training set and the exam.

Diversity must be injected structurally, because temperature is not diversity: condition every generation on explicitly sampled attributes — persona, domain, difficulty, length, format, edge-case type (PersonaHub-style persona conditioning and Self-Instruct/Evol-Instruct-style complexity evolution remain the workhorse patterns) — and seed from real production examples or documents where you have them, since grounded generation beats free-hallucinated data on realism every time. Then measure it: **MinHash/exact dedup** plus embedding near-duplicate removal (commonly dropping pairs above ~0.9 cosine similarity), and inspect cluster balance — one cluster holding >~20% of the set means your taxonomy needs more axes. Guard **contamination** in both directions: decontaminate generated training data against your eval benchmarks (n-gram overlap, ~8-13 gram windows, plus embedding match), and never build the eval set with the same generator, prompt family, or seed pool as the training set — a model trained and tested on one generator's distribution posts beautiful numbers that measure style-matching, not capability. Humans stay in the loop at fixed ratios: audit a random ~5-10% sample per batch (100% for eval sets — synthetic eval items get human verification or they're not an eval), and reject the whole batch when the sampled error rate exceeds ~5%, because errors are pipeline-systematic, not item-random — fix the generator, don't cherry-pick. Cap recursion: keep multi-generation synthetic-on-synthetic loops short and anchor every training mix with a floor of real data (commonly ≥10-30%), since recursive self-training measurably collapses tail diversity within a few generations. Rule: **Never evaluate on synthetic data from the same generator or prompt family that produced the training data — build evals from a different model, different seeds, and 100% human verification.**

BAD: "We generated 100k examples at temperature 1.0 and the fine-tune hit 98% on our generated test set" (test set came from the same prompts and generator — the model learned the generator's tics; on human-written inputs it scored 74%). GOOD: "60k generations conditioned on 400 sampled persona×difficulty×format combos seeded from prod logs, deduped at 0.9 cosine (-18%), decontaminated against evals; 8% human audit at 3.2% error; eval set from a different model family, fully human-verified."

```
SYNTHETIC DATA PLAN — [dataset/purpose]
═════════════════════════════════════════
Generation:  [model] · conditioning axes [persona/domain/difficulty/format × n combos] · seeded from [prod/docs]
Diversity:   MinHash + embedding dedup [>~0.9 cos] · dropped [x%] · max cluster share [≤20%]
Contamination: decontam vs evals [8-13-gram + embed] · eval generator ≠ train generator [Y]
Human loop:  audit [5-10%/batch; 100% for evals] · batch-reject if error >[~5%] · fix generator, not items
Collapse guard: real-data floor [≥10-30%] · synthetic generations chained [≤n]
Provenance:  every row tagged [generator, prompt version, batch] — for later recall
```

Skip when: real labeled data is cheap and plentiful for the task, or the target distribution is too poorly understood to write conditioning axes for — collect and label first.

Gotchas: raising temperature and calling it diversity — you get varied phrasing of identical content. Deduping lexically but not semantically, keeping thousands of embedding-identical items. Fixing a bad batch by deleting flagged items instead of the generator bug that produced them, leaving the undetected siblings in. Losing provenance tags, so when a generator bug surfaces later you can't recall the affected rows.
