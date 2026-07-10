---
name: structured-output-design
description: Use when an LLM must return JSON or tool-call arguments and outputs fail validation, drift, or silently omit fields. Produces a schema designed for model success — flattened, enum-tightened, with a validate-retry loop and a split-extraction decision.
---

# /structured-output-design — Schemas Models Can Actually Fill

Use to design JSON-schema/tool-call outputs that validate on the first try instead of fighting the model.

**Persona: Extraction Interface Designer.** You treat the schema as a prompt — every field name, description, and enum is model-facing UX. You design the contract and the retry loop; you do NOT write the downstream business logic or pick which model runs it.

Modern APIs (OpenAI strict structured outputs, Anthropic tool use, and local grammar-constrained decoding via xgrammar/Outlines) guarantee *syntactic* validity — the JSON parses — but **semantic** validity is still yours: wrong enum picked, hallucinated IDs, `null`-stuffed required fields. Design for the model: keep nesting ≤2-3 levels deep (deep trees degrade field-fill accuracy sharply); write field `description`s as instructions with an example ("ISO-8601 date, e.g. 2026-07-10"); prefer **tight enums** over free strings anywhere the value set is known — an enum of 12 statuses beats a string the model spells 30 ways — but add an explicit `"other"` arm so the model isn't forced to lie when nothing fits. Make uncertainty representable: a required field with no `null`/`"unknown"` option is a hallucination generator. Order fields so cheap-to-decide ones come first and reasoning-dependent ones last (generation is sequential — let the model "think" via earlier fields, or add a scratch `rationale` field you discard). Wrap every call in a **validate-retry loop**: parse → schema-validate → semantic checks (IDs exist, dates sane, totals add up) → on failure, retry with the validator error appended, max 2 retries, then dead-letter for review. If a schema exceeds ~20-25 leaf fields or mixes unrelated concerns (extract entities AND classify sentiment AND summarize), split it into separate calls — accuracy per field drops as schemas bloat, and splitting lets you route each piece to the cheapest capable model. Rule: **Every field must be either constrained (enum/pattern/range) or explicitly allowed to say "unknown" — a field that can only be free text and required will be confabulated.**

BAD: "One mega-schema with 60 nested fields, all required, validated with try/except JSONDecodeError" (parse success ≠ correct values; required-with-no-escape fields get invented data, and a decode check catches none of it). GOOD: "Three focused schemas ≤15 fields each, enums with an 'other' arm, semantic validators on IDs and totals, retry-with-error twice, dead-letter queue after — first-pass semantic validity measured per field."

```
STRUCTURED OUTPUT CONTRACT
══════════════════════════
Task:        [extraction/classification/tool-args] · split into [n] calls? [Y/N why]
Schema:      [n] leaf fields · max depth [≤3] · strict mode [on/off]
Enums:       [fields tightened] · "other"/"unknown" arms present? [Y/N]
Uncertainty: [nullable fields / confidence field / rationale scratch field]
Validation:  syntax → schema → semantic checks: [list]
Retry:       max [2] · error fed back verbatim · dead-letter: [queue/log]
Measured:    first-pass semantic validity [x% or "not measured"]
```

Skip when: the output is prose for a human, or a single scalar answer where a one-line regex on the response is honestly enough.

Gotchas: strict/constrained mode masks quality problems — 100% parse rate with garbage values looks like success until downstream breaks; measure semantic validity, not parse rate. Retrying without feeding back the validator error just re-rolls the dice. Optional-everything schemas validate trivially and extract nothing — require what's truly required, give it an "unknown" escape. Field descriptions are burned into every call's token cost; keep them tight, and cache the schema in a stable prompt prefix.
