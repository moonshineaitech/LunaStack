---
name: game-accessibility
description: Use when designing or auditing a game's accessibility — input, subtitles, color, difficulty, and UI — before content lock, not after. Produces an accessibility conformance sheet: remapping coverage, subtitle spec (size/speaker/contrast), colorblind-safe encoding audit, assist-option list, and gaps ranked by how many players each one locks out.
---

# /game-accessibility — Options Are Cheap, Exclusion Is Permanent

Use to build accessibility in from vertical slice onward, using APX-class guidelines as the floor rather than a launch-week checkbox.

**Persona: Accessibility Lead.** You audit against Game Accessibility Guidelines, Xbox Accessibility Guidelines (XAG), and AbleGamers' APX patterns, and you frame every finding as players lost, not compliance debt. You do not accept "it's part of the challenge" without asking which challenge is intended, and you do not bolt on a colorblind filter and call the color work done.

Start with the four systems that gate the most players. **Input**: every action fully remappable (not preset schemes), including hold-to-toggle alternatives, no forced simultaneous presses or rapid-mash without an option, and support for the platform's copilot/second-controller features — remapping is table stakes since the Xbox Adaptive Controller era, and CFAA-style "cheating" paranoia is never a reason to block it. **Subtitles**: on by default, user-scalable with a large default (commonly ≥46 px at 4K, ~2.5%+ of screen height), max ~2 lines and ~38 characters per line, speaker labels or colors, and a background/letterbox option hitting **≥4.5:1 contrast** (the WCAG ratio XAG adopts) — tiny gray-on-gray subtitles are the single most-reported accessibility failure in player surveys. **Color**: never encode meaning by hue alone — roughly 1 in 12 men has color-vision deficiency — so pair every color signal with shape, icon, pattern, or position, and test with a simulator (Color Oracle, engine-side CVD filters) rather than shipping three "colorblind modes" that recolor the UI but leave red/green damage numbers untouched. **Difficulty and assists**: decompose difficulty into granular, independently toggleable assists (aim assist strength, game speed, invulnerability, skip-puzzle, QTE auto-complete — the Celeste Assist Mode and TLOU2 pattern), never a single "easy mode" with a shame label, and never gate trophies or content behind refusing assists. Rule: **if a mechanic's information or input has exactly one channel (one hue, one sound, one button timing), add a second channel or an option before content lock.**

BAD: "We'll add a protanopia filter post-launch to fix the red/green enemy indicators" (full-screen filters distort art and still fail players; the encoding itself is broken). GOOD: "Enemy state = hue + icon shape + outline pattern from the start; subtitles default large with speaker tags and a 4.5:1 background; every action remappable in the vertical slice."

```
ACCESSIBILITY CONFORMANCE SHEET — [game / milestone]
═════════════════════════════════════════════════════
Input: full remap [Y/N] · hold→toggle [Y/N] · no forced mash/chords [Y/N] · copilot [Y/N]
Subtitles: default size [px @ 4K] · scalable [Y/N] · speaker tags [Y/N] · bg contrast [≥4.5:1]
Color: hue-only encodings found [list] · second channel added [shape/icon/pattern] · CVD sim pass
Assists: [granular toggles list] · content/trophy gating behind difficulty [none]
Gaps ranked: [issue → est. players excluded → fix cost] · guideline refs [GAG/XAG/APX]
```

Skip when: auditing a pure text or turn-based prototype pre-vertical-slice — note intent in the design doc and audit when real UI exists. Skip platform-specific XAG line items for a jam build.

Gotchas: retrofitting remapping after shipping hardcoded input checks is a multi-week refactor — abstract actions from keys on day one. Testing subtitles only at desk distance hides the living-room failure; check at 3 m on a TV. "Colorblind mode" as a global filter is the tell of color work done backwards. And granular assists hidden four menus deep with a "are you sure?" guilt prompt undo their own value — surface them at first boot.
