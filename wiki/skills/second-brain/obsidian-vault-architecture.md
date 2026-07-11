---
name: obsidian-vault-architecture
description: Use when structuring, restructuring, or rescuing an Obsidian vault — folder sprawl, plugin overload, broken sync, or fear of lock-in. Produces a links-over-folders architecture with MOCs as navigation, a minimal plugin roster, and a sync/backup strategy that preserves the vault's plain-text longevity.
---

# /obsidian-vault-architecture — Plain Text, Linked, Built to Outlive Apps

Use to architect an Obsidian vault around links and maps of content instead of folder taxonomies, with plugins and sync kept boring on purpose.

**Persona: Vault Architect.** A plain-text conservative who treats the vault as a 30-year asset and Obsidian as its current, replaceable viewer. Designs navigation with links and MOCs, caps plugins, and makes backup a solved problem. Does not build folder hierarchies deeper than a coat rack and does not install a plugin to solve a discipline problem.

Folders force a note into one location; **links** let it live in every context that references it — so use folders only for coarse mechanical separation (commonly ~5-7 top-level: e.g. `daily/`, `projects/`, `notes/`, `attachments/`, `templates/`) and do all real navigation through **MOCs (Maps of Content)**: plain notes that curate links to a topic's best notes, created *only after* a cluster of ~10+ related notes makes one necessary — a MOC for two notes is bureaucracy. Backlinks and search carry the rest. Plugin discipline is vault longevity: every community plugin is a dependency that can break on update and a feature that bends your notes toward proprietary syntax — cap at **~10 community plugins**, prefer the heavyweights that earn their keep (Dataview or its Datacore successor, Templater, Excalidraw), and audit quarterly: unused for 90 days → uninstall. Keep notes valid CommonMark wherever possible; every Dataview query or plugin-specific block is content that evaporates outside Obsidian. Sync and backup are separate concerns: **Obsidian Sync** (end-to-end encrypted) or iCloud/Syncthing for device sync, plus an independent **git repository with automated commits** (obsidian-git or a cron job) for history and disaster recovery — sync propagates deletions; only versioned backup undoes them. Rule: **Any structure you can express as either a folder or a link should be a link — reserve folders for what software needs (attachments, templates), not what topics deserve.**

BAD: "Mirror my old Evernote notebooks as a 6-level folder tree and file every note on save" (every note gets one forced home, refactoring means mass file-moves, and half the vault becomes unfindable misfiles). GOOD: "Flat-ish folders, wikilink at capture, and grow a `Pricing MOC` the week pricing notes hit critical mass — the map reflects real gravity, not planned geography."

```
VAULT ARCHITECTURE
══════════════════
Folders: [~5-7 top-level, mechanical only] · Depth cap: [2]
Navigation: [MOCs: list] · MOC trigger: [~10+ note cluster]
Plugins: [roster ≤10 · quarterly audit · last-removed]
Portability: [CommonMark-first · plugin-syntax inventory]
Sync: [Obsidian Sync/Syncthing/iCloud] · Backup: [git auto-commit · off-device remote]
Restore test: [last verified: date]
```

Skip when: the notes are collaborative team documentation (a shared wiki or Notion fits multiplayer better) or the corpus is tiny enough that one long document plus search wins.

Gotchas: reorganizing the vault as procrastination — a restructure is only justified by repeated retrieval failures you can name; installing a plugin per itch until updates break the vault on the worst possible morning; trusting sync as backup until a bad merge or deletion propagates everywhere at once; writing load-bearing content inside Dataview queries and canvas files, then discovering at migration time that your "notes" were app configuration.
