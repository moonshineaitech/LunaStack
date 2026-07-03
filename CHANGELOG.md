# Changelog

All notable changes to LunaStack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-04-08

### Added
- `build.sh` — generates `LunaStack.md` from the individual SKILL.md files. Skills are
  now the single source of truth; the single-file distribution is a build artifact.
- `distribution/` — build inputs (header template, discipline section headers, static
  appendix with Flow Maps, Worked Examples, Cross-References, Universal Anti-Patterns)
- `build.sh --check` sync gate in CI — fails if LunaStack.md drifts from the skills
- Release workflow — pushing a `v*` tag verifies VERSION + sync, then creates a GitHub
  Release with notes extracted from this file and LunaStack.md attached as an asset
- 10 Frontier skills (original research): `/ralph-loop`, `/context-budget-check`,
  `/security-review`, `/agent-orchestra`, `/drift-detect`, `/cost-tracker`,
  `/silent-failure-audit`, `/ai-provenance`, `/graceful-escalation`, `/perception-gap`
- Test infrastructure: `tests/validate_skills.sh`, `tests/validate_integrity.sh`,
  `tests/quality_score.sh` (5-point rubric, letter grades, threshold gate)
- `ARCHITECTURE.md`, `AGENTS.md` (complete skill catalog), multi-platform adapters
  (`GEMINI.md`, `CODEX.md`, `.cursorrules`, `.opencode.md`)

### Changed
- `LunaStack.md` regenerated from skills — now includes all 249 protocols with the
  full persona lines, output format blocks, and gotchas that previously existed only
  in the individual skill files (203 personas and 211 gotchas, up from 71 and 40)
- All 249 skills brought to 100% quality: persona, output format, and gotchas coverage
- `competing/` renamed to `parallel-compare/` (name collided with `/compete`)
- Security hardening: root guards + name allowlists in setup/uninstall scripts,
  SHA-pinned CI actions, explicit workflow permissions

### Fixed
- 36 SKILL.md files contained leaked content from the monolithic file
- CI failures: `tests/` and `distribution/` no longer treated as skill directories

## [1.0.0] - 2026-04-08

### Added
- 239 protocols across 26 disciplines
- 55 specialist roles
- Superpowers Pipeline (12 protocols) from obra/superpowers v5.0.7
- GStack Team (15 protocols) from garrytan/gstack v0.15.14.0
- OpenClaw Patterns (10 protocols) from steipete/openclaw lessons
- Multi-Host compatibility (8 protocols) for Claude Code, Codex, Cursor, Gemini CLI, Copilot CLI, OpenCode
- Security Skills (8 protocols) from Trail of Bits + CVE lessons
- Latest Patterns (9 protocols) from Boris Cherny
- `LunaStack.md` single-file distribution (197KB)
- `setup.sh` for Claude Code CLI skill installation (global, project, team modes)
- `lunastack.jsx` landing page component
- GitHub best practices: issue templates, PR template, CI workflow, security policy, code of conduct
- `CLAUDE.md` contributor AI rules
- `CONTRIBUTING.md` with protocol format specification
- `ETHOS.md` project philosophy

[1.1.0]: https://github.com/moonshineaitech/LunaStack/releases/tag/v1.1.0
[1.0.0]: https://github.com/moonshineaitech/LunaStack/releases/tag/v1.0.0
