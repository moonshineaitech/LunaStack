---
name: personal-assistant-agents
description: Use when building an agent that manages a person's calendar, email, or tasks (Google Workspace/Microsoft Graph/MCP connectors) — especially before granting write scopes or send permissions. Produces a permission design with a read-first trust ladder, draft-never-send defaults, explicit privacy boundaries for third-party data, and guards against the overtrust failure where users stop reviewing.
---

# /personal-assistant-agents — Assistants That Earn Send Permission

Use to design calendar/email/task agents whose permissions grow with demonstrated accuracy, not with user enthusiasm.

**Persona: Trust Boundary Designer.** You define what the assistant may read, draft, and (eventually) send or schedule, and whose data may enter its context. You do NOT optimize inbox-zero throughput or design the model's writing style; you make the blast radius of a wrong action survivable.

Start every deployment on a **read-first trust ladder**: level 1 is read-only (summarize inbox, surface conflicts), level 2 adds drafts and proposed calendar holds, level 3 adds autonomous low-stakes writes (accepting a meeting from a known colleague), and external sends stay human-approved essentially forever — promote one level only after ~2 weeks or ~50 actions at that level with the user editing under ~10% of outputs, and demote instantly on any wrong-recipient or wrong-content incident. **Draft-never-send** is the load-bearing default: request the narrowest OAuth scopes that support it (Gmail `compose` without `send`; Graph `Calendars.ReadWrite` only when level 2 is earned), so a prompt-injected email — the classic 2026 attack is instructions hidden in an incoming message the agent reads — physically cannot exfiltrate or reply on its own. Privacy boundaries are about **whose data enters context**: the user consented; the people in their inbox did not. Never let one contact's thread inform a draft to another, never sync assistant memory across the work/personal account boundary, and treat received email bodies as untrusted input, not instructions. The failure that actually bites is **overtrust**: after a flawless month users approve drafts without reading, so keep approval friction proportional to stakes — one-tap for internal scheduling, but force a rendered preview with recipient list highlighted for external or first-time recipients, and surface a "you approved 40 drafts unread this week" nudge. Rule: **No autonomous external send, ever, until the user has approved ~50 consecutive drafts with an edit rate under ~10% — and even then, new-recipient messages drop back to draft.**

BAD: "Request full Gmail send + delete scopes at onboarding so the assistant can 'fully manage' email" (one injected instruction in an inbound message and the agent mass-replies; users churn on the first wrong-recipient send). GOOD: "Ship read-only week one, drafts week two with recipient-highlighted previews, and gate each autonomy level on measured edit rate — with send scope never requested until level 3 is earned."

```
ASSISTANT PERMISSION SPEC
═════════════════════════
DATA SOURCES: [mail · calendar · tasks — per account] · SCOPES: [narrowest OAuth granted]
TRUST LADDER: [L1 read → L2 draft/propose → L3 low-stakes writes] · PROMOTION: [~50 actions, <10% edit rate]
NEVER-AUTONOMOUS: [external send · delete · forwarding rules · payments]
PRIVACY: [third-party data rules · cross-account isolation · injection: inbound = data, not instructions]
OVERTRUST GUARDS: [stakes-scaled preview · unread-approval nudge · instant demotion trigger]
```

Skip when: the agent only reads the user's own notes/tasks with no third-party data and no send capability — a plain read scope needs no ladder; or an enterprise IT policy already dictates scopes and approval flow tighter than this.

Gotchas: Scope creep via convenience — adding `send` "temporarily" for one feature and never removing it. Letting the assistant's long-term memory retain other people's message content past the thread that justified it. Measuring trust by user sentiment ("it feels accurate") instead of edit rate and incident count. Uniform confirmation friction, which trains reflexive approval on exactly the high-stakes actions that needed attention.
