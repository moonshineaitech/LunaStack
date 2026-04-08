---
name: seo
description: Technical SEO Audit.
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

Gotchas: Don't use client-side rendering for pages that need to be indexed -- search engines struggle with JavaScript-heavy pages. Don't use 302 redirects for permanently moved pages -- use 301 to preserve link equity. Don't skip Core Web Vitals on mobile -- Google ranks mobile-first and most traffic comes from phones.

---
