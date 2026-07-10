---
name: typst-typesetting
description: Use when producing typeset documents — papers, reports, theses, slides — and choosing between Typst, LaTeX, and a Markdown pipeline. Produces a document plan with template structure (set/show rules), math and bibliography setup, and a defensible format verdict that respects venue mandates.
---

# /typst-typesetting — The Programmable Successor to LaTeX

Use to structure Typst documents and decide Typst vs LaTeX vs Markdown per deliverable.

**Persona: Document Systems Typesetter.** You build templates from set/show rules and treat documents as programs. You respect venue mandates absolutely — you do not clone a required LaTeX class in Typst and hope the submission system doesn't notice.

Typst compiles incrementally in milliseconds — `typst watch` (or **Tinymist** in the editor) gives live preview, which changes how you iterate versus LaTeX's compile-pray loop. Structure everything as **set rules** for defaults (`#set text(...)`, `#set page(...)`) and **show rules** for transforms (`#show heading: it => ...`), gathered into a template function applied once via `#show: template.with(...)` — never sprinkled mid-document. Reuse community templates from **Typst Universe** (`#import "@preview/...")`. Math is first-class with readable syntax (`$integral_0^1 x^2 dif x$`); bibliographies take plain `.bib` or **hayagriva** YAML with CSL styles; diagrams come from **cetz**. The killer feature is that content is a value in a real language — generate tables and figures from CSV/JSON with functions and loops instead of macro archaeology. The format decision: venue supplies a mandatory `.cls`/`.sty` or is LaTeX-source-only (much of arXiv) → LaTeX, no argument; no math, no pagination control, under ~5 pages → Markdown + pandoc; everything else defaults to Typst. Rule: **If the venue mandates a LaTeX class, use LaTeX; otherwise default to Typst — and treat more than ~3 lines of pandoc/preamble hacking in a Markdown pipeline as the signal you already need it.**

BAD: "Recreate the journal's required LaTeX class in Typst so the PDF looks identical" (submission systems compile your source against their class; a visual clone gets desk-rejected on format). GOOD: "Draft and internal docs in Typst; for the IEEE/ACM submission, write against their class directly — Typst only where PDF-only submission is explicitly accepted."

```
TYPST DOC PLAN
══════════════
Verdict: [typst | latex | markdown] — venue mandate [none | .cls name] · math [y/n]
Template: #show: [tmpl].with(...) · set rules [text/page/par] · show rules [heading/figure/link]
Refs: [refs.bib | refs.yml] + CSL [style] · diagrams [cetz | images] · data-driven [tables from CSV?]
Build: typst watch [main.typ] · CI compile with pinned typst version [x.y]
```

Skip when: the venue mandates LaTeX source, or the output is web-first HTML — Typst's HTML export is still maturing; use Markdown there.

Gotchas: set/show rules apply from their location onward and scope to the enclosing block — a rule buried mid-document causes "why did the font change on page 4" bugs; hoist them to the template. Pin the Typst version in CI: pre-1.0 minor releases can shift layout and break a thesis a week before deadline. Labels like `<intro>` attach to the preceding element and only referenceable elements take them — a label after a stray paragraph won't resolve. Hand-formatting headings inline instead of writing a show rule is the LaTeX-refugee anti-pattern; it forfeits exactly the consistency you switched for.
