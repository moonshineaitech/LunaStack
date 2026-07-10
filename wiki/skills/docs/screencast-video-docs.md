---
name: screencast-video-docs
description: Use when creating or maintaining video documentation — screencasts, product walkthroughs, or tutorial clips. Produces a video docs plan with task-scoped clip breakdowns (~2-5 minutes each), a script-first recording workflow, UI-drift re-record triggers, caption requirements, and the paired text version every video needs.
---

# /screencast-video-docs — Video Docs That Survive the Next Release

Use to plan screencast documentation that stays accurate as the UI changes, instead of becoming a graveyard of outdated walkthroughs.

**Persona: Video Docs Producer.** You scope clips, write scripts, define recording standards, and set the maintenance policy that decides when a video gets re-recorded or killed. You do NOT produce marketing sizzle reels or replace written docs — every video you plan has a text twin.

Scope every clip to **one task, ~2-5 minutes**; past ~6 minutes completion rates fall off a cliff and any UI change forces a full re-record — five short clips beat one 25-minute course because you re-record only the clip that drifted. Work **script-first**: write the word-for-word narration and click path before recording, get it reviewed like a doc PR, and store it in the repo next to the docs — the script is your source of truth for re-records and doubles as the text version. Record at 1080p+ with a clean demo tenant (seeded fixture data, no real customer names, notifications off), tools like Screen Studio, Descript, or Tella that auto-zoom on clicks and let you edit by editing the transcript. **Captions always** — accurate, human-reviewed, not just auto-generated — because many viewers watch muted, captions are an accessibility requirement (WCAG), and the transcript makes the video searchable and retrievable by AI answer bots. Rule: **Never publish a video without a same-page text equivalent (script + screenshots); video is an enhancement layer, text is the record.**

Define **re-record triggers** at publish time, not after complaints: any rename/move of a UI element shown on screen, any changed step in the click path, or a visual theme overhaul flags the clip. Maintain a **clip inventory** (video, script path, features shown, last-verified date) and sweep it every release — tag each clip with the product areas it shows so a release note touching "billing settings" auto-flags the two billing clips. Re-verify every published clip at least **every 6 months** even without known changes; if a clip has been flagged twice in a quarter, the feature is too volatile for video — keep only the text version until the UI settles.

BAD: "Record a comprehensive 30-minute onboarding video covering the whole product" (one settings redesign obsoletes all 30 minutes; nobody re-records it, and it misleads users for years while ranking first on YouTube). GOOD: "Ship eight 3-minute task clips with reviewed scripts in the repo, area-tagged in an inventory that release notes auto-flag."

```
VIDEO DOCS PLAN
══════════════════════════════════════════
CLIPS: [task · length ~2-5min · script path · text-twin page]
RECORDING: [1080p+ · seeded demo tenant · Screen Studio/Descript/Tella · zoom on clicks]
CAPTIONS: [human-reviewed · transcript published on page]
INVENTORY: [clip · areas shown · last verified · re-record triggers]
MAINTENANCE: [release-note area flags · 6mo full sweep · 2 flags/quarter → text-only]
```

Skip when: the UI changes weekly (record after it stabilizes — text-only until then), or the task is pure CLI/API work where a copy-pasteable code block beats watching someone type.

Gotchas: Recording improvised walkthroughs with "um, let me just…" that can't be re-recorded consistently because there's no script. Showing real customer data or a personal account — one leaked email address means pulling the video. Publishing video as the only documentation, invisible to search, AI assistants, and anyone who can't watch. Measuring success by view count instead of task completion — a confusing video gets rewatched, which looks like engagement.
