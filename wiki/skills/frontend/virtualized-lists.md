---
name: virtualized-lists
description: Use when rendering lists or tables large enough to jank — commonly beyond ~200 DOM-heavy rows — or when an existing virtualized list has scroll glitches, broken find-in-page, or accessibility gaps. Produces a windowing implementation plan covering overscan, dynamic row measurement, scroll restoration, and ARIA, or a recommendation to paginate instead.
---

# /virtualized-lists — Render the Window, Not the World

Use to window large lists correctly — or to conclude that pagination is the better tool before you buy virtualization's complexity.

**Persona: List Performance Engineer.** You render only what's visible plus a tuned overscan, measure real row heights instead of guessing, and keep keyboard users, screen readers, and the browser's own find-in-page working. You do not virtualize lists small enough to just render, and you do not fake scrollbars.

Decide the tool first: virtualization earns its cost when the list is **unbounded or ~200+ rows of non-trivial DOM** and the interaction is continuous scanning (feeds, logs, autocomplete over thousands of options); if users jump to known items or need URL-addressable positions, **pagination or "load more" beats it** — simpler, SEO-visible, and Cmd-F works. CSS `content-visibility: auto` with `contain-intrinsic-size` is the zero-JS middle option worth trying before a library. When you do virtualize, use a headless engine like **TanStack Virtual** (framework-agnostic, dynamic measurement built in): keep **overscan small — commonly 2–5 rows** — because large overscan quietly recreates the problem you're solving; fix blank-on-fling with lighter rows or a skeleton fill, not overscan 20. Dynamic heights come from `measureElement` (ResizeObserver-backed) with a realistic `estimateSize` — bad estimates make the scrollbar lie and jump; never re-measure during scroll frames. Scroll restoration: persist the anchor **item index/key, not pixel offset** (heights re-measure differently on return), restore via `scrollToIndex` after data hydrates, and set `overflow-anchor` expectations yourself since windowing defeats native anchoring. Accessibility is the part everyone ships broken: removed rows are invisible to screen readers, so put `role="listbox"/"grid"` on the container with `aria-rowcount`/`aria-setsize` for the *full* count and `aria-rowindex`/`aria-posinset` per rendered row; keyboard navigation must move an **active-descendant or roving-tabindex cursor** that drives `scrollToIndex`, because Tab cannot reach unrendered rows. Rule: **Virtualize only continuous-scan lists too big to render, keep overscan at 2–5 rows, and expose full list size and position via ARIA row/set attributes — a virtualized list a screen reader perceives as 12 items is a defect.**

BAD: "The 10k-row table janks, so wrap it in a virtualizer with overscan 30 to hide blank rows" (30 extra heavy rows per edge rebuilds the original render cost; blanks mean rows are too expensive). GOOD: "Flatten each row to one cheap component, virtualize with overscan 4, `estimateSize` from median measured height, and skeleton-fill during fling."

```
VIRTUALIZATION PLAN
═══════════════════
Verdict: [render all / content-visibility / virtualize / paginate] · Rows: [n, heights: fixed/dynamic]
Engine: [TanStack Virtual · overscan: 2–5] · Estimate: [px + measureElement]
Restore: [anchor = item key → scrollToIndex on return]
A11y: [role · aria-rowcount/setsize full n · roving tabindex → scrollToIndex]
Known losses: [find-in-page · print — mitigation or accepted]
```

Skip when: the list caps below a few hundred cheap rows — `content-visibility: auto` or nothing; or content must be crawlable/printable/findable in full — paginate or render everything server-side.

Gotchas: keying rows by array index so recycled rows show stale state (input values, checkmarks) from the item previously in that slot — key by item ID. Measuring rows with margins the virtualizer can't see — collapse margins into padding or `gap`. Infinite-scroll + virtualization without a sentinel offset, so `fetchNextPage` fires only after the user hits a wall of blanks — trigger at ~10 rows from the end. Forgetting find-in-page and screen-reader "read all" are structurally gone; if stakeholders need them, that's a pagination requirement wearing a performance costume.
