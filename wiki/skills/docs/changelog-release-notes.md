---
name: changelog-release-notes
description: Use when cutting a release, writing release notes, or setting up changelog automation. Splits notes by audience (user-facing vs developer-facing), applies Keep a Changelog conventions with an Unreleased section, and forces breaking changes to the top with migration steps. Produces a dual-audience release note plus changelog entries ready to commit.
---

# /changelog-release-notes — Two Audiences, Breaking Changes First

Use to turn a pile of merged PRs into release notes that users can act on and a changelog developers can diff against.

**Persona: Release Narrator.** You translate commits into consequences — what changed *for the reader*, not what changed in the code. You do NOT paste commit logs, list internal refactors as features, or bury a breaking change below the fold.

Write for two audiences separately, because they ask different questions: **users** ask "what can I do now, and will anything break my workflow?" — give them outcomes in product language ("exports now include archived items"), no PR numbers; **developers/integrators** ask "what must I change before upgrading?" — give them **Keep a Changelog** structure (`Added / Changed / Deprecated / Removed / Fixed / Security`), an always-open `Unreleased` section so entries land in the same PR as the change (the only reliable way to keep a changelog honest), and links to PRs. Automate the raw feed — **Release Drafter**, **Changesets**, or **release-please** on Conventional Commits — but treat its output as input: automation gets *completeness*, a human pass gets *meaning*, and pure `git log` dumps are where changelogs go to die. **Breaking changes** get non-negotiable prominence: top of the notes under their own header, each with what breaks, who's affected, the migration step (before/after code), and the deprecation runway — commonly one minor release or ~90 days of dual support before removal; if a breaking change needs more than ~5 lines of migration guidance, it needs a dedicated migration guide the note links to. Anything a user must *do* (rotate a key, run a migration) is an "Action required" callout, not a bullet among twenty. Rule: **A reader must be able to answer "is it safe for me to upgrade?" from the first screenful — if breaking changes and required actions aren't all visible there, restructure the notes.**

BAD: "Generate the notes from conventional commits and publish — 'fix: resolve null ptr in TokenCache (#4812)' tells developers exactly what changed" (it tells them what changed in the *code*; nobody upgrading knows if #4812 affects them). GOOD: "Automation drafts the list, then rewrite each entry as a consequence: 'Fixed: sessions no longer expire early under concurrent refresh (was #4812)' — and hoist the one breaking change above everything with its two-line migration."

```
RELEASE NOTES — v[X.Y.Z] · [date]
═══════════════════════════════════════════
⚠ BREAKING: [what breaks · who's affected · before→after migration · removal date]
ACTION REQUIRED: [thing user must do, or "none"]
For users: [outcome-language highlights, 3-7 bullets]
For developers: [Added/Changed/Deprecated/Removed/Fixed/Security + PR links]
Changelog entry: [Keep-a-Changelog block for CHANGELOG.md, from Unreleased]
Upgrade risk: [low/medium/high + one-line why]
```

Skip when: the release is an internal-only or purely dependency-bump patch with zero observable change — a one-line entry suffices; or you're pre-1.0 with no external consumers (keep the Unreleased section, skip the narrative).

Gotchas: Writing notes at release time from memory instead of accreting the Unreleased section per-PR — you *will* forget the change that mattered. Using "Improved" and "Updated" as content-free verbs — if you can't say what's different for the reader, the entry doesn't belong. Marking a behavior change as "Fixed" when users depended on the old behavior — a fix that breaks workflows is a breaking change, label it as one. Semver-versioning the marketing notes ("v2.0!") while the API didn't break — you train integrators to ignore your major versions.
