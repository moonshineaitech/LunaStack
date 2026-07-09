---
name: prioritize
description: Use when a list of tasks, features, or bugs all look urgent and you must decide what to do now, schedule, delegate, or drop. Force-ranks by impact × urgency, cuts the bottom 30%, and assigns owners and deadlines to the top 3.
---

# /prioritize — Ruthless Prioritization

**Role: Decision-Maker.** When everything is urgent, nothing is.

Given a list of tasks/features/bugs:
1. Force-rank by: impact (who benefits, how much) × urgency (what happens if delayed)
2. Apply the 2×2: High Impact + Urgent → DO NOW, High Impact + Not Urgent → SCHEDULE, Low Impact + Urgent → DELEGATE/QUICK FIX, Low Impact + Not Urgent → DROP
3. Cut the bottom 30%. If you can't, you haven't been honest about impact.
4. For the top 3: specific next action, owner, deadline

```
PRIORITY RANKING
═════════════════
DO NOW:       [item] — impact: [H] urgency: [H] → owner: [name] by [date]
              [item] — impact: [H] urgency: [H] → owner: [name] by [date]
SCHEDULE:     [item] — impact: [H] urgency: [L]
QUICK FIX:    [item] — impact: [L] urgency: [H]
DROPPED (30%): [item], [item], [item]
Top 3 next actions:
  1. [action] — [owner] — [deadline]
  2. [action] — [owner] — [deadline]
  3. [action] — [owner] — [deadline]
```

BAD vs GOOD. BAD: "Fix login bug, redesign dashboard, upgrade CI -- all P1, ship this sprint." (everything urgent, no impact split, nothing cut, no owners.) GOOD: "Login bug blocks ~40% of signups -> DO NOW, owner Ana, by Fri. Dashboard redesign -> SCHEDULE. CI upgrade -> DROP." (ranked by impact, bottom cut, top item owned and dated.)

Anti-fabrication: if impact, urgency, an owner, or a deadline wasn't stated by the user, write "unknown" or "unassigned" -- never invent a name, a date, or a number to fill the slot. Flag unknown owners/deadlines as a follow-up question instead.

Skip when: the list has 3 or fewer items, or one hard external deadline already forces the order -- just do them, don't ceremony-rank.

Gotchas: Don't rank by urgency alone -- urgency without impact is a distraction. Don't keep the bottom 30% "just in case" -- if you can't cut, you haven't been honest about impact. Don't prioritize without assigning owners and deadlines -- a prioritized list without accountability is just a wish list.

---
