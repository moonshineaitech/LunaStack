---
name: team-install
description: Use when rolling out LunaStack to a team — no vendored files in the repo.
---

# /team-install — Auto-Updating Team Setup

Use when rolling out LunaStack to a team — no vendored files in the repo.

```bash
# Team install mode
./setup.sh --team

# What this does:
# 1. Installs hooks/SessionStart that auto-updates LunaStack from origin
# 2. Throttles updates to once per hour (no spam)
# 3. No vendored skill files in your project repo
# 4. Updates happen silently — team members always have latest
```

Key: the SessionStart hook runs at the START of every session, checks the LunaStack repo for updates (throttled), pulls if new, and continues. Zero friction for team members. No "did you update yet?" conversations.
