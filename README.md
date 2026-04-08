<p align="center">
  <strong>◑ LunaStack</strong><br>
  <em>245 protocols · 27 disciplines · 55 specialist roles · one file</em>
</p>

<p align="center">
  <a href="https://github.com/moonshineaitech/LunaStack/actions/workflows/validate.yml"><img src="https://github.com/moonshineaitech/LunaStack/actions/workflows/validate.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://github.com/moonshineaitech/LunaStack/releases"><img src="https://img.shields.io/github/v/release/moonshineaitech/LunaStack" alt="Release"></a>
</p>

<p align="center">
  The most comprehensive AI development methodology open-sourced.<br>
  Sourced from Superpowers (94K★), GStack (66K★), Boris Cherny (Claude Code creator),<br>
  Anthropic official docs, HumanLayer research, and OpenClaw lessons.
</p>

<p align="center">
  <a href="#use-it-in-60-seconds">Quick Start</a> ·
  <a href="#whats-inside">All Protocols</a> ·
  <a href="#whats-new-mythos-edition">What's New</a> ·
  <a href="#sources">Sources</a>
</p>

---

## Use It in 60 Seconds

**Method 1 — Claude Projects (recommended)**

1. Download [`LunaStack.md`](LunaStack.md)
2. Go to [claude.ai](https://claude.ai) → Projects → New Project → Add to Project Knowledge
3. Type any `/command` and Claude follows the protocol

**Method 2 — Claude Code CLI**

```bash
git clone https://github.com/moonshineaitech/LunaStack ~/lunastack
cd ~/lunastack && ./setup.sh --global    # symlinks 239 skills
claude "/luna"                              # start
```

**Method 3 — Team Install (auto-updating)**

```bash
./setup.sh --team    # SessionStart hook auto-updates from origin
```

---

## What's New: Mythos Edition

This release integrates everything from the latest research scan (April 2026):

### 🌀 Superpowers Pipeline (12 protocols)
The full obra/superpowers v5.0.7 methodology — `/1pct-rule`, `/no-placeholders`, `/subagent-driven`, `/skill-priority`, `/tool-mapping`, `/find-duplicates`, `/verify-completion`, `/yagni-enforce`, `/evidence-over-claims`, `/linear-pipeline`, `/skill-test-loop`, `/visual-companion`.

### 🏗️ GStack Team (15 protocols)
Garry Tan's exact production setup — `/office-hours` (YC partner mode), `/design-consultation`, `/design-shotgun`, `/design-html`, `/design-review` (80-item visual audit with letter grades), `/codex-review` (cross-model independent review), `/cso-audit` (OWASP Top 10 + STRIDE), `/careful-mode`, `/freeze`, `/unfreeze`, `/investigate-frozen`, `/team-install`, `/readiness-dashboard`, `/test-plan-handoff`, `/global-retro`, `/devex-review`.

### 🔬 OpenClaw Patterns (10 protocols)
Lessons from the fastest-growing repo in GitHub history — `/skill-security-audit` (the "12% of community skills are malicious" lesson), `/sandbox-design`, `/memory-isolation`, `/skill-review-system`, `/multi-llm-routing`, `/persistent-memory`, `/messaging-interface`, `/vibe-coding-warnings`, `/local-model-fallback`, `/platform-skills-architecture`.

### 🌐 Multi-Host (8 protocols)
Run LunaStack across all major AI coding harnesses — `/platform-detect`, `/tool-translate`, `/session-bootstrap`, `/worktree-aware`, `/sandbox-fallback`, `/env-detection`, `/universal-skill`, `/host-config`. Works on Claude Code, Codex, Cursor, Gemini CLI, Copilot CLI, OpenCode.

### 🛡️ Security Skills (8 protocols)
Hardened development from Trail of Bits + CVE lessons — `/cve-scan`, `/supply-chain-audit`, `/codeql-semgrep`, `/threat-db`, `/malicious-skill-detection`, `/sbom`, `/dependency-typosquat`, `/secret-rotation-plan`.

---

## What's Inside

**27 disciplines · 245 protocols · 55 specialist roles · 30 Gotchas sections**

| Discipline | # | Highlights |
|:---|:---:|:---|
| ◑ **Meta** | 8 | `/luna` `/guard` `/onboard` `/second-opinion` |
| ◍ **Inquiry** | 7 | `/inquiry` `/premortem` `/spike` `/thesis` |
| △ **Architecture** | 8 | `/architect` `/api-contract` `/cost` `/dependency` |
| ▭ **Specification** | 6 | `/spec` `/plan` `/autoplan` `/estimate` |
| ⬡ **Construction** | 13 | `/tdd` `/build` `/debug` `/pair` `/reflexion` |
| ◇ **Verification** | 5 | `/verify` (6 agents) `/threat-model` `/chaos` |
| ◎ **Craft** | 7 | `/design-critique` `/design-variants` `/friction` |
| ▸ **Delivery** | 8 | `/ship` `/rollback` `/monitor` `/incident` |
| ∞ **Memory** | 7 | `/retro` `/learn` `/compound` `/handoff` |
| 👔 **Leadership** | 8 | `/cfo` `/pitch` `/hiring` `/compete` |
| 🔬 **Research** | 5 | `/user-interview` `/persona` `/jobs-to-be-done` |
| 🔧 **Infrastructure** | 8 | `/auth` `/cache` `/queue` `/payments` |
| 📝 **Content** | 4 | `/write` `/email` `/error-message` |
| 📊 **Growth** | 5 | `/ab-test` `/funnel` `/retention` `/seo` |
| 🔐 **Compliance** | 3 | `/privacy` `/legal` `/security-response` |
| 🧠 **Decisions** | 4 | `/decision` `/rfc` `/negotiate` `/delegate` |
| ⚡ **Performance** | 3 | `/perf-budget` `/load-test` `/query` |
| 🎯 **Best Practices** | 11 | `/interview-me` `/fresh` `/redo` `/grill` |
| 🧰 **Workflows** | 5 | `/plan-mode` `/worktree` `/test-time-compute` |
| 🔥 **Latest** (Boris) | 9 | `/self-improve` `/babysit` `/verify-loop` |
| 🌀 **Superpowers Pipeline** | 12 | `/1pct-rule` `/no-placeholders` `/linear-pipeline` |
| 🏗️ **GStack Team** | 15 | `/office-hours` `/design-shotgun` `/codex-review` `/cso-audit` |
| 🔬 **OpenClaw Patterns** | 10 | `/skill-security-audit` `/multi-llm-routing` |
| 🌐 **Multi-Host** | 8 | `/platform-detect` `/tool-translate` `/universal-skill` |
| 🛡️ **Security Skills** | 8 | `/cve-scan` `/supply-chain-audit` `/threat-db` |
| 🧬 **Frontier (Original)** | 6 | `/ralph-loop` `/context-budget-check` `/security-review` `/agent-orchestra` `/drift-detect` `/cost-tracker` |
| 🎭 **Specialist Roles** | 55 | See below |

### Workflows

```
NEW FEATURE (full pipeline):
  /office-hours → /interview-me → /inquiry → /spec → /plan
  → /no-placeholders → /linear-pipeline → /tdd → /verify-completion
  → /codex-review → /cso-audit → /readiness-dashboard → /ship
  → /global-retro → /compound

QUICK SHIP:
  /spec → /plan → /tdd → /build → /verify → /ship

EMERGENCY FIX:
  /investigate-frozen → /debug → /tdd → /verify-completion → /ship

DESIGN SPRINT:
  /office-hours → /design-consultation → /design-shotgun
  → /design-html → /design-review → /implement-design

SECURITY RELEASE:
  /threat-model → /cso-audit → /supply-chain-audit → /codeql-semgrep
  → /codex-review → /readiness-dashboard → /ship

POST-INCIDENT:
  /incident → /learn → /compound → /threat-db → /guard
```

---

## 55 Specialist Roles

| Domain | Roles |
|:---|:---|
| **Engineering** (10) | `/frontend-lead` `/backend-lead` `/dba` `/sre` `/mobile-lead` `/ml-engineer` `/devrel` `/data-engineer` `/qa-lead` `/platform-lead` |
| **Business** (8) | `/ceo` `/coo` `/cmo` `/vp-sales` `/bd` `/investor` `/pm-lead` `/account-mgr` |
| **Creative** (5) | `/copywriter` `/brand` `/content-strategist` `/ux-writer` `/creative-director` |
| **Data** (3) | `/data-analyst` `/data-scientist` `/bi-analyst` |
| **People** (5) | `/recruiter` `/hr-lead` `/coach` `/facilitator` `/l-and-d` |
| **Marketing** (5) | `/paid-ads` `/social-media` `/email-marketing` `/pr` `/growth-hacker` |
| **Customer** (3) | `/support-lead` `/cs-lead` `/community-mgr` |
| **Legal** (3) | `/ip-lawyer` `/employment-lawyer` `/compliance-officer` |
| **Domain** (6) | `/saas-advisor` `/marketplace-advisor` `/fintech-advisor` `/ecommerce-advisor` `/healthcare-advisor` `/ai-product` |
| **Operations** (3) | `/scrum-master` `/ops-manager` `/procurement` |

---

## Sources

| Source | Stars/Authority | What LunaStack took |
|:---|:---|:---|
| [obra/superpowers](https://github.com/obra/superpowers) | 94K★ (137K dev) | Full linear pipeline, 1% rule, no-placeholders, subagent-driven dev, skill priority, tool mapping, TDD-for-skills |
| [garrytan/gstack](https://github.com/garrytan/gstack) | 66K★ (v0.15.14.0) | Office hours, design pipeline, 80-item review, cross-model review, CSO audit, freeze/guard, team install |
| [Boris Cherny](https://howborisusesclaudecode.com/) | CC creator | Self-improvement loop, /loop+skill, verify-loop (2-3x quality), parallel sessions |
| [shanraisshan/best-practice](https://github.com/shanraisshan/claude-code-best-practice) | 17K★ | Gotchas sections, goals+constraints, /redo, /grill, comprehensive workflow patterns |
| [Anthropic official docs](https://code.claude.com/docs/en/best-practices) | Authoritative | /interview-me, fresh sessions, subagent delegation, context management |
| [HumanLayer research](https://www.humanlayer.dev/blog/writing-a-good-claude-md) | Production | CLAUDE.md ~80% compliance, hooks 100%, ~150-200 instruction limit |
| [OpenClaw](https://github.com/steipete/openclaw) | 247K★ (fastest growing) | Skill security lessons, multi-LLM routing, vibe coding warnings |
| [Trail of Bits](https://github.com/trailofbits) | Security firm | CodeQL/Semgrep, supply chain audit, CVE-mapped threats |
| [NeoLabHQ/reflexion](https://github.com/NeoLabHQ) | Open source | Self-correction loops |
| [Compound Engineering](https://every.to/) | Every.to | Plan → work → review → compound learning loop |
| [o16g Manifesto](https://onebrief.com/) | Cory Ondrejka | Outcome engineering: define outcomes, let AI implement |

---

## Files

| File | Purpose | Size |
|:---|:---|:---|
| `LunaStack.md` | **The single file.** Upload to Claude Project. Everything works. | 197KB |
| `*/SKILL.md` | 239 individual skill files for Claude Code CLI | — |
| `setup.sh` | Symlinks all skills into `~/.claude/skills/` | 0.5KB |
| `uninstall.sh` | Removes symlinks | 0.3KB |

---

## Start Here

Don't try all 239 protocols at once. Start with these 7:

1. **`/office-hours`** — YC partner interrogation. Make sure you're building the right thing.
2. **`/interview-me`** — Have Claude interview YOU. Surface edge cases you haven't considered.
3. **`/no-placeholders`** — Validate any plan before execution. Zero tolerance for TBD.
4. **`/verify-completion`** — Never mark anything done without proof.
5. **`/codex-review`** — Independent review from a different model. Catches Claude's blind spots.
6. **`/self-improve`** — After every correction, write a prevention rule. Compound smarter every session.
7. **`/global-retro`** — Weekly aggregation across all your AI tools and projects.

---

## License

MIT — same as Superpowers, GStack, and OpenClaw.

---

<p align="center">
  <em>Software development is a discipline. Treat it like one.</em><br><br>
  <sub>239 protocols · 26 disciplines · 55 roles · 4,810 lines · 197KB · MIT</sub>
</p>
