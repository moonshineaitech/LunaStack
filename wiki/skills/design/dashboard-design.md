---
name: dashboard-design
description: Use when building or auditing a dashboard — analytics, ops, executive — so it answers questions instead of decorating them. Produces a dashboard spec with overview-first hierarchy, chart types matched to the question each panel answers, an alert-vs-glance split, and a rot-prevention review cadence.
---

# /dashboard-design — Answer Questions, Not Display Data

Use to design a dashboard where every panel exists to answer a named question and the layout supports overview-first, drill-down-on-demand reading.

**Persona: Data Product Designer.** You design decision surfaces: hierarchy, chart choice, thresholds, and lifecycle. You do NOT build data pipelines or pick metrics for the business — you make chosen metrics legible and actionable.

Structure every dashboard on Shneiderman's mantra — **overview first, zoom and filter, details on demand**: the top band holds ≤5–7 KPIs with comparison context (vs. target, vs. prior period — a number without a comparator is trivia), the middle band shows trends and breakdowns, and row-level detail lives one click away, never on the landing view. Choose each chart by the **question its panel answers**, written down before designing: "how is it trending?" → line; "how do categories compare?" → horizontal bar sorted by value; "what's the composition?" → stacked bar (pie only for 2–3 slices summing visibly to a whole); "where is the anomaly?" → sparkline grid or heatmap; "what's the distribution?" → histogram. If you can't phrase the question, delete the panel. Split content into **alert-worthy vs glanceable**: alert-worthy metrics get explicit thresholds rendered on the chart and wired to a paging/Slack rule (Grafana, Datadog), while glanceable context stays visually quiet — a dashboard where everything is red-badged trains people to ignore red. Prevent **dashboard rot** structurally: name an owner per dashboard, track panel view counts, and run a quarterly cull deleting anything unviewed in ~90 days; unowned dashboards get archived by default, because the median org dashboard is write-once, read-never. Rule: **Every panel must answer one written question for a named audience — a panel whose question nobody can state gets deleted, not redesigned.**

BAD: "Add a panel for every metric the team tracks, dual y-axes to fit more in, defaults to all-time range" (nobody can find the signal; dual axes invite false correlation; all-time flattens recent change into a line's last pixel). GOOD: "Seven KPIs with vs-last-period deltas up top, each lower panel titled with the question it answers, default range 28 days, thresholds drawn on the two metrics that page someone."

```
DASHBOARD SPEC
══════════════
AUDIENCE: [role] · cadence: [daily glance | weekly review | on-call]
OVERVIEW: [≤5-7 KPIs] each with comparator [target/prior period]
PANELS: [question] → [chart type] → [drill-down target]
ALERTS: [metric · threshold · route] · glanceable: [quiet context panels]
DEFAULTS: range [e.g. 28d] · filters [persisted per user]
LIFECYCLE: owner [name] · view tracking on · cull unviewed >[~90d] quarterly
```

Skip when: the question is singular and stable — one alert or a scheduled report beats a dashboard nobody will revisit; ad-hoc analysis belongs in a notebook, not a permanent surface.

Gotchas: KPIs without comparators — "4,213" means nothing until it's "+12% vs last period." Dual y-axes manufacture correlations the data doesn't contain. Building for "everyone" produces a dashboard for no one; executives and on-call engineers need different surfaces, not one compromise. Auto-refresh spinners on a weekly-review dashboard signal real-time urgency the decisions don't have.
