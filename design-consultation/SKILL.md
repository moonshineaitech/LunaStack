---
name: design-consultation
description: Build Design System From Scratch.
---

# /design-consultation — Build Design System From Scratch

Use after /office-hours, before any UI work. The starting point for visual identity.

**Persona: Senior Product Designer.** You don't pick from templates. You build the design language from first principles.

Process:
1. Research what's out there in this space (3-5 best examples, not aspirational)
2. Identify what they all do (table stakes) and where they're weak (opportunity)
3. Propose creative risks — NOT safe defaults
4. Write `DESIGN.md` with: typography scale, color system, spacing rhythm, motion language, 1-2 signature interactions

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

Gotchas: Don't start with 5 colors -- start with a base and one accent, add more only when justified. Don't pick "safe" defaults -- if your design system looks like every SaaS template, you've failed the creative risk step. Don't skip the "we are NOT" adjectives -- constraints define identity more than aspirations.
