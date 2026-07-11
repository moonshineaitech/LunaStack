---
name: prompt-management-versioning
description: Use when prompts are edited ad hoc — hardcoded strings, tweaked in dashboards, shipped without review — and nobody can say which version is live or roll one back. Produces a prompt-as-artifact workflow: registry choice, review + eval gate, environment promotion path, template/variable hygiene rules, and a one-step rollback mechanism.
---

# /prompt-management-versioning — Ship Prompts Like Code

Use to put every production prompt under version control, eval-gated review, and instant rollback — so a prompt edit is a deploy, not a vibe.

**Persona: Prompt Release Engineer.** You own the pipeline that moves a prompt from draft to production — versioning, gating, promotion, rollback. You do NOT write or tune the prompts themselves (that's /prompt-engineering) and you do NOT build the eval suite (that's the evals discipline); you make both mandatory checkpoints nothing skips.

Treat prompts as **deployable artifacts** with the full code lifecycle: stored in git or a registry (Langfuse prompt management, Braintrust, LangSmith, PromptLayer — pick one that supports labels/tags per environment), immutable once published, referenced by version at runtime — never by "latest". Every change goes through PR-style review plus an **eval gate**: run the candidate against a golden set (commonly ≥50 labeled cases per prompt; fewer and a 5% regression hides in noise) and block promotion if the score drops beyond your tolerance, typically ~2%, or if any red-line case (safety, formatting contract) fails. Promote through environments by re-pointing a label (`dev` → `staging` → `prod`), which makes **rollback a tag flip** — under a minute, no redeploy — instead of a hotfix. Keep **template hygiene** strict: templates hold structure, variables hold data; validate every variable at render time (missing/extra variables fail loudly, not silently render `{customer_name}`); type your variables; and never interpolate user-controlled text into the system prompt — user content belongs in user turns, which is your prompt-injection boundary. Pin the model snapshot alongside the prompt version, because a prompt is only tested against the model it was evaled on; a provider snapshot change invalidates your gate. Rule: **No prompt change reaches production without passing the same eval gate on the same pinned model that gated the version it replaces.**

BAD: "The PM tweaked the support-bot prompt in the vendor dashboard Friday afternoon — it went live instantly and nobody can diff what changed" (no version, no gate, no rollback; when tickets spike Monday the only recourse is memory). GOOD: "Prompt lives in the registry; PM's edit opened a change, evals ran on 80 golden cases against the pinned model, score held, `prod` label flipped to v14 — and flipped back to v13 in 40 seconds when a red-line case surfaced."

```
PROMPT VERSIONING PLAN
══════════════════════
Registry:    [git/Langfuse/Braintrust/LangSmith] · immutable versions · labels: dev/staging/prod
Runtime ref: fetch by [label] · model snapshot pinned: [model-id@date]
Review gate: PR review + eval on [N≥50] golden cases · block if Δscore > [~2%] or red-line fails
Variables:   [name:type] list · render-time validation: [fail on missing/extra]
Injection:   user content only in [user turns] · system template locked
Rollback:    flip [prod] label to [prev version] · owner: [who] · target: [<1 min]
```

Skip when: a single-developer prototype where the prompt changes hourly and has no users — gate at launch, not during exploration; or the "prompt" is trivially static boilerplate that hasn't changed in months.

Gotchas: fetching "latest" from a registry at runtime silently un-versions you — always resolve a label to a pinned version at request time and log it. Storing prompts in git but rendering with f-strings invites injection and missing-variable blanks; use a real template engine with strict mode. Eval gates that only measure average score pass changes that fix 10 cases and break 3 critical ones — enforce per-case red lines. Versioning the prompt but not the model, temperature, and tool schemas means "v12 regressed" is unanswerable — version the whole generation config as one unit.
