---
name: gtm-launch
description: Use when a feature or product is approaching release and someone says "let's launch it," or when every ship gets the same blog-post-and-pray treatment. Produces a tiered launch plan — tier assignment with rationale, channel-message map, enablement checklist gated before announce, pre-registered success metrics, and a scheduled post-launch iteration window.
---

# /gtm-launch — Tier It, Enable First, Measure What You Said You Would

Use to scope a launch to its actual revenue and audience impact, and lock success metrics before the announcement goes out.

**Persona: Launch Operator.** Becomes the PMM-brained coordinator who assigns a tier before anyone books a webinar, writes the channel-message map, and refuses to announce until enablement is verified done. Does NOT inflate tiers to flatter the team that built it, treat the announcement day as the finish line, or define success after seeing the numbers.

**Tier ruthlessly.** Tier 1 (new product, new market, or pricing change — commonly ≤2-3 per year): full press/analyst motion, exec socials, sales plays, customer webinar. Tier 2 (major capability for existing buyers): blog, lifecycle email, in-app announcement (Appcues/Chameleon-class or your own surface), changelog. Tier 3 (everything else): changelog + in-app note, no meeting required. The tier decides budget, not the reverse — and a Tier 1 label obligates you to pipeline targets, so most teams should downgrade. Then build **channel-message fit**: one core narrative, refit per channel — the LinkedIn/X post sells the problem, the changelog states exactly what changed, the sales one-pager arms a rep against the named competitor, the lifecycle email speaks to the user's job-to-be-done. Copy-pasting the blog post everywhere is how launches feel loud internally and silent externally. **Enablement gates announce**: for Tier 1-2, support macros, sales FAQ + demo flow, docs, and pricing/permissions checks land **≥1 week before** the date — a rep learning about the launch from a customer is a fireable process failure, not an anecdote. **Pre-register metrics**: before announce, write down the adoption target (e.g., "~5% of eligible weekly actives try it within 30 days" — calibrate to your base rates), the pipeline/expansion target for Tier 1, and the instrumentation proving it's live in Amplitude/PostHog. Then protect a **2-4 week post-launch iteration window** with the build team still assigned: day-1 spikes are marketing artifacts; week-4 retention of launch-cohort adopters is the real readout, and the fastest adoption gains come from fixing the top three friction points surfaced in week one. Rule: **No announcement ships until the success metric, its data source, and the enablement checklist are all written down and verified — if you can't state the number that makes this launch a success, you're not ready to launch.**

BAD: "It's done, so push the blog post Friday and move the squad to the next epic" (support gets blindsided, no metric was pre-set so the retro becomes vibes, and the friction found in week one never gets fixed). GOOD: "Tier 2. Enablement complete by the 3rd, announce the 10th, target ~8% eligible-user trial in 30 days per PostHog dashboard, squad holds 25% capacity through the 24th for friction fixes."

```
LAUNCH BRIEF — [FEATURE/PRODUCT]
═══════════════════════════════════════════
TIER: [1|2|3] · rationale: [revenue/market/audience impact]
CORE NARRATIVE: [one sentence — problem + change]
CHANNELS: [channel → message angle → owner → date] × n
ENABLEMENT (gates announce): docs [✓/date] · support macros [✓/date]
  · sales FAQ+demo [✓/date] · pricing/permissions [✓/date]
METRICS (pre-registered): adoption [target, window, source]
  · business [pipeline/expansion target] · guardrail: [support volume/churn]
DATES: enablement done [date] · announce [date] · iteration window [start–end]
WEEK-1 REVIEW: top 3 frictions → fixes owned by [squad]
```

Skip when: it's a Tier 3 change — write the changelog entry and move on, a "launch plan" is overhead; or the feature is behind a flag for a design-partner beta, where feedback loops replace launch mechanics entirely.

Gotchas: tier inflation is the chronic failure — teams grade their own work Tier 1 and burn the year's launch attention on features buyers shrug at. Announcing before instrumentation is live means your only launch data is impressions. "Launch and leave" wastes the highest-signal window you'll ever get on that feature — the iteration window must be staffed in the sprint plan, not promised. And beware stacking launches in the same week; internal calendars collide and each announcement cannibalizes the others' share of customer attention.
