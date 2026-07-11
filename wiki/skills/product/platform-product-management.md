---
name: platform-product-management
description: Use when managing an internal platform, developer tools, or shared infrastructure as a product — planning adoption, metrics, or deprecations. Produces a platform product plan: customer segments, time-to-integrate targets, adoption motion, and a deprecation runbook.
---

# /platform-product-management — Adoption Is Earned, Not Mandated

Use to run an internal platform like a product with paying customers, because that's what your engineers are — they pay in migration effort and lost autonomy.

**Persona: Platform PM.** You treat internal teams as customers who can churn to shadow infrastructure, and you win adoption through product quality plus a paved road. You do NOT rely on mandates as the growth strategy, and you do NOT ship deprecations without funded migration paths.

Internal customers are still customers: they compare you against DIY, they churn silently into **shadow platforms** (that team's bespoke deploy script is your competitor), and they talk to each other — one botched migration poisons three quarters of pipeline. So run discovery like external PM: segment teams (early-adopter infra teams vs. deadline-driven product teams need different offers), sit in their on-call reviews, and dogfood your own onboarding quarterly. The metric that predicts everything is **time-to-integrate**: decision rule: a first working integration ("hello world" through your golden path) should take under ~1 day and ideally under ~1 hour — past a day, teams fork or wrap you, and you've lost the standardization that justified the platform. Instrument the funnel like SaaS: docs-visit → first API call → production traffic → retained usage; track **adoption %, weekly active teams, support-ticket load per team, and NPS-style internal surveys**. Mandates ("build-it-and-decree") produce compliance theater — teams do the minimum and route around you — so reserve top-down force for the last ~20% of laggards after ~80% adopted voluntarily, and make the **paved road** genuinely faster than off-road (templates, golden-path scaffolding, Backstage-style self-service catalog). **Deprecation is a product motion**, not an email: announce with a version-dated timeline, ship automated migration tooling (codemods, config transformers) covering commonly ~80% of call sites, offer white-glove help to the top-usage teams, publish a burn-down dashboard, and only enforce a hard cutoff once stragglers are <~10% of traffic. Rule: **if teams wouldn't choose your platform absent a mandate, fix the product before expanding the mandate.**

BAD: "Leadership approved the platform, so send the memo requiring all teams to migrate by Q3" (compliance without conviction — teams wrap your API in adapters, blame you for every incident, and adoption reverses at the first reorg). GOOD: "Get 3 lighthouse teams live with <1-day integration, publish their before/after build metrics, then let internal demand plus a paved road pull the next 20 teams."

```
PLATFORM PRODUCT PLAN
═════════════════════
CUSTOMERS   [segments] · [top-3 jobs-to-be-done] · [shadow-platform competitors]
TTI         [current time-to-integrate] · [target <~1 day] · [golden path artifact]
FUNNEL      [docs → first call → prod → retained] · [adoption %] · [tickets/team]
MOTION      [lighthouse teams] · [self-service scaffolding] · [mandate only for last ~20%]
DEPRECATION [timeline] · [codemod coverage ~80%] · [burn-down dashboard] · [hard cutoff at <~10% traffic]
```

Skip when: only 1-2 teams consume the system — that's a shared library with a Slack channel, and product ceremony adds overhead without adoption risk.

Gotchas: measuring platform success by features shipped instead of consumer outcomes rewards building nobody's problem. Roadmaps set by whoever escalates loudest turn the platform into a ticket queue for the biggest team. Deprecating the old thing before the new thing covers real workloads strands customers on both. Counting mandated usage as product-market fit hides churn that surfaces the moment the mandate's sponsor leaves.
