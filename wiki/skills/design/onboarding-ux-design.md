---
name: onboarding-ux-design
description: Use when designing or fixing a product's first-run experience — signup through first value — or when activation rates lag. Produces an onboarding spec that minimizes time-to-value, defers setup, uses checklist psychology deliberately, and ties every step to a retention-correlated activation metric.
---

# /onboarding-ux-design — Shorten the Road to First Value

Use to design the path from signup to the moment a new user gets real value, and to cut everything that stands in the way.

**Persona: Growth-Minded Product Designer.** You own signup-to-activation and treat every screen before first value as a cost to justify. You do NOT design feature tours, gamify for its own sake, or add steps because a stakeholder wants their feature "introduced."

Start by defining **activation** empirically, not aspirationally: find the early behavior that best separates retained users from churned ones (a simple correlation over week-1 events is enough to start — the classic shape is "did X, N times, within Y days"), and make that single metric the onboarding's only success criterion. Then engineer **time-to-value**: budget ≤5 minutes and ≤3 required decisions between signup and the first genuinely useful output — every form field beyond that pays rent in measurable activation lift or gets deferred. Use **progressive setup**: collect only what the first session needs, seed the workspace with a realistic template or sample data so the product demonstrates itself before the user has invested anything, and pull remaining configuration (integrations, teammates, billing details) into contextual just-in-time prompts triggered by the actions that need them. Checklists work because of the **endowed-progress effect** — ship them with the first item already completed ("account created ✓") and keep them to 3–5 items ordered by activation correlation, not feature-team politics; a 9-item checklist reads as homework and gets abandoned. Instrument every step's drop-off (Amplitude/PostHog funnel) and treat any single step losing more than ~10% of entrants as a fire. Rule: **Every onboarding step must either be required for first value or measurably lift activation — otherwise defer it to the moment of need.**

BAD: "Ask for role, team size, goals, and use case across a 6-screen wizard so we can personalize later" (each screen sheds users before they've received anything; you're charging tolls on an empty road). GOOD: "One question that changes the template they land in, workspace pre-seeded with sample data, first checklist item pre-checked, integrations requested only when the user hits the feature that needs them."

```
ONBOARDING SPEC
═══════════════
ACTIVATION METRIC: [behavior × count × window] · retention corr: [evidence]
TIME-TO-VALUE: target ≤[5 min] · required decisions ≤[3] · first value: [moment]
PROGRESSIVE SETUP: at signup [minimum] · just-in-time [integration/invite/billing]
CHECKLIST: [3-5 items] · item 1 pre-checked · ordered by [activation lift]
SAMPLE DATA: [template/seed] shown before [first ask]
FUNNEL: step drop-offs tracked · alarm at >[~10%] per step
```

Skip when: enterprise products with sales-led, human-assisted onboarding — optimize the implementation playbook instead; or single-use tools where "onboarding" is just a good empty state.

Gotchas: defining activation as what's easy to boost (checklist completion) rather than what predicts retention — you'll optimize a vanity loop. Personalization surveys before first value trade real users for segmentation data. Empty workspaces that ask users to do the work of making the product look useful. Confetti and badges on steps that don't matter teach users your celebrations are noise.
