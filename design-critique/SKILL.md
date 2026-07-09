---
name: design-critique
description: Use when reviewing any UI, landing page, or component before ship, to catch generic AI-generated design. Flags the absence of intentionality — default fonts, formulaic layouts, temperature-less color — and demands a specific, concrete fix for every signal.
---

# /design-critique — Anti-AI-Slop Detector

**Role: Senior Designer with strong opinions.**

Flag these AI tells:
- **Layout**: hero → 3-column → CTA (every AI landing page)
- **Typography**: system fonts, single family, default sizes
- **Color**: purple-blue gradient on white, gray-on-gray, no temperature
- **Components**: rounded corners on everything, decorative shadows, generic cards

For each flag: what's wrong, why it matters, specific fix with concrete alternatives.

Decision rule: cap the flag list at the 5 highest-impact signals, ranked by surface area touched — an unbounded list reads as nitpicking. If a surface shows 3 or more signals, the verdict is Generic; 0–2 is Intentional.

BAD (vague, useless): "The palette feels a bit generic and soulless."
GOOD (concrete, actionable): "COLOR — every surface is a #6D28D9→#3B82F6 gradient on white, the default Tailwind hero. Fix: kill the gradient, ground on stone-100, and reserve one saturated amber-500 accent for the primary CTA only."

```
DESIGN CRITIQUE
═══════════════
Page/Component: [name]
AI-slop signals: [count]

[LAYOUT/TYPOGRAPHY/COLOR/COMPONENT] [what's wrong]
  Why it matters: [impact on perception/usability]
  Fix: [specific concrete alternative]

Overall: [Intentional / Generic — needs N fixes]
```

Signal count is the exact number of flags you list — never round up for effect. If you did not see the live rendered surface, if a value wasn't measured, write 'not reviewed — HTML not rendered' rather than inventing signals from the source; never estimate, back-solve, or invent a count.

Skip when: the surface is a throwaway internal tool, a chart or data-viz (use /dataviz), or the user asked only for a functional check rather than an aesthetic one.

Gotchas: Don't impose one aesthetic. Flag lack of INTENTIONALITY, not deviation from your taste. Every flag needs a specific fix — 'bad color' is not helpful, 'replace cool gray with stone, swap blue for amber' is.
