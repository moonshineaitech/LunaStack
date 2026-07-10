---
name: gpu-infrastructure
description: Use when running or planning GPU clusters for training or inference — buying vs renting, spot vs reserved, scheduling, or chasing OOMs and idle GPUs. Produces a cluster plan with utilization targets, a spot/reserved split with checkpointing policy, and an OOM debugging sequence.
---

# /gpu-infrastructure — Every Idle GPU-Hour Is Cash on Fire

Use to plan, right-size, and operate GPU infrastructure so paid hours turn into useful FLOPs.

**Persona: GPU Platform Engineer.** You own utilization, scheduling, and the cloud bill for accelerators. You do NOT design the models or the serving engine config — you make sure the GPUs they need exist, are busy, and don't OOM at 3 a.m.

Measure the right utilization: `nvidia-smi` "GPU util" reads 100% while doing almost nothing — track **allocation utilization** (fraction of paid GPU-hours with a job scheduled; target ~70%+ or shrink the fleet) and, for training, **MFU** (achieved/peak FLOPs; ~35-45% is commonly respectable for distributed LLM training, single digits means a data-loading or communication bug). Buy accordingly: reserve/commit capacity for the sustained baseline you actually hit (commonly the level you exceed ~60-70% of hours) and burst on **spot/preemptible** for everything restartable — spot runs ~50-70% off on-demand, which only pays if preemption costs less than the discount, so checkpoint at most every ~30 minutes (async, to object storage) and make jobs resume-from-checkpoint by default, not by heroics. Schedule with the grain of the workload: **Slurm** (or K8s + Kueue/Volcano with gang scheduling) for training — partial allocation of a distributed job is a deadlock, all-or-nothing matters — and plain Kubernetes for inference, where **MIG** partitions (e.g., an H100 into up to 7 slices) or time-slicing stop 5 GB models from squatting on 80 GB cards. Debug OOMs in order, cheapest first: read the actual message (fragmentation shows "reserved but unallocated" — try `PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True`), then halve micro-batch with gradient accumulation, then activation checkpointing, then sharding (FSDP/ZeRO-3) or a bigger card — and remember the mid-training OOM cause is usually a long-tail batch (sequence length spike), so cap or bucket lengths. Rule: **Reserve the baseline, spot the burst, and refuse spot for any job that can't checkpoint and auto-resume within ~30 minutes of lost work.**

BAD: "We run everything on-demand because spot preemptions killed a training run once" (the run had no checkpointing; the team now pays ~2-3x for insurance a 20-line resume hook would have provided). GOOD: "Baseline 16 GPUs reserved at 74% allocation utilization; training bursts on spot with async checkpoints every 20 min; measured preemption overhead 3% of compute vs 60% cost savings."

```
GPU INFRA PLAN — [cluster/team]
════════════════════════════════
Utilization: allocation [x% — target ≥70] · MFU (training) [x%] · idle-hour cost [$/mo]
Procurement: reserved [n GPUs = baseline] · spot [burst, ~x% discount] · on-demand [overflow only]
Resilience:  checkpoint every [≤30 min, async] · auto-resume tested? [Y] · preemption overhead [x%]
Scheduling:  training [Slurm / K8s+Kueue gang] · inference [K8s, MIG [n]-slice / full]
OOM ladder:  alloc-conf → micro-batch÷2 + grad-accum → activation ckpt → FSDP/ZeRO-3 → bigger card
Watchlist:   sequence-length spikes · fragmentation · dataloader CPU starvation
```

Skip when: usage is a few GPU-hours a week — notebooks on a serverless GPU provider (Modal/RunPod-class) beat owning any infrastructure.

Gotchas: reporting nvidia-smi utilization to leadership as "the GPUs are busy" — it counts a kernel every cycle as 100% even at 4% MFU. Gang-unaware K8s scheduling deadlocks two 8-GPU jobs at 4 GPUs each, forever. MIG slices don't support NVLink peer-to-peer — never for multi-GPU training. Chasing an OOM with a bigger instance before checking for one 32k-token outlier sequence in the batch.
