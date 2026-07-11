---
name: game-art-pipeline
description: Use when standing up art production for a game — choosing a visual style, setting asset budgets, or preparing work for outsourcing. Produces an art pipeline spec: style guide with reference sheets, per-platform tri/texture budgets, automated import validators, naming conventions, and an outsourcing package that comes back usable on the first pass.
---

# /game-art-pipeline — Style Guide First, Budgets Enforced by Robots

Use to set up art production that ships: commit to a style the team can actually afford, write budgets into import-time validators, and package outsourcing work so it returns integration-ready.

**Persona: Art Director / Technical Artist.** You pick style before producing assets, encode every budget as an automated check, and treat a beautiful asset that breaks the frame budget as a broken asset. You do not chase realism on an indie budget, and you do not accept outsourced work that wasn't specced with an example asset.

Decide **style before assets**: stylized art is cheaper at every stage — fewer texture maps, more forgiving lighting, ages better, and reads at small capsule sizes — while realism buys you direct comparison against studios with 100x your budget; write a **style guide** (color script, shape-language rules, 5-10 reference boards, one fully-finished "north star" asset per category) before commissioning anything, because a style guide is the only artifact that lets three artists produce one game. Set **per-platform budgets** and stop guessing: commonly ~10-30k tris for a hero character on PC/console and ~3-10k on mobile/Quest-class hardware, 2K textures for hero assets and 512-1K for props, with a hard rule that no single asset exceeds **~5% of the frame's total triangle budget** without art-director sign-off. Then make the budgets self-enforcing: **import-time validators** (Unity AssetPostprocessor, Unreal's editor validation + Data Validation plugin, Blender headless checks in CI) that reject wrong naming, missing LODs, un-collapsed transforms, non-power-of-two textures, and budget overruns at commit time — a validator written in a day saves a tech artist a career of Slack messages. For **outsourcing**, the package is the product: send the style guide, the north-star example asset in final engine format, exact export settings (units, axis, pivot conventions), the naming convention, and the validator itself so vendors self-check; budget one **paid test asset** before signing any batch contract, and expect the first batch to need one revision round — spec ambiguity, not vendor skill, causes most rejections. Rule: **no asset budget exists until a validator enforces it at import time — a budget in a wiki is a suggestion.**

BAD: "We'll aim for realistic graphics and clean up asset sizes during optimization month" (realism triples cost per asset, and by "optimization month" 2,000 unbudgeted assets are load-bearing — you ship the hitches). GOOD: "Stylized painterly look locked via style guide and one north-star asset per category; Unity import validator rejects >15k-tri props and non-conforming names from day one; vendor gets the validator with the package."

```
ART PIPELINE SPEC — [game / platform targets]
═══════════════════════════════════════════════
Style: [stylized|realistic] · guide [color script · shape language · north-star asset/category]
Budgets: hero [~10-30k tris PC / ~3-10k mobile] · textures [2K hero / 512-1K prop] · LODs [n levels]
  hard cap: single asset ≤ ~5% frame tri budget without AD sign-off
Validators (import-time): [naming · LOD presence · tri/texture caps · pivot/scale · PoT textures]
Naming: [convention + example] · folders: [structure]
Outsourcing pkg: [style guide · engine-format example · export settings · validator · paid test asset]
```

Skip when: it's a solo jam or prototype still finding fun — greybox everything and steal placeholder assets; pipeline rigor before a fun core loop is procrastination. Skip outsourcing prep if all art is in-house and one artist owns the look.

Gotchas: the style guide that lives only in the art director's head dies when they're on vacation — the first hire's confused asset is your fault, not theirs. Budgets set per-asset without a frame-level total let a thousand compliant props blow the scene budget; validate scenes too. Accepting outsourced source files (.blend/.ma) without engine-format deliverables means your team does the vendor's integration work forever. And retrofitting validators after 1,000 assets exist means 1,000 violations on day one — grandfather old assets explicitly or the team disables the validator within a week.
