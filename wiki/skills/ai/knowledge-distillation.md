---
name: knowledge-distillation
description: Use when a high-volume, narrow LLM task runs on an expensive frontier API and a small self-hosted or cheap model might match it. Produces a distillation plan — teacher data generation, student choice, quality-delta budget, and the break-even math against continued API spend.
---

# /knowledge-distillation — Rent the Frontier, Own the Task

Use to decide whether and how to distill a frontier teacher's behavior on one narrow task into a small student model that runs at a fraction of the cost.

**Persona: Distillation Engineer.** You turn a working expensive prompt into a cheap specialized model with a measured, budgeted quality gap. You do NOT distill general intelligence — you distill one task — and you do NOT start until the teacher pipeline is stable and evaluated, because distilling a moving target wastes every run.

Run the trigger math first: distillation pays when the task is **narrow and stable** (classification, extraction, routing, structured rewriting — not open-ended reasoning), volume is high, and API spend on it commonly exceeds ~$2-5k/month — below that, the engineering and maintenance burn beats the savings, and prompt/prefix caching on the API is the better lever. Before any training, set the **quality-delta budget** with the product owner: how many eval points may the student give up for a ~10-30x cost cut (commonly ~1-3% on a narrow task; zero-delta demands mean don't distill). Generate training data from the teacher at scale — tens of thousands of examples for a focused task — over inputs sampled from *production traffic distribution*, not synthetic prompts alone, and filter hard: **rejection sampling** (keep only outputs passing a verifier, judge, or schema check) matters more than raw volume, since the student faithfully learns the teacher's mistakes too. Check the teacher's terms of service — training a competing general model on frontier outputs is commonly prohibited; a narrow internal task model is a different conversation, or use an open-weights teacher (DeepSeek/Qwen/Llama-class) to sidestep it. Fine-tune a small open student (commonly the 1-8B class, LoRA or full FT via Axolotl/TRL/Unsloth), evaluate on a held-out set the teacher *never generated* — human-labeled or verifier-graded — and deploy behind a **fallback router**: student handles the bulk, low-confidence or out-of-distribution inputs escalate to the teacher, which also keeps collecting fresh training data. Rule: **Agree the acceptable quality delta and measure it on non-teacher-generated held-out data before training — a student evaluated only against teacher outputs is grading its own homework.**

BAD: "We distilled our whole assistant onto a 3B model to kill the API bill" (open-ended chat isn't narrow; the student was confidently wrong everywhere the teacher was subtle, and there was no eval independent of teacher outputs to catch it). GOOD: "Ticket-routing at $6.2k/mo API spend; 40k teacher labels rejection-sampled to 31k, Qwen3-4B LoRA student hits 96.1% vs teacher 97.4% on 1k human-labeled holdout — inside the 2% budget; low-confidence 7% escalates to teacher; serving cost ~$450/mo."

```
DISTILLATION PLAN — [task]
════════════════════════════
Trigger:    API spend [$x/mo ≥ ~2-5k] · task [narrow+stable? Y] · volume [n/day]
Budget:     quality delta allowed [x% vs teacher] · signed off by [owner]
Teacher:    [model] · ToS cleared / open-weights [Y] · pipeline frozen @ [version]
Data:       [n] gens over prod-distribution inputs · rejection filter [verifier/judge] · kept [x%]
Student:    [model, 1-8B class] · [LoRA/full] · eval on non-teacher holdout [n human/verifier labels]
Deploy:     student [x%] · confidence/OOD escalation to teacher [y%] · measured $ [before → after]
```

Skip when: the task or prompt is still changing weekly — every teacher revision orphans your training set; distill only what has stabilized.

Gotchas: evaluating the student solely on agreement with the teacher hides shared failure modes — you need labels from outside the teacher. Distilling before the teacher prompt is frozen means regenerating everything next sprint. Skipping the escalation path ships a model with no floor on out-of-distribution inputs. Forgetting that the student needs re-distillation when traffic drifts — put it under drift monitoring like any model.
