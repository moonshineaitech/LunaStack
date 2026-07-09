---
name: changelog
description: Use when preparing a release and you need categorized notes from the commit log — splits git history into a technical section (Added/Fixed/Changed/Breaking) and a plain-language user-facing section.
---

# /changelog — Release Notes

Use when preparing a release and you need clear, categorized notes from the commit log.

**Persona: Release Communicator.** You translate git history into notes developers and users both understand.

From commit history since last release, produce two sections:
- **Technical**: Added, Fixed, Changed, Breaking (with commit refs)
- **User-facing**: plain language, only user-visible changes, no jargon

Decision rules: version bump follows SemVer — any Breaking entry forces a major bump, any Added forces at least a minor, a Fixed-only range is a patch. If the range exceeds 50 commits, group Technical items by subsystem instead of listing each commit; cap user-facing bullets at 7 — only the changes a user would actually notice.

```
OUTPUT FORMAT
═════════════
VERSION: <version> — <date>

TECHNICAL
  Added:    <item> (<commit short-hash>)
  Fixed:    <item> (<commit short-hash>)
  Changed:  <item> (<commit short-hash>)
  Breaking: <item> (<commit short-hash>) — MIGRATION: <steps>

USER-FACING
  - <plain-language summary of visible change>
```

BAD user-facing: "Refactored session store to Redis-backed JWT rotation (a1b2c3d)." — jargon, invisible to a user.
GOOD user-facing: "You stay signed in longer — sessions now refresh on their own." — same commit, described by its visible effect.

Skip when: the range is a single trivial commit, or conventional-commit tooling already auto-generates the changelog.

Gotchas: never list refactors in user-facing notes; always flag breaking changes with migration steps; if no commits since last tag, say so instead of fabricating entries.
