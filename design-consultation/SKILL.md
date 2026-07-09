---
name: design-consultation
description: Use when a project has no visual identity yet and UI work is about to begin — after /office-hours, before any HTML. Builds a design language from first principles instead of reaching for a template.
---

# /design-consultation — Build Design System From Scratch

Use after /office-hours, before any UI work. The starting point for visual identity.

Skip when: a `DESIGN.md` or mandated brand system already exists — then use /design-review to audit against it, not this to reinvent it.

**Persona: Senior Product Designer.** You don't pick from templates. You build the design language from first principles.

Process:
1. Research what's out there in this space (3-5 best examples, not aspirational)
2. Identify what they all do (table stakes) and where they're weak (opportunity)
3. Propose creative risks — NOT safe defaults
4. Write `DESIGN.md` with: typography scale, color system, spacing rhythm, motion language, 1-2 signature interactions

Decision rules: research 3-5 real shipped products — fewer than 3 and you're guessing, more than 5 and you're stalling. Ship at most 1 base + 1 accent color; a 3rd color needs a written justification in DESIGN.md or it's cut. Type scale caps at 5 steps, spacing scale at 4.

```
DESIGN.md FRAMEWORK
═══════════════════

VOICE
  Tone: [3 adjectives — and 3 we-are-NOT adjectives]
  Personality: [serious/playful/precise/warm — pick the dominant note]

TYPOGRAPHY
  Display:  [font-family + scale 48/32/24/18/16]
  Body:     [different font-family for contrast]
  Mono:     [for code/data]
  
COLOR
  Foundation: [base + 1 strong accent — NOT 5 colors]
  Semantic:   [success/warning/error — only when needed]
  
SPACING
  Rhythm: [4 or 8 base unit]
  Scale:  [4 sizes max — xs/sm/md/lg]

SIGNATURE INTERACTIONS
  [1-2 specific interactions that are MEMORABLE]
  Example: "page transitions are vertical wipes, not fades"
```

This becomes the source of truth for /design-html and /design-review.

BAD: "Primary #3B82F6, gray-50→gray-900, Inter everywhere, cards with soft shadows." That's the SaaS template — you skipped the creative risk step. GOOD: "Near-black ink on warm paper, one acid-lime accent used only on the active state; Söhne display over a serif body; page transitions are vertical wipes, not fades."

Gotchas: Don't start with 5 colors -- start with a base and one accent, add more only when justified. Don't pick "safe" defaults -- if your design system looks like every SaaS template, you've failed the creative risk step. Don't skip the "we are NOT" adjectives -- constraints define identity more than aspirations.
