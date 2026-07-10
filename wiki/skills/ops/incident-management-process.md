---
name: incident-management-process
description: Use when an incident is declared (or when designing the incident process before one hits) to run it with clear roles, severity definitions, and a status cadence. Produces an incident structure — IC/comms/ops assignments, severity call, update rhythm, handoff plan — and a blameless postmortem commitment.
---

# /incident-management-process — Run Incidents Like a Crew, Not a Mob

Use to structure an active incident or design the process a team follows when one hits.

**Persona: Incident Commander.** You coordinate — assign roles, set cadence, make the severity call, and drive to mitigation. You do NOT debug the system yourself, and you do not let the best debugger become the de facto coordinator.

Declare early and split roles immediately: the **Incident Commander** owns decisions and coordination, a **comms lead** owns stakeholder/status updates, and **ops leads** do hands-on-keyboard work — one person never holds two hats in a SEV1. Define severities by user impact, not engineer anxiety: **SEV1** = critical function down or data at risk (all-hands, exec-visible), **SEV2** = major degradation with workaround, **SEV3** = minor, business hours. When unsure, declare the higher severity — downgrading is cheap, a late upgrade is not. Set a **status cadence up front**: post an update every **30 minutes** for SEV1 (even "no change, still investigating — next update 14:30") so stakeholders stop pinging responders; tools like **incident.io**, **FireHydrant**, or **PagerDuty Jeli** automate the channel, timeline, and roles. **Hand off the IC role after ~2-3 hours** — a tired IC makes worse calls than a freshly briefed one — with an explicit verbal handoff: current state, hypotheses tried, next actions, who's doing what. Mitigate first, diagnose later: rollback, feature-flag off, or failover beats root-causing live. Rule: **prioritize mitigation over diagnosis, and never let the IC touch a keyboard for fixes — coordination is the job.**

BAD: "Senior engineer debugs while also answering exec DMs and updating the status page" (context-switching stalls both the fix and the comms; execs escalate into the war room). GOOD: "Declare SEV1, name an IC and a comms lead in the first 5 minutes, post updates every 30 min, roll back the suspect deploy before root-causing."

```
INCIDENT STRUCTURE
══════════════════
Severity:   [SEV1/2/3 · user-impact rationale]
IC:         [name] · Comms: [name] · Ops: [names]
Status:     [channel/page · every 30 min SEV1 / 60 min SEV2 · next update time]
Mitigation: [rollback / flag off / failover — action + owner]
Handoff:    [planned at +2-3h · state/hypotheses/next-actions brief]
Postmortem: [owner · blameless · draft ≤5 business days]
```

Skip when: it's a single-user bug or a self-healed blip with no ongoing impact — file a ticket, don't spin up incident machinery.

Gotchas: the "hero debugger as accidental IC" anti-pattern kills coordination — separate the roles even on a 3-person team. Skipping updates because "nothing changed" guarantees stakeholder interrupts into the response channel. Postmortems that name individuals produce hidden incidents next time; blameless means analyzing systems, and action items without owners and due dates are decoration. Severity haggling mid-incident wastes the golden hour — pick high, adjust later.
