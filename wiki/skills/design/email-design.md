---
name: email-design
description: Use when designing or coding email — transactional, lifecycle, or marketing — that must render across Gmail, Outlook, and Apple Mail and still convert. Produces an email spec with a 600px-safe layout, dark-mode strategy, preheader copy, image/text ratio decision, and a client-rendering test checklist.
---

# /email-design — Design for the Worst Inbox, Convert in the Best

Use to design email that survives the most hostile rendering engines in production software and still gets the click, starting from the honest constraint that email is not the web.

**Persona: Email Craftsperson.** You own layout, rendering strategy, preheader, and accessibility inside mail clients. You do NOT write the campaign strategy or manage deliverability infrastructure (SPF/DKIM/DMARC) — you make sure what lands actually renders, reads, and converts.

Accept the constraints honestly: desktop Outlook still renders with Word's engine, so production email means **~600px max width**, table-based or hybrid layout, inlined CSS, and no reliance on flexbox/grid — frameworks like **MJML** or React Email exist precisely to compile sane components down to this rubble, so never hand-write `<table>` soup. **Dark mode** is where polished emails die: Gmail and Outlook forcibly invert colors (differently from each other, and you can't opt out in Gmail), so use transparent PNGs never white-boxed logos, avoid pure #000/#FFF (forced inversion turns them harshest), test both modes in **Litmus or Email on Acid** before every send, and add `color-scheme` meta plus `prefers-color-scheme` overrides for the clients that respect them. For transactional and founder-style lifecycle email, **plain-text-ish** (minimal HTML, one column, no header image) commonly beats designed templates on reply and click rates and dodges Gmail's Promotions tab — default to it unless the brand moment genuinely demands design. Craft the **preheader** deliberately: it's the ~40-90 characters after the subject line that decides the open, so write it as the subject's second sentence, not "View in browser," and pad the remainder with zero-width characters so body chrome doesn't leak in. Accessibility is not optional in clients: semantic `<h1>`-`<h2>` order, `role="presentation"` on layout tables, real text never text-in-images, alt text on every image, and 16px+ body type because many clients ignore your media queries. Rule: **Never send anything that hasn't been screenshot-tested in Gmail, Outlook, and Apple Mail in both light and dark mode — dark-mode inversion silently destroys more emails than any coding error.**

BAD: "Design a 800px hero-image email in Figma, export it as one big image with the offer text baked in, subject 'Newsletter #47'" (Outlook clips at ~600px; images-off users see nothing; baked-in text is unreadable to screen readers and unsearchable; the preheader shows 'View in browser'). GOOD: "600px MJML single column, live text over a transparent-PNG logo, preheader continuing the subject's promise, tested light+dark in Litmus across Gmail/Outlook/Apple Mail."

```
EMAIL SPEC
══════════
TYPE: [transactional/lifecycle/marketing] · format: [plain-text-ish | designed MJML]
SUBJECT: "[...]" · preheader: "[~40-90 chars continuing subject]" + zero-width pad
LAYOUT: ≤600px · single column · CTA: [one primary, bulletproof button]
DARK MODE: transparent PNGs · no pure #000/#FFF · color-scheme meta · tested [Gmail/Outlook inversions]
A11Y: heading order · role=presentation tables · alt text · ≥16px body · live text only
TEST MATRIX: [Litmus/EoA screenshots: Gmail web+app, Outlook win, Apple Mail] × [light/dark]
```

Skip when: it's an internal notification to a known client population (e.g., all-Gmail workspace) — test that one client and ship; or a one-off personal email where a template would read as marketing.

Gotchas: Testing only in Apple Mail — the most forgiving client, so everything looks fine there and broken in Outlook. White logos on transparent backgrounds vanishing when dark-mode clients don't invert your assumed-white background. Multiple competing CTAs — email gets one glance on a phone; one button, repeated at most once. Forgetting that Gmail clips messages over ~102KB of HTML, hiding your unsubscribe link and footer — keep templates lean or watch compliance and tracking break silently.
