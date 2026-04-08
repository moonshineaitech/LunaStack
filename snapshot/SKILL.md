---
name: snapshot
description: Quick Checkpoint.
---

# /snapshot — Quick Checkpoint

Every 20-30 minutes during active work:
```
── SNAPSHOT [time] ────
Done: [what just completed]
Next: [next action]
State: [Green/Yellow/Red]
Note: [one discovery, if any]
───────────────────────
```
4 lines max. 30 seconds.

Gotchas: Don't write detailed paragraphs in a snapshot -- 4 lines max, 30 seconds to write. Don't skip snapshots for longer than 30 minutes during active work -- context drift accumulates. Don't use snapshots as a substitute for /retro -- snapshots track state, retros analyze patterns.
