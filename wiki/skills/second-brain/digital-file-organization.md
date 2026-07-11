---
name: digital-file-organization
description: Use when files are scattered across desktop, downloads, and five cloud drives — duplicates everywhere, nothing findable, no real backup. Produces naming conventions (ISO-8601 dates first), a shallow folder scheme with a ~3-level depth cap, a search-first retrieval habit, and a 3-2-1 backup posture.
---

# /digital-file-organization — Name for Search, Back Up for Fire

Use to impose a minimal, durable file scheme: names that sort and search themselves, folders that stay shallow, and backups that survive a dead laptop or a ransomware note.

**Persona: File Hygienist.** A digital janitor with strong opinions and a small rulebook. Standardizes names, caps folder depth, deletes duplicates, and verifies restores. Does not build elaborate taxonomies, does not sort what search can find, and treats sync as convenience — never as backup.

Filenames are the only metadata that survives every migration, so spend the discipline there: **ISO-8601 date first** (`2026-07-10_client_proposal_v2.pdf`) so files sort chronologically in any tool forever; then entity/project, then content, then version — no spaces-vs-underscores anarchy, no `final_FINAL_v3(2).docx` (versions are `v1, v2` or, for anything that matters, a real versioned store). Folders: **~3 levels deep maximum** — beyond that, filing time and retrieval failures both climb, and every deep hierarchy eventually forces a file that belongs in two places. A shallow scheme like `/Projects/<name>/`, `/Areas/<name>/`, `/Archive/<year>/` covers most lives; when a project ends, its folder moves to Archive whole, untouched. Adopt the **search-first mindset**: with good names, Spotlight/Everything/cloud search retrieves in seconds, so organize only what search can't disambiguate — browsing folders is the fallback, not the plan. Downloads and Desktop are **inboxes, not storage**: a weekly ~10-minute sweep files or deletes everything (an auto-delete-after-30-days rule on Downloads enforces honesty). Backup is non-negotiable **3-2-1**: three copies, two media, one off-site — in practice a local Time Machine/File History drive plus a versioned cloud backup (Backblaze-class, or cloud-drive with version history) — and note that Dropbox/Drive/iCloud sync alone fails the test, because sync faithfully replicates your deletions and any ransomware encryption within minutes. Test a restore twice a year; an unverified backup is a hope. Rule: **If future-you couldn't find the file by search terms in its name, the name is wrong — fix names before adding folders.**

BAD: "Design a 7-level folder taxonomy and spend the weekend re-filing ten years of documents into it" (every file now has one debatable home, filing costs minutes per document, and next year's files pile up unfiled anyway). GOOD: "Rename as you touch: date-first, searchable words, shallow `/Projects` and `/Archive`, weekly Downloads sweep — and let search do the finding."

```
FILE SYSTEM POSTURE
═══════════════════
Naming: [YYYY-MM-DD_entity_content_vN · no spaces-anarchy]
Folders: [Projects/Areas/Archive · depth ≤3]
Inbox sweep: [Downloads+Desktop · weekly ~10 min · 30-day auto-delete]
Retrieval: [search-first · tool: Spotlight/Everything/cloud]
Backup 3-2-1: [local drive · versioned cloud · off-site] · Sync ≠ backup
Restore test: [2×/year · last verified: date]
```

Skip when: an org-mandated DMS/SharePoint scheme governs the files (follow it; a private parallel system creates divergence) or the corpus is small and short-lived enough that search alone suffices.

Gotchas: mistaking sync for backup until a deletion or ransomware event propagates to every "copy" you had; big-bang reorganizations that consume a weekend and decay in a month — convert incrementally, on touch; version numbers in names for collaborative documents that should live in Google Docs/SharePoint versioning; hoarding duplicates "to be safe," which makes every future search return four candidates and every backup slower — deduplicate, then trust the backup you actually verified.
