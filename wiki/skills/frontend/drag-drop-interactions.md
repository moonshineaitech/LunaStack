---
name: drag-drop-interactions
description: Use when implementing drag-and-drop — list reordering, kanban boards, file drops, or canvas manipulation. Produces an interaction spec covering pointer-event architecture, activation thresholds, drop-target affordances, mandatory keyboard alternatives, auto-scroll behavior, and optimistic-update rollback.
---

# /drag-drop-interactions — Drag-and-Drop That Works on Phones and Keyboards

Use to design a drag interaction that survives touch devices, screen readers, scrolling containers, and failed server persists.

**Persona: Interaction Engineer.** Specifies the full input model — pointer, touch, keyboard — before any library call, and treats the keyboard path as a launch blocker, not polish. Does NOT build on the HTML5 Drag and Drop API for in-app interactions, and does not ship reordering without a persistence-failure story.

Build on **pointer events**, not the HTML5 DnD API: `dragstart`/`drop` doesn't fire on mobile touch, gives you an unstylable OS ghost image, and has inconsistent `dataTransfer` behavior — reserve it only for the cases it uniquely owns: OS file drops into the page and drags between browser windows. Use **dnd-kit** (React) or Atlassian's **pragmatic-drag-and-drop** (framework-agnostic, and the one library that deliberately builds on native DnD to get cross-window support) rather than hand-rolling, but hand-roll knowledge still applies: `setPointerCapture()` on the drag handle so the drag survives leaving the element, `touch-action: none` on draggables so the browser doesn't hijack the gesture for scrolling, and an **activation constraint** of ~5–8px movement (or ~200–250ms long-press on touch) before a drag begins, so taps and clicks still work on draggable items. Affordances are what make it feel solid: visible grip handles (don't make the whole card the handle if it contains buttons or selectable text), a drop indicator line or highlighted target rendered from the same hit-testing logic that will execute the drop, and `overflow` containers that **auto-scroll** when the pointer enters an edge zone of ~10–15% of the container (~50px), with speed proportional to edge proximity. Keyboard access is a WCAG requirement — 2.1.1 plus **2.5.7 Dragging Movements** demands a single-pointer/keyboard alternative — so ship the pattern dnd-kit encodes: focus item → Space/Enter picks up → arrows move → Space drops, Escape cancels, every state change announced via a **live region** ("Moved Task A to position 3 of 7"), and ideally an explicit non-drag fallback ("Move to…" menu). Reorders should be **optimistic**: update local order immediately, persist with a fractional/LexoRank-style index to avoid renumbering whole lists, and on failure animate the item back with a toast — never leave UI and server order silently diverged. Rule: **Never ship a drag interaction without a keyboard-operable equivalent and a touch activation delay — pointer-events + ~5–8px activation for mouse, ~200ms long-press for touch, Space/arrows/Escape for keyboard.**

BAD: "Use draggable=true and the HTML5 drop events — it's the native API" (nothing drags on iOS/Android, the ghost image is unstylable, and keyboard users get nothing). GOOD: "pragmatic-drag-and-drop for the kanban with a 6px activation distance, 250ms touch long-press, edge auto-scroll, and a pick-up/move/drop keyboard mode announced through a live region."

```
DRAG INTERACTION SPEC
══════════════════════════════════
Surface: [list/kanban/canvas/file-drop] · Library: [dnd-kit / pragmatic-dnd / native-DnD(files only)]
Activation: pointer=[~6px] · touch=[~200-250ms hold] · handle=[grip/whole-item]
Affordances: [drop indicator] · [drag preview] · [invalid-target signal]
Auto-scroll: zone=[~50px/15%] · axis=[x/y/both] · nested containers: [strategy]
Keyboard: [Space pickup · arrows move · Space drop · Esc cancel] · Live region: [message template]
Persistence: [optimistic + fractional index] · Failure: [animate-back + toast + refetch]
```

Skip when: the reorder is rare or low-stakes — up/down buttons or a "Move to" menu ship in a tenth of the time with accessibility built in; or you're accepting OS file drops only, where native DnD events plus an `<input type=file>` fallback is the whole job.

Gotchas: Forgetting `touch-action: none` and shipping a drag that fights page scroll on every phone; hit-testing drop targets with `getBoundingClientRect` per pointermove without caching or rAF-throttling, which janks long lists; making the entire row the drag surface so text selection, links, and buttons inside it break; and persisting reorders with integer positions that require rewriting N rows per drop — use fractional indexes and rebalance only when gaps exhaust (commonly after ~50+ inserts between the same pair).
