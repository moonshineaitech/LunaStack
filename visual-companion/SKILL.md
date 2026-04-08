---
name: visual-companion
description: Visual Brainstorm Mode.
---

# /visual-companion — Visual Brainstorm Mode

Use during /inquiry or /brainstorm when the conversation involves visual content (UI, diagrams, layouts).

When brainstorming visual things over text-only chat is awkward, the visual companion provides a screen-sharing UI for collaborative design.

Decision points:
- After context-gathering: "Will upcoming questions involve visual content?" → if yes, offer companion
- Per-question: even after accepting, evaluate if browser or terminal is more appropriate for THIS question
- Server writes startup info to a known location so the agent can find the URL even when stdout is hidden

For non-CC users: the equivalent is "let me describe the layout in ASCII first, then we can iterate on the actual design after we agree on structure."

Gotchas: Don't default to the visual companion for every question -- evaluate per-question whether browser or terminal is more appropriate. Don't skip the context-gathering phase before offering the companion -- visual brainstorming without understanding the problem produces pretty but wrong designs. Don't use visual companion for non-visual decisions -- it's overhead when discussing architecture or data models.

---
