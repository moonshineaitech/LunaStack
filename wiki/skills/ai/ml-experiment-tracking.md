---
name: ml-experiment-tracking
description: Use when ML experiments multiply and nobody can reproduce last month's best run, or before setting up W&B/MLflow discipline for a team. Produces a tracking standard — what to log, naming scheme, comparison rules, and model-registry promotion gates.
---

# /ml-experiment-tracking — If You Can't Rerun It, It Didn't Happen

Use to establish experiment tracking discipline so any result can be reproduced, compared fairly, and promoted through a registry with gates.

**Persona: ML Reproducibility Engineer.** You make every experiment a rerunnable artifact and every comparison apples-to-apples. You do NOT design the experiments or pick the winning model — you make sure the winner was picked on evidence that survives a rerun.

Log the full reproduction tuple on every run, automatically, in the training harness — never by convention: **git SHA + dirty-diff patch**, **data version** (DVC/lakeFS hash or snapshot ID — "the S3 prefix" is not a version, it mutates), resolved config (the final merged values, not the YAML filename), environment lockfile, and seed. W&B and MLflow 3.x capture most of this if you wire it once; the runs that matter are always the ones someone launched from an uncommitted notebook, so make the harness refuse to start (or loudly tag `dirty`) on an uncommitted tree. Name runs as data, not poetry: `{project}/{hypothesis-tag}/{variant}` with everything else in queryable config fields — `bert-final-v2-actually-final` is where results go to die. Comparison hygiene is where teams silently cheat themselves: compare only runs sharing the identical **frozen eval set** (hash it, log the hash), and before declaring a winner run ≥3 seeds and demand the improvement exceed roughly 2× the cross-seed standard deviation — a single-seed +0.8% on a metric with ±0.6% seed noise is a coin flip wearing a lab coat. Gate the **model registry**: promotion from candidate to staging to production requires the eval-suite report attached, comparison against the current production champion on the same frozen set, and a human sign-off recorded on the version — a registry without gates is a folder with extra steps. Rule: **No metric claim without ≥3 seeds on the same hashed eval set, and no registry promotion without the champion comparison attached to the model version.**

BAD: "Run 47 beat baseline by 1.1% so we shipped it" (single seed, eval set had been regenerated midweek, and the run came from an uncommitted notebook — the result never reproduced and the SHA points at code that didn't produce it). GOOD: "sweep/loss-fn/focal-g2, 3 seeds: +2.3% ±0.4 over champion on eval-set sha256:9f2c, data snapshot dvc:a41e; promoted to staging with report and sign-off attached."

```
EXPERIMENT TRACKING STANDARD — [team/project]
═══════════════════════════════════════════════
Per-run capture: git SHA + dirty patch · data hash [DVC/lakeFS] · resolved config · env lock · seed
Enforcement:     harness auto-logs [Y] · dirty-tree policy [block / tag `dirty`]
Naming:          {project}/{hypothesis}/{variant} · hyperparams in config fields, not names
Comparison:      frozen eval set [hash] · seeds ≥3 · claim threshold [Δ > ~2× seed std]
Registry gates:  candidate→staging [eval report] · staging→prod [champion diff + human sign-off]
Retention:       failed runs kept [90d] · promoted lineage kept [forever]
```

Skip when: solo exploratory spikes you'll throw away within the day — but the moment a number might reach a decision or a slide, it needs a tracked run behind it.

Gotchas: logging the config YAML path instead of resolved values — the file changes later and the run lies about what it did. Comparing against a champion evaluated months ago on different preprocessing instead of re-scoring both on today's frozen set. Metric definitions drifting between runs (macro vs micro F1) while dashboards overlay them as one curve. Tracking metrics religiously but not the data hash, which is the variable that actually moved.
