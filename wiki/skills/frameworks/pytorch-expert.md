---
name: pytorch-expert
description: Use when writing or reviewing PyTorch training/inference code and you want correct tensor/device handling, no silent grad bugs, and efficient loops. Produces a review against PyTorch-specific traps.
---

# /pytorch-expert — Correct, Efficient PyTorch

Use when writing PyTorch models/training or reviewing them.

**Persona: Deep Learning Engineer.** You keep tensors on the right device, you zero gradients, and you know which ops silently break autograd or leak memory.

Training-loop essentials, in order: **`optimizer.zero_grad()` → forward → `loss.backward()` → `optimizer.step()`** — forgetting `zero_grad()` accumulates gradients across batches (a silent correctness bug). Keep model and data on the **same device** (`.to(device)`) — a CPU/GPU mismatch throws; move data each batch. Wrap evaluation/inference in **`torch.no_grad()`** (or `inference_mode()`) — otherwise you build the autograd graph and leak memory. Call `model.eval()` for inference (disables dropout/batchnorm-update) and `model.train()` for training — forgetting this corrupts eval metrics. Don't accumulate loss tensors for logging (`total += loss` keeps the graph → memory leak) — use `loss.item()`. Use `DataLoader` with `num_workers`/`pin_memory` for throughput. Avoid Python loops over tensor elements — vectorize. Set seeds for reproducibility; use mixed precision (`autocast`) on GPU for speed.

BAD: a training loop missing `optimizer.zero_grad()` — gradients accumulate every batch, training diverges mysteriously. GOOD: `zero_grad()` first each iteration; `loss.backward()`; `step()`.

```
PYTORCH REVIEW
══════════════
□ zero_grad → forward → backward → step (zero_grad not forgotten)
□ Model + data on same device (.to(device))
□ Eval/inference under no_grad()/inference_mode()
□ model.eval()/train() toggled correctly
□ Logging via loss.item() (no graph-retaining accumulation)
□ DataLoader num_workers/pin_memory; vectorized (no elem loops)
□ Seeds set; autocast mixed precision on GPU
```

Skip when: a trivial tensor snippet with no training loop.

Gotchas: forgetting `zero_grad()` accumulates gradients and breaks training silently. Accumulating loss tensors (not `.item()`) leaks the autograd graph → OOM. Forgetting `model.eval()` leaves dropout/batchnorm in train mode, corrupting eval.
