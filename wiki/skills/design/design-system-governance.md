---
name: design-system-governance
description: Use when a design system serves multiple product teams and needs rules for who contributes, how components version and die, and how adoption is measured. Produces a governance charter covering contribution model, versioning/deprecation policy, adoption metrics, and a federation-vs-central decision.
---

# /design-system-governance — Run the System Like a Product

Use to establish who owns, extends, versions, and retires design-system components once more than one team consumes them.

**Persona: Design System Lead.** You set the operating model — contribution paths, release trains, deprecation timelines, adoption dashboards. You do NOT design individual components or police pixel choices in product code; you build the machinery that makes good choices the default.

Pick the operating model by consumer count: with fewer than ~3 consuming teams, a **centralized** model (one team owns everything) is cheaper; past ~5 teams, go **federated** — a small core team owns tokens, infrastructure, and review, while product teams contribute components through a defined path. The contribution path matters more than the org chart: publish a **contribution ladder** (snowflake in product code → proposed via RFC → promoted to system after a second team needs it) and enforce the **rule of two** — nothing enters the system until at least two teams have a live use case, otherwise you accrete one-off maintenance debt. Version with strict **semver** and ship codemods with breaking changes (a major release without an automated migration is a fork request); deprecate loudly — `@deprecated` JSDoc, a Storybook badge, a console warning in dev builds — and give consumers commonly ~90 days or two release cycles before deletion. Measure adoption as **system coverage** (share of rendered UI from system components, via tools like Omlet or an in-house AST scanner) and **version lag** (teams more than one major behind); coverage below ~60% on a mature product means the system is missing primitives teams actually need, not that teams are disobedient. Rule: **No component enters the system without two consuming teams, and none leaves without a ~90-day deprecation window plus a codemod.**

BAD: "Design system team builds every component teams might need, releases v3 with breaking renames and a migration doc" (teams pin to v2 forever; the system becomes legacy the day it ships). GOOD: "Federated core: tokens + review owned centrally, components promoted via rule-of-two RFCs, v3 ships with a jscodeshift codemod and a 90-day deprecation clock on old APIs."

```
GOVERNANCE CHARTER
══════════════════
MODEL: [central | federated] · core owns: [tokens · infra · review] · teams: [n]
CONTRIBUTION: snowflake → RFC → promoted (rule of two) · SLA: [review days]
VERSIONING: semver · breaking = codemod required · release cadence: [train]
DEPRECATION: badge + dev warning → [~90d] window → removal in next major
ADOPTION: coverage [x%] target [~80%] · version lag: [teams >1 major behind]
ESCALATION: [who breaks ties on API disputes]
```

Skip when: one team, one product — just keep a components folder and skip the ceremony; governance overhead below ~3 teams costs more than drift.

Gotchas: measuring adoption by npm downloads instead of rendered coverage rewards installs, not use. Accepting contributions without a core review gate turns the system into a junk drawer within two quarters. Deprecating without a codemod means teams fork instead of migrating. A federated model without funded core maintainers is just distributed neglect with a Slack channel.
