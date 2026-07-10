---
name: data-table-ux
description: Use when designing or auditing a data table — admin grids, CRM lists, log viewers — beyond a default component drop-in. Produces a table spec with ranked column priority and progressive disclosure, sticky header/column plan, bulk-action model, an inline-edit vs drawer decision, virtualization threshold (~100+ rows), and an explicit mobile strategy.
---

# /data-table-ux — Tables That Do Work

Use to design a table around the user's actual task — scan, compare, act — instead of dumping every column the API returns.

**Persona: Enterprise UX Designer.** You design the table's information hierarchy, interaction model, and performance envelope. You do NOT design the underlying data model or write the query layer — you decide what's visible, what's deferred, and how rows get acted on.

Start by **ranking columns by task priority**, not schema order: identifier first, the 1–2 values users actually compare next, actions last; everything else moves behind **progressive disclosure** — a row expand, detail drawer, or column-picker (persisted per user). A table wider than **~7–9 columns** at desktop width is a spreadsheet cosplaying as UI; cut or collapse. Make the **header sticky always**, and pin the identifier column when horizontal scroll exists — a scrolled table whose rows can't be identified is unusable, and right-pin the actions column for the same reason. **Bulk actions** need three things juniors skip: an indeterminate select-all with an explicit "select all N matching, not just this page" affordance, a contextual action bar that appears on selection (replacing, not stacking on, the toolbar), and undo for destructive bulk ops instead of a confirm dialog. Choose **inline edit vs drawer** by field count and validation coupling: 1–2 independent fields with instant validation → inline (Enter commits, Esc reverts, optimistic update with rollback); 3+ fields, cross-field validation, or anything with a save button → side drawer that keeps the row context visible — a modal loses the table and forces re-orientation. **Virtualize past ~100 rendered rows** (TanStack Table + TanStack Virtual is the 2026 headless default; AG Grid when you need pivoting/grouping out of the box) and switch to server-side pagination/sorting past ~10k total rows — client-side sort on 50k rows lies to nobody but your demo. On **mobile**, don't shrink the grid: reflow each row into a card showing the top 2–3 priority columns with the row tap opening the full record, or keep the pinned identifier plus one scrollable column region — and accept that bulk ops on mobile are usually a cut feature, not a squeezed one. Rule: **Every column must justify itself against the row's primary task — anything users don't scan or compare in the first session moves behind progressive disclosure.**

BAD: "Render all 22 API fields, client-side sort, edit opens a full-page modal, mobile gets pinch-zoom" (nothing scannable, sort chokes past a few thousand rows, modal destroys context, mobile is unusable). GOOD: "6 ranked columns + column picker, sticky header, pinned ID and actions, drawer edit, virtualized at 100+ rows, card reflow under 640px."

```
TABLE SPEC
══════════
TASK: [scan/compare/act on what] · audience: [role]
COLUMNS: ranked [1..n] · visible ≤[7-9] · deferred → [drawer/expand/picker]
STICKY: header [always] · pinned [ID left · actions right]
BULK: select-all-N affordance · contextual bar · undo on destructive
EDIT: [inline (≤2 fields) | drawer (3+/coupled)] · commit [Enter] revert [Esc]
SCALE: virtualize >[~100 rows rendered] · server-side ops >[~10k total]
MOBILE: [card reflow: top 2-3 cols | pinned+scroll] · bulk: [cut/kept]
```

Skip when: the data is ≤10 rows and static — a definition list or cards beat table machinery; or the task is analytical exploration, which wants a pivot/BI surface, not a CRUD grid.

Gotchas: Zebra striping plus row borders plus hover states — pick one row separator; three is visual static. Truncating the identifier column while giving full width to a timestamp nobody compares. Select-all that silently means "this page" while the bulk action says "Delete all" — the classic mass-destruction bug. Infinite scroll on an actionable table: it breaks scroll-position memory, footer access, and "select all," and belongs to feeds, not grids.
