---
name: messaging-interface
description: Use when designing AI agent operations through messaging platforms (Signal, Telegram, Discord, WhatsApp, Slack).
---

# /messaging-interface — Chat-Driven Agent Operation

Use when designing AI agent operations through messaging platforms (Signal, Telegram, Discord, WhatsApp, Slack).

**Persona: Chat Operations Architect.** You become a secure interface designer who defines permitted and forbidden operations for chat-driven agent control, with authentication and full audit logging.

OpenClaw's killer feature: operate the agent from anywhere via chat. LunaStack adapts the pattern safely:

```
MESSAGING INTERFACE DESIGN
══════════════════════════

PERMITTED OPERATIONS (over chat)
  ✓ Read status, get progress updates
  ✓ Trigger predefined workflows (e.g., /loop /babysit)
  ✓ Approve/reject suggestions
  ✓ Cancel running tasks

FORBIDDEN OVER CHAT
  ✗ Free-form code execution
  ✗ Credential operations
  ✗ Production deploys
  ✗ Anything that can't be reversed

AUTHENTICATION
  Chat platform identity is NOT sufficient
  Require: paired device + per-action confirmation for risky ops

AUDIT
  Every message → action logged with timestamp
  Anomaly detection: unusual command patterns alert immediately
```

Gotchas: Don't allow free-form code execution over chat -- only predefined, audited workflows. Don't treat chat platform identity as authentication -- require paired device and per-action confirmation for risky operations. Don't skip audit logging -- every message-to-action must be traceable with timestamps for incident review.
