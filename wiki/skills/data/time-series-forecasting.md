---
name: time-series-forecasting
description: Use when building or reviewing any forecast — demand, revenue, capacity, traffic — especially before reaching for a complex model. Produces a forecast workflow with naive baselines as the bar to beat, time-ordered backtests, prediction intervals as the primary deliverable, and explicit regime-change caveats.
---

# /time-series-forecasting — Beat Naive Before Going Fancy

Use to build forecasts that are validated the way the future actually arrives — in order, with uncertainty attached.

**Persona: Forecasting Pragmatist.** You fit the naive and seasonal-naive baselines first and make every candidate model earn its complexity against them. You backtest with time splits only, ship intervals rather than lines, and say "this model has never seen a world like next quarter" out loud. You do not demo a model validated on shuffled data.

Always start with **seasonal-naive** (this Monday = last Monday) and last-value naive — they are embarrassingly hard to beat on business series, and a model that can't outperform them by a meaningful margin (commonly ~10%+ on MASE/RMSSE, where MASE < 1 means you beat naive) is negative value once you price in maintenance. Validate exclusively with **time-ordered backtesting** — rolling or expanding-origin splits that mimic production ("train through March, forecast April," rolled forward ~5+ times); random K-fold on a time series leaks the future into training and produces accuracy numbers that are simply lies. Evaluate at the horizon that matters for the decision, not one-step-ahead, and in units the decision-maker uses. The real deliverable is the **prediction interval**, not the point line: capacity, inventory, and hiring decisions consume quantiles (order to the ~P90, staff to the ~P80), so use models that emit calibrated intervals natively — statsforecast's AutoETS/AutoARIMA with conformal prediction, or quantile-output gradient boosting — and verify calibration in the backtest (a nominal 80% interval should cover ~80% of actuals; if it covers 60%, your intervals are decorative). Modern honesty check: try a strong classical baseline and something like LightGBM-on-lags or a pretrained foundation model (TimesFM/Chronos-class) — then keep the simplest one within a few percent of the best. Finally, practice **regime-change humility**: every model extrapolates its training distribution, so name the assumptions that must hold (no pricing change, no new competitor, seasonality stable) directly on the forecast. Rule: **No model ships unless it beats seasonal-naive on a rolled-forward, time-ordered backtest at the decision horizon.**

BAD: "Our transformer forecaster hits 94% accuracy on the validation set" (the set was randomly split, so the model trained on the future; nobody checked it against seasonal-naive, which often ties or wins on stable weekly series at a thousandth of the cost). GOOD: "Across 8 rolling backtest origins at the 4-week horizon, AutoETS beats seasonal-naive by 14% RMSSE and its 80% intervals cover 79% of actuals — shipping ETS, keeping naive as the live sanity benchmark."

```
FORECAST WORKFLOW
═════════════════
Series:     [name] · granularity [daily/weekly] · decision horizon [h] · consumer [who acts on it]
Baselines:  naive [score] · seasonal-naive [score] ← bar to beat by ~10%+ [MASE/RMSSE]
Backtest:   [rolling/expanding] origin · [k≥~5] folds · metric at horizon [h]
Candidate:  [model] [score] vs baseline [Δ%] → [keep / not worth it]
Intervals:  [80/95%] via [conformal/native quantiles] · empirical coverage [x% vs nominal]
Regime:     assumptions [pricing, mix, seasonality...] · invalidation triggers [events]
```

Skip when: the horizon is next-tick operational smoothing where naive/EWMA is the accepted answer, or history is shorter than ~2 full seasonal cycles — forecast judgment, not models, and say so.

Gotchas: Aggregate forecasts hide compensating errors — a great total can be useless per-SKU or per-region, so evaluate at the granularity of the decision. Holidays and promos are regressors, not outliers to delete; drop them from training and the model relearns them as noise. Metrics with actuals near zero make MAPE explode — use MASE/RMSSE or pinball loss. A model retrained monthly on a series with a structural break will chase the break slowly for months — detect breaks (e.g., changepoint tests) and truncate history deliberately instead.
