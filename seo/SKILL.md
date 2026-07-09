---
name: seo
description: Use when auditing a site or page for search-engine indexability and ranking — before a launch or redesign, or when investigating organic-traffic loss. Checks titles, canonicals, sitemaps, robots rules, Core Web Vitals, and structured data.
---

# /seo — Technical SEO Audit

**Role: Technical SEO Specialist.**

```
SEO AUDIT
═════════
CRITICAL
  □ Every page has unique <title> and <meta description>
  □ H1 on every page (one per page)
  □ Heading hierarchy (H1 → H2 → H3, no skipping)
  □ Canonical URLs set correctly
  □ XML sitemap exists and is submitted to Search Console
  □ robots.txt doesn't block important pages
  □ All pages return 200 (no broken links, 404s)
  □ HTTPS everywhere (no mixed content)
  □ Mobile-friendly (passes Google's mobile test)
  □ Page load < 3s on mobile (Core Web Vitals: LCP < 2.5s, CLS < 0.1, INP < 200ms)

CONTENT
  □ URLs are descriptive (/pricing not /page?id=42)
  □ Images have descriptive alt text
  □ Internal linking between related pages
  □ No duplicate content across pages
  □ Structured data (JSON-LD) for key page types

TECHNICAL
  □ Server-side rendering or pre-rendering for key pages
  □ Open Graph and Twitter Card meta tags
  □ 301 redirects for moved pages (not 302)
  □ Hreflang tags if multi-language
```

Decision rule: any single CRITICAL failure blocks launch -- fix every CRITICAL before touching CONTENT or TECHNICAL. Sample up to 20 URLs (one per page template), not the whole site; if more than 20% of sampled pages fail the same CRITICAL check, flag it as a site-wide defect, not a one-off. A `noindex` tag or a robots.txt `Disallow` on a page that is meant to rank is an automatic block, never a minor note.

BAD: every page ships `<title>Home</title>` and one shared meta description. GOOD: `<title>Pricing — LunaStack | Plans from $0/mo</title>` with a unique ~150-char description per page, matching that page's actual intent.

Report measured values only. For LCP, CLS, INP, and load time, cite a real Lighthouse / PageSpeed / CrUX number. If a value wasn't measured, write "not measured" -- never estimate, back-solve, or invent it.

Skip when: the surface is intentionally excluded from search -- internal admin, an authenticated app behind login, or a staging environment -- where indexing is the wrong goal.

Gotchas: Don't use client-side rendering for pages that need to be indexed -- search engines struggle with JavaScript-heavy pages. Don't use 302 redirects for permanently moved pages -- use 301 to preserve link equity. Don't skip Core Web Vitals on mobile -- Google ranks mobile-first and most traffic comes from phones.

---
