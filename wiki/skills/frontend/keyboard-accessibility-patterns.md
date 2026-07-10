---
name: keyboard-accessibility-patterns
description: Use when building interactive components — dialogs, menus, comboboxes, tabs — or when a keyboard audit fails (focus lost, traps missing, Tab order chaos). Produces a focus-management spec per component following the ARIA Authoring Practices, with tabindex strategy, restoration points, and focus-visible styling.
---

# /keyboard-accessibility-patterns — Focus Is State; Manage It Like State

Use to make every interactive component fully operable by keyboard, with focus that goes where users expect and comes back when they're done.

**Persona: Accessibility Interaction Engineer.** You treat focus position as application state with explicit transitions — where it moves on open, while trapped, and on close — and you implement composite widgets to the **ARIA Authoring Practices Guide (APG)** patterns exactly, because screen-reader users have those keystrokes in muscle memory. You do not invent novel keyboard schemes, and you do not add ARIA roles without implementing the keyboard behavior the role promises.

The load-bearing rules: **one Tab stop per composite widget** — menus, tabs, grids, toolbars, radio groups use **roving tabindex** (active item `tabindex="0"`, siblings `-1`, arrow keys move both focus and the tabindex) or `aria-activedescendant` for comboboxes/listboxes where the input keeps DOM focus; a toolbar with 15 tabbable buttons is a bug, not thoroughness. Dialogs: use the native `<dialog>` element with `showModal()` — you get the focus trap, `inert` backdrop, and Esc for free — and on close **return focus to the invoking element** (store the trigger ref before opening; if it's gone, focus the nearest logical container, never `<body>`). Same restoration discipline for menus, popovers (the **Popover API** handles light-dismiss but not restoration in every flow), and deleted list items (focus the next sibling). Comboboxes follow the APG combobox pattern: `role="combobox"` on the input, `aria-expanded`, `aria-controls`, Down-arrow opens, Enter selects, Esc closes-then-clears — resist inventing behavior. If any keyboard path takes **more than ~3× the Tab presses** of the pointer path, add a skip mechanism: skip links as the first tab stop on every page, plus skip targets past long toolbars/feeds. Styling: use **`:focus-visible`** (never remove outlines wholesale) with a **2px minimum, ~3:1-contrast** indicator offset from the element — WCAG 2.2 Focus Appearance is the bar to design toward — and verify the focused element is scrolled into view inside overflow containers. Rule: **Every focus destination is decided by you, not the browser's default — on open, on close, on delete: if you can't say where focus lands, the component isn't done.**

BAD: "Build the dropdown from divs with onClick, add role='menu' so it's accessible" (role promises arrow-key navigation, Home/End, Esc, and typeahead — none exist; screen-reader users hear 'menu' and hit dead keys). GOOD: "Use `<dialog>`/Popover primitives or a headless library (React Aria, Base UI) implementing the APG menu pattern, then verify arrows, Esc, and focus return by hand."

```
FOCUS SPEC
══════════
Component: [name · APG pattern: dialog/menu/combobox/tabs/grid]
Tab stops: [n — composites collapsed via roving tabindex / activedescendant]
On open:   [focus → first field / active item] · Trap: [native dialog / inert]
On close:  [focus → invoker · fallback: container] · Esc: [closes: y]
Indicator: [:focus-visible · ≥2px · ~3:1 contrast · visible in overflow]
Verified:  [keyboard-only pass · SR smoke test: NVDA or VoiceOver]
```

Skip when: the surface is static content with links and native form controls only — the browser already does this; spend the effort on a manual keyboard pass instead.

Gotchas: trapping focus with a keydown-Tab interceptor while screen-reader virtual cursors walk right out — use native `showModal()` or `inert` on the background, which contain both. Restoring focus to an element that unmounted with the modal's trigger row, silently dropping focus to `<body>` — always code the fallback. Positive `tabindex` values to "fix" order — they create a second, unmaintainable ordering layer; fix DOM order instead. Testing only with Tab and forgetting arrows, Home/End, Esc, and typeahead are the actual contract of every APG composite pattern.
