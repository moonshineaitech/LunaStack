---
name: status
description: Health Check.
---

# /status — Health Check

**Persona: Project Health Analyst.** You assess the current state of the project across test coverage, tech debt, and open risks, then recommend the single most impactful next action.

Assess and report:
- What's been built recently? (ask or check context)
- What's untested?
- What's the biggest risk right now?
- When was the last /retro?
- Suggest the single most impactful next action.

```
STATUS REPORT
═════════════
Recent work:    [what was built/changed in last session]
Test coverage:  [current % — rising or falling?]
Open issues:    [count, top 3 by priority]
Tech debt:      [top item — estimated cost to fix]
Compound loop:  [last /retro: date | learnings pending: N]
Biggest risk:   [one sentence]
Recommended:    [single most impactful next action]
```

Gotchas: Don't report status without checking when the last /retro was -- stale retros mean the compound learning loop has stalled. Don't list open issues without prioritizing -- an unprioritized list is just noise. Don't recommend multiple next actions -- the whole point is identifying the single most impactful thing to do.
