# Architecture

## System Overview

LunaStack is 239 AI development protocols organized into 26 disciplines with 55 specialist roles. Each protocol is a Markdown file that instructs an AI coding assistant to adopt a specific persona, follow a defined procedure, and produce structured output. The protocols cover the full software lifecycle: discovery, architecture, construction, verification, delivery, and learning.

There are two distribution modes:

- **Single-file** (`LunaStack.md`, 197KB) -- All 239 protocols concatenated into one file. Upload to a Claude Project's knowledge base. The agent scans the full file and activates the matching protocol when a user types a `/command`.
- **Individual skills** (`*/SKILL.md`, 239 directories) -- Each protocol in its own directory. Installed into `~/.claude/skills/` via symlinks for Claude Code CLI. The agent loads only the relevant skill file when activated.

## How Skills Work

Every skill is a Markdown file with two layers:

```
---                                    # YAML frontmatter (~100 tokens)
name: verify                           #   kebab-case, matches directory name
description: Review Board.             #   what it does + when to activate
---                                    # --- end frontmatter ---
# /verify -- Review Board              # Flat prose body (<5K tokens)
                                       #   persona, procedure, output format,
**Role: Review Coordinator.**          #   gotchas
Launch 6 review angles, then synthesize.
...
Gotchas: If every review returns APPROVED...
```

**Progressive disclosure.** During scanning, the agent reads only the frontmatter description (~100 tokens per skill). The full body loads only when the user activates that command. This keeps context usage proportional to what is actually needed, not to the size of the library.

## Discipline Taxonomy

The 26 disciplines map to cognitive modes -- what the agent is doing, not what domain it covers:

| Cognitive Mode | Disciplines | Example Skills |
|:---|:---|:---|
| Understanding | Meta, Inquiry, Research | `/luna` `/inquiry` `/user-interview` |
| Designing | Architecture, Specification | `/architect` `/spec` `/plan` |
| Building | Construction, Workflows | `/tdd` `/build` `/pair` `/plan-mode` |
| Proving | Verification, Performance | `/verify` `/chaos` `/load-test` |
| Crafting | Craft, Content | `/design-critique` `/write` |
| Shipping | Delivery, Growth | `/ship` `/monitor` `/ab-test` |
| Learning | Memory, Decisions | `/retro` `/learn` `/compound` `/decision` |
| Governing | Compliance, Security, Leadership | `/privacy` `/cve-scan` `/cfo` |
| Extending | Superpowers, GStack, OpenClaw, Multi-Host | `/linear-pipeline` `/office-hours` |

## Protocol Chaining

Skills are designed to compose. Each protocol's output is the next protocol's input.

```
FULL PIPELINE (new feature):
  /office-hours --> /interview-me --> /inquiry --> /spec --> /plan
  --> /no-placeholders --> /linear-pipeline --> /tdd --> /verify-completion
  --> /codex-review --> /cso-audit --> /readiness-dashboard --> /ship
  --> /global-retro --> /compound

QUICK SHIP:
  /spec --> /plan --> /tdd --> /build --> /verify --> /ship

EMERGENCY FIX:
  /investigate-frozen --> /debug --> /tdd --> /verify-completion --> /ship

DESIGN SPRINT:
  /office-hours --> /design-consultation --> /design-shotgun
  --> /design-html --> /design-review --> /implement-design

SECURITY RELEASE:
  /threat-model --> /cso-audit --> /supply-chain-audit --> /codeql-semgrep
  --> /codex-review --> /readiness-dashboard --> /ship

POST-INCIDENT:
  /incident --> /learn --> /compound --> /threat-db --> /guard
```

The routing entry point is `/luna`, which reads project context and directs the user to the right starting protocol based on their intent.

## The Compound Loop

Four protocols form a learning flywheel that makes each session smarter than the last:

```
 /retro                /learn                /compound           /self-improve
 Quantified        --> Extract           --> Feed Forward    --> Write Prevention
 Retrospective         Learnings              to CLAUDE.md       Rules

 "What happened?"      "What patterns?"      "Write it down"    "Never repeat it"
      |                                                               |
      +--------- next session reads CLAUDE.md <-----------------------+
```

- `/retro` -- Measures the session: lines changed, tests added, coverage delta, time per phase.
- `/learn` -- Extracts patterns, anti-patterns, preferences, and conventions from the session. Each learning is presented for developer approval.
- `/compound` -- Writes approved high-confidence learnings into CLAUDE.md or project instructions so they persist across sessions.
- `/self-improve` -- Boris Cherny's golden rule: after any correction, the agent writes a positive rule that prevents the mistake from recurring.

The flywheel effect: session N's learnings become session N+1's instructions. Over time, the project's CLAUDE.md becomes a living document of institutional knowledge.

## Installation Architecture

`setup.sh` symlinks each skill directory into the Claude Code skills path.

```
Repository                          Target
~/lunastack/                        ~/.claude/skills/
  tdd/SKILL.md        -- ln -s -->    tdd/ -> ~/lunastack/tdd/
  verify/SKILL.md      -- ln -s -->    verify/ -> ~/lunastack/verify/
  ship/SKILL.md        -- ln -s -->    ship/ -> ~/lunastack/ship/
  ... (239 dirs)                      ... (239 symlinks)
```

Three installation modes:

| Mode | Command | Target | Use Case |
|:---|:---|:---|:---|
| Global | `./setup.sh --global` | `~/.claude/skills/` | Personal machine, all projects |
| Project | `./setup.sh --project` | `.claude/skills/` | Single repo, checked in |
| Team | `./setup.sh --team` | `~/.claude/skills/` + auto-update hook | Shared team setup |

**Hardening in setup.sh:**
- Refuses to run as root (`EUID` check, exits immediately)
- Directory name allowlist: only `[a-z0-9][a-z0-9-]*` passes; anything else is skipped with a warning
- Skips directories without a `SKILL.md` file
- Replaces existing symlinks cleanly; never overwrites real directories

## Multi-Platform Compatibility

LunaStack works across AI coding harnesses through three protocols:

- `/platform-detect` -- Runs at session start. Checks environment variables (`CLAUDE_PLUGIN_ROOT`, `CURSOR_PLUGIN_ROOT`, `CODEX_CI`, `GEMINI_CLI`, etc.) to identify the host and its capabilities (subagent support, native skill tool, sandboxing model).
- `/tool-translate` -- Translates platform-specific tool names when porting protocols. Example: "Use the Read tool" becomes the equivalent call on Codex, Gemini CLI, or Copilot CLI.
- `/universal-skill` -- Authoring guidelines for cross-platform skills: describe actions not tools, include platform notes, provide subagent fallbacks, avoid shell injection syntax.

Supported platforms: Claude Code, OpenAI Codex, Cursor, Gemini CLI, GitHub Copilot CLI, OpenCode.

## Security Model

**8 defensive security skills:**

| Skill | Purpose |
|:---|:---|
| `/cve-scan` | Run `npm audit` / `pip-audit` / `cargo audit` before releases |
| `/supply-chain-audit` | Verify dependency provenance, check for typosquats and obfuscation |
| `/codeql-semgrep` | Static analysis with CodeQL and Semgrep rulesets |
| `/threat-db` | CVE-mapped threat database for the project |
| `/skill-security-audit` | Vet community skills before installing (the "12% are malicious" lesson) |
| `/malicious-skill-detection` | Runtime detection of suspicious skill behavior |
| `/sbom` | Software bill of materials generation |
| `/dependency-typosquat` | Detect packages with names similar to popular packages |
| `/secret-rotation-plan` | Plan and execute credential rotation |

**setup.sh hardening:** Root guard (refuses `EUID 0`), directory name allowlist (rejects anything outside `[a-z0-9-]`), skips dirs without `SKILL.md`.

**CI validation** (`.github/workflows/validate.yml`):
1. Every skill directory must contain a `SKILL.md` file
2. Every `SKILL.md` must have YAML frontmatter with `name` and `description`
3. No skill file exceeds 200 lines (content leakage detection)
4. Total skill count must be >= 230 (prevents accidental mass deletion)

## File Relationships

```
CLAUDE PROJECTS (single-file mode):

  tdd/SKILL.md ----+
  verify/SKILL.md --+--> concatenated into --> LunaStack.md --> upload to --> Claude Project
  ship/SKILL.md ----+                          (197KB)          Knowledge Base
  ... (239 files)


CLAUDE CODE CLI (skill directory mode):

  tdd/SKILL.md ----+
  verify/SKILL.md --+--> setup.sh symlinks --> ~/.claude/skills/ --> Claude Code CLI
  ship/SKILL.md ----+                          (239 symlinks)       reads on /command
  ... (239 dirs)


SUPPORTING FILES:

  CLAUDE.md          Contributor instructions (AI reads this when editing the repo)
  CONTRIBUTING.md    Protocol format specification
  ETHOS.md           Design philosophy (evidence > intuition, systems > heroes)
  setup.sh           Installer (symlinks + hardening)
  validate.yml       CI (frontmatter, leakage, count checks)
```
