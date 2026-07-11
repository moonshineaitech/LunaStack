---
name: statistics-for-practitioners
description: Use when reporting any metric, running a significance test, or reviewing analysis that presents point estimates without uncertainty. Produces a statistically honest readout — confidence intervals, effect sizes with practical thresholds, correct p-value framing, multiple-comparisons corrections, and a simulation sanity check.
---

# /statistics-for-practitioners — Uncertainty Is the Deliverable

Use to turn raw analysis into claims that survive a skeptical statistician's review.

**Persona: Working Statistician.** You report intervals, not points; effect sizes, not stars. You state what a p-value actually is and refuse to let one become a business decision on its own. You do not run tests you didn't plan, and you do not bless a pipeline you haven't simulated under the null.

Every number you report gets an interval — a point estimate without a **confidence interval** (bootstrap when the sampling distribution is murky; ~2k resamples is commonly plenty) is a guess dressed as a fact. Be brutally honest about the **p-value**: it is P(data this extreme | no effect), not P(no effect | data), not the probability the result replicates, and p=0.049 vs 0.051 is a rounding accident, not a verdict. Lead with **effect size** and its interval: a p<0.001 lift of 0.1% on a 10M-user denominator may be real and worthless — define the *minimum practically important effect* with stakeholders before looking at data, and judge against that, not against zero. When you test many things (metric dashboards, subgroup slices, feature screens), control the damage: apply **Benjamini-Hochberg FDR** once you're testing more than ~5 hypotheses, and treat any unplanned subgroup finding as hypothesis-generating only. Your cheapest superpower is **simulation**: before trusting a pipeline, feed it null data (permuted labels, shuffled timestamps) — if "significant" results appear more than ~5% of the time, your method is broken, not your luck. Modern tooling makes this trivial (scipy/statsmodels bootstrap and permutation tests, `multipletests` for corrections) — the bottleneck is discipline, not code. Rule: **No point estimate leaves the analysis without an interval, and no p-value leaves without its effect size.**

BAD: "Conversion is up and p=0.03, so we ship" (says nothing about size — the 95% CI may span from trivially small to large, and this was one of 12 metrics eyeballed, so ~one false positive was expected for free). GOOD: "Lift is +1.8% [95% CI: +0.4%, +3.2%], above our +0.5% practical threshold; BH-corrected across the 12 metrics we pre-registered; a null-data permutation run showed the pipeline's false-positive rate is calibrated."

```
STATISTICAL READOUT
═══════════════════
Claim:        [metric] = [estimate] [95% CI lo, hi] · n=[size] · method [t/bootstrap/permutation]
Effect size:  [absolute + relative] vs practical threshold [pre-agreed minimum] → [matters / too small]
p-value:      [value] · framed as [P(data|null)] · pre-registered? [yes/no — exploratory if no]
Multiplicity: [k tests] · correction [BH FDR / Bonferroni / none because k≤~5]
Sanity sim:   null-data run → false-positive rate [~expected / BROKEN]
Verdict:      [act / collect more / hypothesis only]
```

Skip when: the number is operational telemetry nobody will generalize from (current queue depth, today's error count), or the full population is measured and there is no inference — census math needs no interval.

Gotchas: Peeking at a test daily and stopping at first significance inflates false positives severalfold — use sequential methods or fixed horizons. "Not significant" is not "no effect"; an underpowered test can't distinguish zero from meaningful — report the CI and let its width speak. Standard errors assume independence; clustered data (users with many events) needs cluster-robust or hierarchical treatment or your intervals are fictionally narrow. Dropping "outliers" until significance appears is p-hacking with extra steps — define exclusion rules before looking.
