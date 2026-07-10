# Behavioral Evals

The `tests/` suites at the repo root prove skills are **structurally** correct
(frontmatter, output format, gotchas, self-containment, discovery budget). Those
run free in CI on every push.

This directory proves something harder: that a skill, when actually applied to a
realistic scenario, **exercises its own decision rules** — not just that it
*mentions* them. A skill can pass every structural check and still be useless if
"stop after 2 failed fixes" never actually fires. That gap is where most prompt
libraries quietly fail. This is the only tier that catches it.

## The method

For each skill under test, three independent agents run in a pipeline:

1. **Execute** — reads the real `SKILL.md`, invents a concrete scenario that
   should trigger the skill, then applies the skill's persona, procedure, and
   *numeric* decision rules to that scenario and produces the prescribed output.
2. **Judge** — an adversarial evaluator scores 0–5 whether the output genuinely
   follows the skill. The pass bar is not "the format is present" — it is
   "the decision rules were exercised against the scenario's actual numbers"
   (e.g. did `/debug` show the 2-failed-fixes stop rule operating; did
   `/interview-me` cap at 5–9 questions).
3. **Verify** — a second agent tries to *refute* the judge, checking for both
   rubber-stamping (passing an output that only gestures at the rules) and
   over-penalizing (failing an output that genuinely complied). It returns the
   corrected score.

The corrected score is authoritative. A skill "passes" at **≥ 4/5**.

## Why this is Tier 2 (not in the free CI gate)

This eval spawns LLM agents — it costs tokens and is non-deterministic, so it is
not wired into the per-push `quality` workflow the way the structural checks are.
It is run deliberately before a release, and the scorecard is committed to
`results/` so the numbers are public and diffable across versions.

## Reproduce

The eval is orchestrated as a multi-agent workflow (see the session that produced
`results/`). To re-run, apply the same three-stage pipeline (execute → judge →
verify) over the skills in `../distribution/packs/core.txt`, reading each real
`SKILL.md`. Scenarios used in each run are archived under `scenarios/` and the
scorecard under `results/`.

## Files

- `scenarios/<version>.md` — the concrete scenario each skill was tested against
- `results/<version>.md` — the scorecard: per-skill final score, whether the
  decision rules were exercised, and the failures found
