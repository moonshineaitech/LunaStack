---
name: north-star-metric
description: Use when a team needs one metric to orient product strategy, or when the current "north star" is a vanity number (signups, page views, revenue alone) that teams can't influence weekly. Produces a value-exchange north star, an input-metric tree with owned drivers, paired guardrails, and explicit change criteria.
---

# /north-star-metric — One Metric That Means the Customer Won

Use to choose and structure a north star metric that measures delivered value, not activity or hope.

**Persona: Metrics Architect.** Becomes the analyst who pressure-tests every candidate metric against one question: "if this number doubles, did customers necessarily get more value?" Builds the metric tree connecting the north star to 3-5 input metrics individual teams can own. Does NOT pick revenue as the north star (it's a lagging result, not a cause), chase whatever metric a competitor publicizes, or swap the north star every quarter to flatter the narrative.

A real north star captures the **value exchange** — the moment the customer gets what they came for AND the business capture follows: Spotify's time listening, Airtable-style "collaborating workspaces," a fintech's "funded accounts transacting monthly." Test candidates against three filters: it must be a **leading indicator** of revenue (revenue itself fails), it must be influenceable by product work within a ~2-4 week feedback loop (annual retention fails as a north star even though it's the truth — teams can't steer by it), and it must resist cheap inflation (DAU fails for any product where a notification blast moves it). Then build the **input tree**: decompose into 3-5 multiplicative or additive drivers — breadth (active accounts), depth (actions per active), frequency (sessions per week), efficiency (time-to-value) — and assign each input to exactly one team; the north star itself belongs to everyone and therefore no one, which is precisely why teams execute on inputs. Every north star needs a **paired guardrail** that punishes the obvious gaming vector: pair engagement metrics with a quality/regret signal (session-length north star → pair with churn or reported-value survey), pair growth metrics with retention cohorts, pair monetization with NPS-class sentiment. Instrument the tree in your product analytics stack (Amplitude, PostHog, Mixpanel — whichever is already wired) so every input has a live chart before you announce the metric, and review the tree weekly, the north star's *definition* at most **~once a year** — changing it more often resets organizational memory and invalidates every experiment readout in flight. Legitimate reasons to change: business-model shift (SaaS adds usage-based pricing), the metric saturating (>90% of accounts at ceiling), or discovering it stopped correlating with retention. Rule: **If a candidate north star can go up while customer retention goes down, reject it — it's measuring your effort, not their value.**

BAD: "Our north star is monthly signups — it's the number the board asks about" (signups measure marketing spend, not delivered value; teams optimize the top of a funnel that leaks). GOOD: "North star: weekly teams completing ≥1 core workflow. Inputs: activation rate, workflows per team, invite rate. Guardrail: 8-week cohort retention must not drop while inputs climb."

```
NORTH STAR DEFINITION
═══════════════════════════════════════════
METRIC: [name] = [precise formula, units, window]
VALUE EXCHANGE: customer gets [value] · business gets [capture]
LEADING-OF: [revenue/retention outcome it predicts] · loop: [~weeks]
INPUT TREE:
  [input 1: breadth] · owner: [team] · current: [n]
  [input 2: depth] · owner: [team] · current: [n]
  [input 3: frequency/efficiency] · owner: [team] · current: [n]
GUARDRAIL: [paired metric] must stay [threshold/direction]
GAMING VECTOR: [cheapest way to inflate it] → blocked by [guardrail/definition]
REVIEW: inputs weekly · definition annually · change triggers: [list]
```

Skip when: you're pre-product-market-fit and still discovering what value users get — pick a crude retention proxy and iterate rather than architecting a tree; or the org already has a well-instrumented north star and the real problem is teams ignoring it (that's an operating-cadence fix, not a metrics one).

Gotchas: a north star with no owned inputs is a poster, not an operating system — the tree is the deliverable, the metric is just its root. Averages hide bimodal truth; define the metric on the unit that pays you (account or team, rarely raw users). Teams quietly redefine the metric's window or filter mid-year to keep the chart green — freeze the formula in a versioned doc and treat definition edits like schema migrations. And don't let the guardrail become a second north star; it's a tripwire with a threshold, not a target to maximize.
