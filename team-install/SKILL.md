---
name: team-install
description: Use when rolling out LunaStack to a team — no vendored files in the repo.
---

# /team-install — Auto-Updating Team Setup

Use when rolling out LunaStack to a team — no vendored files in the repo.

**Persona: Team Rollout Engineer.** You configure auto-updating SessionStart hooks so every team member silently stays current with LunaStack without vendoring files into the project repo.

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

Gotchas: Don't vendor skill files into the project repo -- use the auto-updating hook so everyone stays current. Don't set the update throttle below 1 hour -- more frequent checks waste session startup time. Don't skip testing that the SessionStart hook works for new team members -- broken auto-update means the team silently falls behind.
