---
name: timezone-datetime-handling
description: Use when storing, scheduling, or displaying times — especially future events, recurring schedules, or anything crossing DST boundaries. Produces a storage policy (UTC vs wall-time + IANA zone), a DST test matrix, and a date-vs-datetime type audit.
---

# /timezone-datetime-handling — Time Is a Policy Decision, Not a Type

Use to make datetime handling correct across zones, DST transitions, and future rule changes.

**Persona: Temporal Correctness Engineer.** Decides how each timestamp is stored, converted, and displayed, and builds the DST-boundary test suite. Does NOT tune clock sync/NTP or design event-ordering protocols — this is calendar correctness, not distributed-systems time.

The rule everyone half-knows — "store UTC" — is right for **past events** (things that happened: log entries, payments) and wrong for **future civil events**. A meeting at "9:00 AM in Berlin next March" must be stored as **wall-clock time + IANA zone** (`2027-03-15T09:00` + `Europe/Berlin`), because governments change DST rules with months of notice; a precomputed UTC instant silently drifts to 8:00 or 10:00 when tzdata updates. Never store raw offsets (`+02:00`) — an offset is a moment's answer, not a zone's identity. Keep **date and datetime as different types**: a birthday, invoice date, or check-in day has no time component, and coercing it to midnight-UTC is how users born on the 5th get greeted on the 4th — the classic **local-midnight trap** (a `DATE` shoved through a datetime pipeline shifts a day for every user west of Greenwich). Recurring events ("every Monday 9:00") store the recurrence rule (RRULE) + zone and expand occurrences on read, per-occurrence in the zone — never materialize UTC instants ahead. Use real tzdata-backed libraries — `java.time`, Python's `zoneinfo`, JS **Temporal** (now shipping in modern runtimes; stop reaching for moment.js, and treat `Date` as a UTC-instant container only) — and pin/refresh tzdata in your images. Your DST test matrix needs at minimum **4 cases**: spring-forward gap (2:30 AM doesn't exist), fall-back overlap (1:30 AM happens twice), a zone with :30/:45 offsets (Asia/Kolkata, Australia/Eucla), and a southern-hemisphere zone whose DST is inverted (America/Santiago). Rule: **Store past instants as UTC; store future civil times as wall-time + IANA zone and convert at read time — deciding which of the two each field is IS the design work.**

BAD: "Convert the user's 9 AM standup to UTC once and store that" (next tzdata update or DST shift, every occurrence is an hour off and support can't explain why). GOOD: "Store `09:00 + RRULE:FREQ=WEEKLY + America/Chicago`, expand to instants at query time with current tzdata."

```
DATETIME POLICY
═══════════════
Field audit: [field → past-instant(UTC) | future-civil(wall+IANA) | date-only]
Types: [timestamptz/instant · local-datetime+zone col · DATE]
Recurrence: [RRULE+zone, expand-on-read] · tzdata: [source · refresh cadence]
Display: [convert at edge, user's zone from profile not browser-guess alone]
DST tests: [gap · overlap · :30 offset · southern hemisphere]
```

Skip when: the system is single-zone and records only past events (an internal log viewer for one office) — UTC everywhere with one display conversion is genuinely enough.

Gotchas: Postgres `timestamptz` does NOT store the zone — it stores UTC; keep a separate `zone` column when the civil time matters; testing DST by mocking "one hour later" instead of the actual gap/overlap instants; trusting the browser's zone for scheduling when the user books travel (offer, don't assume); doing "add 1 day" as "+86400 seconds" — across a DST boundary those differ, and calendar math must use calendar APIs.
