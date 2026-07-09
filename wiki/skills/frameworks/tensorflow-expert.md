---
name: tensorflow-expert
description: Use when writing or reviewing TensorFlow/Keras models and you want correct data pipelines, graph/eager awareness, and efficient training. Produces a review against TF-specific traps.
---

# /tensorflow-expert — Correct, Efficient TensorFlow

Use when building TF/Keras models or reviewing training code.

**Persona: Deep Learning Engineer (TF).** You feed the model with an efficient `tf.data` pipeline and you know where graph mode changes the rules.

Build input with **`tf.data`**: `.cache()` after expensive preprocessing, `.shuffle(buffer)` with an adequate buffer, `.batch()`, then **`.prefetch(tf.data.AUTOTUNE)`** so data loads while the GPU computes — a naive Python generator starves the GPU. Understand **`@tf.function`** (graph mode): Python side effects (prints, list appends, mutable Python state) run only on the first trace, not every call — a classic bug; keep functions pure over tensors. Use Keras (`model.fit`) for standard training; a custom loop needs `GradientTape` + `optimizer.apply_gradients`. Match preprocessing between training and serving exactly (skew corrupts production). Use mixed precision (`mixed_float16`) on GPU for speed, `tf.function(jit_compile=True)`/XLA where it helps. Set seeds; watch that `model.evaluate`/`predict` uses inference behavior (dropout off — Keras handles it, custom loops must pass `training=False`).

BAD: a Python `for` loop yielding numpy batches feeding `model.fit` — the GPU idles waiting on the CPU. And a `print()` inside `@tf.function` that "stops printing" (it only traced once). GOOD: a `tf.data` pipeline with `.prefetch(AUTOTUNE)`; use `tf.print` for in-graph logging.

```
TENSORFLOW REVIEW
═════════════════
□ tf.data pipeline: cache → shuffle → batch → prefetch(AUTOTUNE)
□ @tf.function: pure over tensors (no Python side effects each call)
□ Custom loops: GradientTape + apply_gradients; training flag correct
□ Train/serve preprocessing identical (no skew)
□ Mixed precision / XLA on GPU where beneficial
□ tf.print for in-graph logging (not Python print)
□ Seeds set; inference uses training=False (dropout off)
```

Skip when: a trivial tensor op with no data pipeline or training.

Gotchas: a Python-generator input pipeline starves the GPU — use `tf.data` + prefetch. Python side effects in `@tf.function` run only on first trace. Train/serve preprocessing skew silently degrades production accuracy.
