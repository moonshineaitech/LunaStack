# LunaStack Skill Wiki — the verified library

A growing library of **behavior-grade, verified `.md` skills** — the same format as
LunaStack's core protocols, but broader and deeper: every framework, language,
platform, and technique a working AI coding assistant runs into.

## The two layers (how the whole repo fits together)

| Layer | Where | What it is | Count |
|---|---|---|---|
| **Core protocols** | repository root (`/*/SKILL.md`) | *Process* skills — how to work: `/tdd`, `/debug`, `/ship`, `/spec`, `/premortem`, `/red-team`… Installed via `./setup.sh`; kept lean on purpose. | 251 |
| **Skill wiki** | `wiki/skills/<domain>/` | *Domain-knowledge* skills — what a specialist knows: `/postgres-production-tuning`, `/context-engineering`, `/multiplayer-netcode`, `/chemo-cycle-support`… | see [INDEX.md](INDEX.md) |

Rule of thumb: **core tells the agent how to behave; the wiki tells it what a
specialist knows.** They compose — run `/tdd` (core) while `/react-expert` (wiki)
informs the code. Wiki skills are reference skills, not installed by default:
copy any into `~/.claude/skills/` (or a project's `.claude/skills/`) to activate it.

## How the wiki is organized

Domains are directories; every skill is one self-contained `.md` file. The
generated **[INDEX.md](INDEX.md)** lists every skill with a one-line description
(regenerate with `tests/gen_wiki_index.sh` after any change).

- **Build**: `languages` · `frameworks` · `frontend` · `backend` · `mobile` · `embedded` · `gamedev` · `ai` · `agents`
- **Run**: `cloud` · `ops` · `databases` · `data` · `security` · `testing`
- **Design & decide**: `architecture` · `design` · `docs` · `devtools` · `engineering`
- **Grow & lead**: `product` · `growth` · `business` · `leadership` · `education` · `content-creation`
- **Live**: `second-brain` · `finance` · `health`

Domains with special rules carry their own README:

- **[health/](health/README.md)** — 133 personal-health skills under a CI-enforced
  safety contract (non-diagnostic, disclaimer-first, 911/988 escalation,
  defer-to-professional). **Read its README before touching the domain.**
- **[gamedev/](gamedev/README.md)** — game development, including the
  medical-content-in-games safety skills that bridge health × games
  (built for LunaCelsus-class projects).

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

Validated by `tests/validate_wiki_skills.sh`; health skills additionally pass
`tests/validate_health_skills.sh` (the safety gate). The behavioral eval harness
in `tests/eval/` goes further, testing what skills make an agent *do*.

## Sourcing

Each skill is written fresh to LunaStack's behavior-grade standard, informed by the
public ecosystem indexed in [../catalog.md](../catalog.md) and
[../registries.md](../registries.md). Where a skill states a threshold, it's a real
practitioner value, not invented precision — the same anti-fabrication discipline the
skills themselves enforce.
