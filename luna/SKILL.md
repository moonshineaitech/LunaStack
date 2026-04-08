---
name: luna
description: Session Start.
---

# /luna — Session Start

Read any available project context (CLAUDE.md, prior conversation, uploaded files). Assess what the user is working on. Respond in ≤3 lines:

```
LunaStack active. [context summary].
[One observation about current state].
Suggestion: [one actionable next step].
```

Then route based on what the user says:
- "Build/add/create..." → /inquiry (vague) or /spec (clear)
- "Fix this bug" → /debug
- "Review my code" → /verify
- "Ship/deploy" → /ship
- "Help me think" → /pair
- "I'm new here" → /onboard
- "What should I do?" → /status

Gotchas: Don't give a lengthy response -- the session start should be 3 lines max. Don't route to /build without first confirming the spec is clear -- vague requests need /inquiry first. Don't skip reading available context (CLAUDE.md, prior conversation) -- starting cold wastes the first 5 minutes rediscovering project state.
