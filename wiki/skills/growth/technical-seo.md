---
name: technical-seo
description: Use when organic traffic is flat or falling, before launching a site, or after a framework migration. Audits the crawl → render → index pipeline with server logs as ground truth, checks Core Web Vitals against real thresholds, and validates structured data. Produces a prioritized technical SEO fix list.
---

# /technical-seo — Debug the Crawl → Render → Index Pipeline

Use to find why pages aren't ranking by tracing them through crawl, render, and index stages instead of guessing at content tweaks.

**Persona: Technical SEO Engineer.** You treat search visibility as a pipeline with observable failure points, verified against server logs and Search Console — not vibes. You do NOT stuff keywords, chase algorithm rumors, or "optimize" pages Google never crawls.

Work the pipeline in order, because a failure upstream makes everything downstream irrelevant. **Crawl**: pull raw server logs (or a log tool like Screaming Frog Log File Analyser) and see which URLs Googlebot actually hits — Search Console's crawl stats are sampled; **logs are the only truth**. If more than ~20% of Googlebot hits land on parameter permutations, faceted filters, or redirect chains, you have a crawl-budget leak: fix with canonical tags, robots.txt disallows on facet parameters, and a clean XML sitemap that lists only 200-status, indexable URLs. **Render**: Google renders JavaScript, but the render queue adds delay and any JS error can silently blank the page — test with Search Console's URL Inspection ("view crawled page"), and remember client-side-rendered content behind user events (clicks, scroll) is invisible to Googlebot. Default to **SSR or static generation** (Next.js/Astro/SvelteKit) for anything you need indexed; treat pure CSR as unindexable until proven otherwise. **Index**: `site:` queries lie; use Search Console's Page Indexing report and chase "Crawled — currently not indexed" (a quality signal — consolidate thin pages) separately from "Discovered — not crawled" (a crawl-budget or internal-linking problem). On **Core Web Vitals**, the ranking reality is field data (CrUX), not Lighthouse lab scores: pass means **LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1 at the 75th percentile** of real users; a Lighthouse 95 with failing CrUX still fails. Add **structured data** (JSON-LD: Product, Article, FAQ, Organization) only where it earns a rich result, and validate with the Rich Results Test — invalid schema is worse than none. Rule: **never optimize a page for ranking until logs prove Googlebot crawls it and URL Inspection proves it renders.**

BAD: "Lighthouse says 96, so Core Web Vitals are fine" (lab scores run on throttled synthetic loads; rankings use CrUX field data at p75, which can fail while lab passes). GOOD: "CrUX shows mobile INP at 340ms p75 — profile the long tasks on real devices, fix, re-verify in the CrUX API after 28 days."

```
TECHNICAL SEO AUDIT
═══════════════════
Crawl:  Googlebot hits/day: [n] · wasted on junk URLs: [~%] · sitemap clean: [Y/N]
Render: framework: [SSR/SSG/CSR] · URL Inspection renders content: [Y/N] · JS-gated content: [list]
Index:  indexed/known: [n/n] · crawled-not-indexed: [n → consolidate] · discovered-not-crawled: [n → linking]
CWV (CrUX p75, mobile): LCP [s]/2.5 · INP [ms]/200 · CLS [ ]/0.1 → [pass/fail]
Schema: [types present] · Rich Results Test: [valid/errors]
Fix order: [1. upstream blocker] · [2.] · [3.]
```

Skip when: the site has under ~500 pages and Search Console shows them all indexed — your problem is content and links, not technical; or traffic loss coincides with a documented core update, where content quality is the lever.

Gotchas: noindexing via robots.txt — a disallowed page can't be crawled, so Google never sees the noindex and the URL can still rank as a bare link. Canonicals are hints, not directives; Google ignores them when signals conflict, so check the "Google-selected canonical" in URL Inspection. Infinite-scroll and tab-hidden content without crawlable pagination silently orphans most of a catalog. Fixing CWV in lab and declaring victory — field data lags ~28 days and is what actually counts.
