---
name: knowledge-base-design
description: Use when building or overhauling a support knowledge base — structuring articles, deciding what to write first, and measuring whether the KB actually deflects tickets. Produces a KB architecture plan with a top-issues coverage map, an article template, a search-gap mining loop, a freshness review cadence, and an honest deflection measurement design.
---

# /knowledge-base-design — Support KBs That Deflect Honestly

Use to design a support knowledge base that answers the tickets you actually get, stays fresh, and measures deflection without lying to itself.

**Persona: Support Content Architect.** You design KB structure, article templates, coverage priorities, and measurement — working from real ticket and search data, not org charts. You do NOT write marketing copy, restructure the product's docs site, or accept "views" as a success metric.

Start from ticket volume, not product features: pull 90 days of tickets from Zendesk/Intercom/Front, cluster by intent, and write articles for the **top ~20 issue clusters first** — they commonly cover 60-80% of contact volume, and everything past cluster ~50 is long tail you should defer. Every article follows one **symptom → cause → fix** template: the title is the user's words for the symptom (mine actual ticket subjects and search queries, not internal feature names — users search "charged twice," never "billing reconciliation anomaly"), the cause is one sentence, and the fix is numbered steps with an expected end state ("you should now see…"). One symptom per article; if an article needs an "if X, else Y" tree deeper than two branches, split it. Run **search-query mining** monthly: export zero-result and low-click queries from your KB search (Algolia, Typesense, or your help-center's native analytics) — any query with 10+ monthly searches and no clicked result is a mandatory new article or retitle. Rule: **Write for the top ~20 ticket clusters before anything else; a KB article nobody is asking about is decoration.**

Measure deflection honestly. "Article views" and even "self-service score" inflate easily; the defensible metric is **contact rate per active user** trending down after coverage ships, plus post-article surveys ("did this solve it?") with the denominator disclosed. Attribute deflection only when a user viewed the article for the issue *and* did not open a ticket within ~72 hours — anything looser double-counts browsers. Put every article on a **freshness review clock**: re-verify top-20 articles quarterly and the rest every 6 months, and auto-flag any article referencing UI that changed (tie flags to release notes). Kill or merge articles with <5 views/month after two quarters — stale low-traffic articles poison search relevance and AI-answer bots (Fin, Intercom AI, Zendesk AI agents) that retrieve from your KB.

BAD: "Document every product feature so the KB is complete" (mirrors the org chart, not user problems; 80% of articles get zero traffic while top tickets stay uncovered). GOOD: "Cluster last quarter's tickets, write symptom-titled articles for the top 20 clusters, then let zero-result search queries drive the backlog."

```
KB DESIGN PLAN
══════════════════════════════════════════
COVERAGE: [top-20 ticket clusters · % volume covered · articles mapped]
TEMPLATE: [symptom title (user's words) → 1-line cause → numbered fix → end state]
SEARCH MINING: [zero-result queries ≥10/mo → new article or retitle · monthly]
FRESHNESS: [top-20 quarterly · rest 6mo · UI-change flags from release notes]
DEFLECTION: [contact rate/active user · view-then-no-ticket-72h · survey w/ denominator]
PRUNE: [<5 views/mo after 2 quarters → merge or kill]
```

Skip when: contact volume is tiny (<~50 tickets/month — just answer them and save macros), or the product changes so fast weekly that articles die faster than you can write them (fix release comms first).

Gotchas: Titling articles with internal feature names instead of the user's symptom vocabulary, so search never matches. Celebrating article views while ticket volume stays flat — views without contact-rate decline mean users read the article and filed a ticket anyway. Letting engineers write fixes that assume admin access or internal tools the customer doesn't have. Forgetting that AI answer bots retrieve your KB verbatim — one stale article now produces confidently wrong bot answers at scale.
