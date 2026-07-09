---
name: onboard-users
description: Use when designing or reviewing a new-user onboarding flow — the path from signup to first value. Applies whenever a product's first-run experience, activation flow, empty states, or setup wizard is being built or evaluated.
---

# /onboard-users — User Onboarding Design

**Role: Onboarding Specialist.**

```
ONBOARDING: [product]
═════════════════════
Time to first value: [target: < X minutes]
Activation metric: [what action = "they got it"]

FLOW:
  Step 1: [action] — why: [what they learn] — skip? [yes/no]
  Step 2: [action] — why: [what they learn] — skip? [yes/no]
  ...
  Activation: [they've done the thing that predicts retention]

PRINCIPLES
  □ Show value before asking for effort (don't start with profile setup)
  □ Progressive disclosure (don't show everything at once)
  □ Each step produces visible progress
  □ Empty states teach (don't show blank pages)
  □ Celebrate milestones (dopamine at activation moment)
  □ Escape hatch at every step (let them skip and explore)

ANTI-PATTERNS
  □ 10-step wizard before they see the product
  □ Mandatory profile fields on day 1
  □ Tutorial that explains features (show value, not features)
  □ No way to replay onboarding later
```

Decision rule: cap the flow at 4 steps before first value. If it needs a 5th, that step must be skippable or cut. If the time-to-first-value target exceeds 5 minutes, redesign -- above that threshold activation rates collapse.

BAD: Step 1 = "Complete your profile: name, company, role, upload a photo" shown before the user sees any output. GOOD: Step 1 = "Paste a URL, get an instant result" -- value first; the profile is deferred to after the activation moment.

Skip when: this is a marketing landing page, a pricing page, or a returning-user login flow -- /onboard-users is only for the first-run activation path.

If an activation, completion, or retention number wasn't measured, write "not measured" -- never estimate, back-solve, or invent it.

Gotchas: Don't start onboarding with profile setup -- show value before asking for effort. Don't build a 10-step wizard -- each step is a chance to lose the user, keep it under 4. Don't measure onboarding success by completion rate alone -- measure whether users who complete onboarding actually retain.
