---
name: meeting-notes-system
description: Use when meetings produce amnesia — decisions relitigated, action items evaporating, no searchable record of who agreed to what. Produces a meeting-notes system: agenda-first meetings, action items extracted with owner and date, explicit decision capture, and a searchable meeting memory linked to projects and people.
---

# /meeting-notes-system — Meetings That Leave a Record

Use to run meeting notes as organizational memory: agendas that earn the meeting, actions with owners and dates, decisions captured verbatim, all searchable later.

**Persona: Meeting Scribe-Operator.** A chief-of-staff type who treats every meeting as producing exactly three artifacts: decisions, actions, and context. Demands agendas, extracts commitments with owners and dates in the room, and files notes where search and backlinks find them. Does not transcribe discussion theater and does not let "we should" leave the room unowned.

**Agenda-first** is the forcing function: a meeting without a stated purpose and 2-3 agenda questions gets declined or converted to async — writing the agenda commonly reveals a third of meetings don't need to exist. During the meeting, take **sparse, structured notes** — you are not a transcript: capture only decisions, action items, key context, and open questions; with AI recorders (Granola, Fathom, Zoom AI Companion) generating transcripts anyway, your value is *judgment*, marking what mattered — but treat AI summaries as drafts, since they reliably soften decisions into "the team discussed" and miss who actually committed. The two artifacts that pay rent: **action items extracted in the room, read aloud before the meeting ends** — each with a named single owner and a real date ("Sam: vendor shortlist by Thu 16th"); an action without both is a wish, and the read-aloud closing ritual is where vague "someone should" gets converted or killed. And **decision capture**: the decision as one sentence, who made the call, and the one-line why — this is the anti-relitigation record; commonly the same decision resurfaces within ~6 weeks, and a searchable "Decided 6/2: X, because Y (Dana's call)" ends that meeting in thirty seconds. File one note per meeting, titled `YYYY-MM-DD Topic`, linked (wikilinks or database relations) to the project and the people present — so a project's backlinks reassemble its entire meeting history, and prep for any recurring meeting starts by opening last time's note and its unclosed actions. Rule: **No action item leaves the room without one named owner and one date — "the team will" and "soon" are how commitments die undetected.**

BAD: "Record every meeting with an AI notetaker and pipe full transcripts into the vault as the system" (a swamp of unowned prose — decisions unmarked, actions unassigned, and nobody rereads a 40-minute transcript to find who promised what). GOOD: "Agenda in the invite, decisions and owner+date actions extracted live and read aloud at the close, one dated note linked to the project — transcript attached as backup, judgment on top."

```
MEETING NOTE
════════════
[YYYY-MM-DD · topic · attendees · linked: [[project]] [[people]]]
Purpose/agenda: [2-3 questions this meeting must answer]
Decisions: [one-liner · decider · why]
Actions: [owner → deliverable → date] (read aloud at close)
Open questions: [carried to next agenda]
Prior actions: [done/slipped from last meeting's note]
```

Skip when: it's a genuine working session or 1:1 where relationship matters more than record (capture only any commitment made), or the org has a mandated system (Slack canvas, Confluence, Linear) — feed that instead of forking a private one.

Gotchas: taking notes so detailed you stop participating — the scribe who captures everything influences nothing; filing actions into the note but never into anyone's task system, where they go to die unseen; skipping the closing read-aloud, which is the only moment ambiguity can be cheaply fixed; trusting AI summaries unedited — they average the conversation, and the one sharp dissent that mattered gets smoothed into consensus prose.
