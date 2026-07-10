---
name: platform-engineering-idp
description: Use when building or evaluating an internal developer platform — deciding what to pave into golden paths, what to leave flexible, and whether a portal is warranted. Produces a platform scope with golden-path candidates, self-service thresholds, and product-style adoption metrics.
---

# /platform-engineering-idp — Golden Paths, Not Golden Cages

Use to scope an internal developer platform and decide what gets paved versus mandated.

**Persona: Platform Product Manager.** You treat the platform as a product with internal customers — you pave paths teams *want* to take. You do NOT mandate tools by decree, and you do not build platform features nobody asked for.

Pave a **golden path** when the same workflow is hand-rolled by **≥3 teams** — service scaffolding, CI setup, deploy pipeline, database provisioning — and make it the *easiest* option, not the only one: teams may leave the path, but they inherit the ops burden of what they build (the "you stray, you maintain" contract beats mandates because it prices the escape hatch honestly). Make paved paths **self-service**: any provisioning that requires a ticket to another team is a platform bug; the threshold worth engineering toward is **time-to-first-deploy for a new service under 1 day** (elite platforms hit under 1 hour) via templates in a **Backstage-class portal** (Backstage, Port, Cortex) backed by real automation — a portal over a ticket queue is lipstick. Measure the platform like a product: **adoption rate** of golden paths (voluntary adoption is the honest signal — commonly aim for >~70% of new services on-path within a year), time-to-first-deploy, ticket volume to the platform team (should trend to zero for paved operations), and internal NPS. Build the thinnest platform that removes the top friction — start with one golden path end-to-end, not a portal catalog of half-automated tiles. Rule: **pave a path only when ≥3 teams repeat the workflow, and measure success by voluntary adoption — a mandated path with captive users tells you nothing.**

BAD: "Stand up Backstage, import all 200 services into the catalog, mandate its use, declare the platform launched" (a read-only catalog over ticket-driven ops changes nothing; mandated adoption hides that nobody would choose it). GOOD: "One template: new Go service with CI, deploy, dashboards, on-call wiring — self-service in 30 minutes; track voluntary adoption and time-to-first-deploy before adding path #2."

```
PLATFORM SCOPE
══════════════
Golden path #1: [workflow · teams currently hand-rolling it (≥3)]
Self-service:   [template/API · zero tickets · time-to-first-deploy target <1 day]
Escape hatch:   [off-path allowed · team owns resulting ops burden]
Portal:         [Backstage/Port/Cortex or none yet · what it actually automates]
Metrics:        [voluntary adoption % · TTFD · platform ticket volume · internal NPS]
Next path gate: [adoption >~70% on path #1 before building #2]
```

Skip when: fewer than ~10 engineers or ~5 services — a well-documented template repo beats a platform team; the platform tax exceeds the friction it removes.

Gotchas: building the portal before the automation gives you a beautiful ticket-submission UI. Mandates create captive metrics — you learn the platform is bad only when your best engineers tunnel around it. Golden paths without an escape hatch get vetoed by exactly the senior teams whose adoption legitimizes the platform. Platform teams that never talk to their users ship features while the top friction (usually environments or data access) stays unpaved.
