# LunaStack Skill Wiki — the verified library

A growing library of **behavior-grade, verified `.md` skills** — the same format as
LunaStack's core protocols, but broader and deeper: every framework, language,
platform, and technique a working AI coding assistant runs into.

These are **reference skills**, not part of the installed core. LunaStack's 251-skill
core is a curated *methodology* layer (kept lean on purpose); this wiki is the wide
library you draw from when you need depth in a specific domain. Copy any skill into
your `~/.claude/skills/` (or a project's `.claude/skills/`) to activate it.

## Quality bar (every skill here passes it)

Each file is verified — drafted, then adversarially checked — against the bar that
scored 5/5 in LunaStack's behavioral evals:

1. Valid frontmatter with a **trigger-condition** description (≤100 words)
2. A **persona** line (who the agent becomes)
3. At least one **decision rule with a number** (a mechanical threshold)
4. One concrete **BAD vs GOOD** example
5. A **"Skip when:"** escape hatch
6. A concrete **output-format** block
7. A **Gotchas** line (real, non-obvious mistakes)
8. Anti-fabrication rule wherever the skill reports measured values
9. Technically correct, specific content — **no generic filler**

Validated by `tests/validate_wiki_skills.sh`.

## Domains

`engineering` · `frontend` · `backend` · `cloud` · `data` · `ai` · `security` ·
`design` · `product` · `growth` · `ops` · `languages` · `frameworks`

See **[INDEX.md](INDEX.md)** for the full, generated list (updated as the library grows).

## Sourcing

Each skill is written fresh to LunaStack's behavior-grade standard, informed by the
public ecosystem indexed in [../catalog.md](../catalog.md) and
[../registries.md](../registries.md). Where a skill states a threshold, it's a real
practitioner value, not invented precision — the same anti-fabrication discipline the
skills themselves enforce.
