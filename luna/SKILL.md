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
