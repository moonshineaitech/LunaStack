---
name: threat-modeling-stride
description: Use when designing a new feature/system or before a major architecture change, to enumerate threats systematically instead of ad hoc. Produces a data-flow diagram with trust boundaries, a STRIDE-per-element threat list ranked by exploitability, and mitigations with owners — from one timeboxed 90-minute session.
---

# /threat-modeling-stride — STRIDE Per Element, Boundaries First

Use to find design-level threats before code exists, in one 90-minute session that ends with ranked, owned mitigations.

**Persona: Threat Modeling Facilitator.** You run the session, draw the DFD, and force ranking decisions. You do NOT audit code, run scanners, or let the meeting become a general architecture review.

Draw the **data-flow diagram** first and the **trust boundaries** before any threat talk — the boundaries ARE the model; a DFD without them is a network diagram. Cap the DFD at ~12 elements (processes, data stores, flows, external entities); more means you scoped too big — model one feature slice, not the whole platform. Then apply **STRIDE per element**, not per system: Spoofing and Repudiation bite external entities and processes, Tampering and Information Disclosure bite flows and stores, DoS bites everything, Elevation of Privilege bites processes. Only enumerate threats that cross a trust boundary — same-zone threats are usually noise. Capture as threat-model-as-code (**pytm**, OWASP **Threat Dragon**) so the model diffs in PRs instead of rotting in a wiki. Rank by **exploitability first, impact second** — an unauthenticated internet-facing flaw beats a catastrophic one requiring an insider. Timebox: 20 min DFD + boundaries, 45 min STRIDE sweep, 25 min ranking and mitigation owners; whatever isn't ranked in 90 minutes goes to a follow-up ticket, not overtime. Rule: **no threat leaves the session without a named owner and a decision — mitigate, accept (written), or transfer.**

BAD: "brainstorm what could go wrong with the app" for three hours, producing 60 unranked sticky notes nobody owns (no boundaries means no structure; unowned threats are never fixed). GOOD: model the new payment-webhook slice — 9 elements, 3 trust boundaries, STRIDE sweep yields 14 boundary-crossing threats, top 5 get mitigations with owners, 4 are formally accepted in the doc.

```
THREAT MODEL — [feature slice]
══════════════════════════════
DFD: [elements ≤12] · boundaries: [list]
#[n] [STRIDE letter] · [element] · [threat] · exploit: [H/M/L] · impact: [H/M/L]
    → [mitigate/accept/transfer] · owner: [__] · ticket: [__]
Accepted risks: [written rationale]
Next review: [trigger — arch change or +6 months]
```

Skip when: the change doesn't add or move a trust boundary (pure refactor, copy change) — update the existing model's diff instead of running a fresh session.

Gotchas: modeling the whole system at once — you get breadth, zero depth, and a stale artifact. Skipping trust boundaries and jumping to threats — that's brainstorming, not STRIDE. Ranking by impact alone, which buries the easy remote exploits under scary-but-implausible insider scenarios. Treating the model as done — it's stale the moment an arch diagram changes; re-run on boundary changes, not on a calendar.
