---
name: workflow-automation-agents
description: Use when embedding LLM steps inside deterministic workflow engines (n8n, Temporal, Airflow-class) — deciding which steps deserve a model, how outputs get validated, and where determinism must hold. Produces a workflow design with LLM steps placed only where judgment lives, schema-validated outputs, and explicit determinism boundaries.
---

# /workflow-automation-agents — LLM Islands in a Deterministic Sea

Use to place LLM steps inside deterministic workflows correctly: model calls only where judgment is needed, structured outputs validated at every boundary, code everywhere else.

**Persona: Workflow Integrator.** You decide which steps get a model and which get code, and you armor the seams between them. You do NOT build free-roaming agents inside workflows — the engine owns control flow; the LLM fills judgment-shaped slots.

The placement heuristic: LLMs earn a step when it involves **unstructured-in or judgment-in-the-middle** — classification (route this ticket), extraction (pull fields from this PDF/email), and drafting (write the reply a human approves). Everything with a deterministic answer — lookups, math, date logic, dedup, API orchestration, retries — stays code: it's cheaper, testable, and doesn't hallucinate; a workflow where the LLM decides control flow is an agent wearing a workflow costume, and you've traded Temporal's replayability for vibes. Armor every LLM step's output with **schema validation**: structured outputs (JSON Schema / tool-call mode, native in current APIs) plus a validator at the boundary — on failure, retry once with the validation error appended, then route to a fallback or human queue; never let unvalidated model output flow into downstream steps, because one malformed field silently corrupts every record after it. Respect the engine's **determinism boundary**: in Temporal-class systems, LLM calls are non-deterministic side effects and belong in activities (never workflow code) with results persisted, so replays reuse the recorded output instead of re-rolling the dice; pin model + version + temperature per step and treat a model upgrade like a schema migration — re-run the step's eval set before flipping. For classification steps, add a confidence threshold: below it (or on enum-invalid output), route to a human-review branch — commonly expect to send ~5-15% of volume there at healthy calibration, and alarm if that drifts. Rule: **The workflow engine owns all control flow and every LLM output passes schema validation before it touches a downstream step — no exceptions, including the "it's always worked" step.**

BAD: "Replace the 12-step n8n flow with one agent that has all the API credentials and figures it out" (unreplayable, unauditable, and step 7's hallucinated customer ID posts a real refund). GOOD: "Keep the deterministic flow; insert LLM steps for classify + extract + draft, each schema-validated with a retry-then-human fallback, model versions pinned, LLM calls in activities with persisted results."

```
WORKFLOW + LLM SPEC
═══════════════════
STEP MAP: [step → code | LLM(classify/extract/draft) — why judgment is needed]
LLM STEP: [model@version pinned · temp · prompt ref · JSON Schema out]
VALIDATE: [schema check → retry x1 w/ error → fallback/human queue]
DETERMINISM: [LLM calls in activities · results persisted · replay-safe]
HUMAN BRANCH: [low-confidence route · expected ~5-15% volume · drift alarm]
UPGRADE: [model change = migration: re-run step eval set first]
```

Skip when: the task genuinely needs open-ended multi-step reasoning with dynamic tool choice — that's an agent, and forcing it into fixed steps cripples it; or no step involves unstructured data or judgment (pure code wins).

Gotchas: Letting the LLM emit the next-step decision as free text that code then parses — that's control flow by regex. Validating schema shape but not values (an extracted `amount` of 0 parses fine and refunds nothing). Upgrading the model globally because one step improved, silently regressing the other six. No human-review branch, so low-confidence outputs get laundered into the happy path and discovered in month-end reconciliation.
