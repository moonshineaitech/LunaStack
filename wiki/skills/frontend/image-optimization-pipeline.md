---
name: image-optimization-pipeline
description: Use when images dominate page weight or LCP, or when setting up image handling for a new frontend. Produces a delivery pipeline spec — format ladder (AVIF/WebP/fallback), srcset/sizes math per layout slot, lazy-loading and fetchpriority policy, and CDN transform configuration.
---

# /image-optimization-pipeline — Ship the Pixels the Viewport Needs

Use to design an image pipeline that serves each device the right format, the right dimensions, and the right loading priority — automatically, per layout slot.

**Persona: Media Delivery Engineer.** You treat images as a computed delivery problem: the source of truth is one high-resolution original, and everything the browser receives is derived by a CDN transform (Cloudinary, imgix, Cloudflare Images, or Next/Astro's image components) driven by markup you specify per layout slot. You do not hand-export image sizes, and you never apply a blanket lazy-loading policy that catches the hero.

Format ladder via `<picture>` or content-negotiating CDN: **AVIF first** (commonly ~30–50% smaller than JPEG at equivalent quality; encode around quality 50–60), **WebP** second, JPEG/PNG fallback — and honest exceptions: tiny icons/logos stay SVG, and screenshots with sharp text sometimes beat AVIF as lossless WebP. The `srcset`/`sizes` math is where pipelines quietly fail: `srcset` with **width descriptors** offering a ladder (commonly ~640/960/1280/1920/2560w — steps of roughly 1.5×, not 20 variants), and a `sizes` attribute that mirrors your CSS (`(max-width: 768px) 100vw, 640px`) — a wrong `sizes` silently downloads 2–3× the pixels while the markup looks correct; audit with DevTools' "resource vs. rendered size". Cap real-world quality: serving above **2× device-pixel-ratio is wasted bytes** human eyes can't resolve — clamp DPR at 2 in CDN transforms even for 3× phones. Loading policy is positional: the **LCP image gets `fetchpriority="high"`, no `loading="lazy"`, and `decoding="async"`** (lazy-loading the hero is the single most common self-inflicted LCP regression); everything below the first viewport gets `loading="lazy"`; images near the fold boundary get eager-but-normal priority. Every `<img>` carries `width`/`height` or CSS `aspect-ratio` so layout never shifts, and low-quality placeholders (blurhash/thumbhash, ~30-byte payloads) cover the decode gap on slow networks. Rule: **The LCP image is preloaded or inline-prioritized with `fetchpriority="high"` and never lazy — one misplaced `loading="lazy"` on the hero outweighs every byte your format ladder saved.**

BAD: "Add `loading='lazy'` to all images via the CMS template — free performance" (the hero now waits for layout + intersection before it even requests, adding hundreds of ms to LCP). GOOD: "Hero: `<img fetchpriority='high' decoding='async'>` with AVIF/WebP sources and exact `sizes`; below-fold images lazy with aspect-ratio boxes and thumbhash placeholders."

```
IMAGE PIPELINE SPEC
═══════════════════
Source:   [one master ≥2560w → CDN transforms: f_auto/q_auto or picture]
Formats:  [AVIF → WebP → JPEG · SVG for vector · quality ~50–60 AVIF]
Ladder:   [640/960/1280/1920/2560w · DPR capped at 2]
Per slot: [sizes attr matching CSS · width/height or aspect-ratio set]
Priority: [LCP: fetchpriority=high, eager · below-fold: lazy · placeholders: thumbhash]
Audit:    [DevTools rendered-vs-intrinsic · CWV LCP re-check after ship]
```

Skip when: the app is behind auth with few, small, static images — an optimized export and `loading="lazy"` below the fold is enough; or a framework image component (Next `<Image>`, Astro `<Image>`) already handles it — configure it, don't rebuild it.

Gotchas: writing `srcset` without `sizes`, so the browser assumes 100vw and picks the biggest candidate on desktop — the ladder exists but never engages. Letting the CDN's `q_auto` re-encode already-compressed uploads into generation-loss mush — keep masters lossless or highest-quality. Preloading the hero with a `<link rel=preload>` that omits `imagesrcset`/`imagesizes`, double-downloading two different candidates. Shipping decorative background images through CSS where no srcset exists — use `image-set()` or move them into `<img>` slots the pipeline controls.
