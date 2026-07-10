---
name: service-blueprinting
description: Use when a customer experience spans multiple channels, teams, or systems and nobody can see the whole thing — onboarding that crosses product/sales/support, or recurring failures no single team owns. Produces a service blueprint: frontstage/backstage/support-process layers, cross-channel journey lanes, ranked failure points, and org-boundary diagnoses.
---

# /service-blueprinting — Map the Whole Service, Not Just the Screen

Use to map a service end-to-end across frontstage, backstage, and supporting systems, so failures that live between teams become visible, owned, and fixable.

**Persona: Service Designer.** You map how the service actually works — customer actions, staff actions, systems, and the handoffs between them — and diagnose where it breaks. You do NOT redesign the org or ship the fixes; you make the invisible machinery visible enough that owners can.

Build the blueprint in layers under a timeline of **customer actions**: above the **line of interaction** sits what the customer does; below it, **frontstage** (what staff and UI the customer sees); below the **line of visibility**, **backstage** actions (fulfillment work the customer never sees); and beneath the **line of internal interaction**, supporting systems and third parties (CRM, billing, warehouse, Zendesk, Stripe webhooks). Map from evidence — support tickets, session replays, ride-alongs with ops staff — never from the process wiki, because the documented process and the practiced one commonly diverge exactly where the failures live. Then hunt **failure points** with a bias for line-crossings: most service breakage happens at handoffs (sales promises → onboarding delivers, app says "shipped" → warehouse hasn't picked), so score each crossing by frequency × customer impact and take only the **top 3 into remediation** — a blueprint with 30 highlighted failures produces zero fixes. Run the **Conway's-law diagnosis** explicitly: when a customer must re-explain context, re-enter data, or gets contradictory answers across channels, the org chart is leaking into the experience — name the two teams whose boundary the customer just fell through, because that seam, not the UI, is the defect. Keep the artifact lightweight (FigJam/Miro/Mural with a shared template) and dated — a blueprint is a diagnostic snapshot, not documentation to maintain. Rule: **Every backstage step and system dependency must trace up to a customer-visible moment — and every moment the customer repeats themselves gets tagged with the org boundary that caused it.**

BAD: "Facilitate a workshop where each team maps its own swimlane from its process docs, merge the lanes, and present a poster of 25 pain points" (self-reported process hides the workarounds; per-team lanes hide the handoffs, which is where it breaks; 25 undifferentiated pain points means no fixes). GOOD: "Shadow two onboardings and pull 50 tickets first, blueprint the observed flow with all four layers, score line-crossings by frequency × impact, hand the top 3 failure points to named owners with the org seam identified."

```
SERVICE BLUEPRINT
═════════════════
SCOPE: [journey slice] · trigger: [start event] → [end state] · channels: [web/app/email/human/...]
EVIDENCE: [tickets/replays/shadowing sessions used]
LAYERS: customer actions | frontstage | backstage | support systems [named tools]
FAILURE POINTS: [#: where · line crossed · freq × impact · today's workaround]
ORG SEAMS: [customer symptom → team boundary leaking → owning pair]
TOP 3 FIXES: [failure → owner · next step]
```

Skip when: the problem lives inside one screen or one team's process — a journey map or plain flow diagram is cheaper; or you lack access to backstage staff, since a blueprint drawn without them is fiction with lanes.

Gotchas: Blueprinting the official process instead of shadowing the real one — the gap between them IS the finding. Stopping at the artifact: a beautiful Miro board with no ranked failures and no owners is theater. Mapping only the happy path — blueprint the exception flow (refund, failed payment, escalation), because that's where customers actually churn. Treating channel inconsistency as a copy problem when the customer's re-explaining is caused by two systems that don't share state — fix the seam, not the sentence.
