---
name: web-components-decision
description: Use when deciding whether to build UI as web components (custom elements) or framework-native components — typically for design systems consumed by multiple teams. Produces a decision record covering distribution targets, shadow-DOM styling strategy, SSR plan, and the framework-interop gaps to budget for.
---

# /web-components-decision — Custom Elements Without the Evangelism

Use to make an honest platform-vs-framework call before committing a design system or embeddable widget to web components.

**Persona: Design-System Platform Architect.** Evaluates the real consumer landscape and picks the component technology with the lowest total interop cost. Writes the decision record and the styling/SSR contract. Does NOT rewrite an existing single-framework component library "for portability," and does not treat web components as automatically more future-proof.

The honest heuristic: web components win when you ship one UI to **2+ framework runtimes** you don't control — a design system consumed by React, Angular, and Vue teams, or a widget embedded in third-party pages. Below that threshold, framework components win on DX, typing, and ecosystem. If you go custom elements, use **Lit** (or vanilla + **ElementInternals** for form controls — form-associated custom elements are baseline now), publish a **custom-elements-manifest** for editor/typing support, and know that React only gained first-class custom-element support (props-as-properties, typed events) in React 19 — consumers on 18 still need wrappers, so generate them with `@lit/react` rather than hand-writing. Shadow DOM styling is a contract, not magic: expose **CSS custom properties** for tokens, **`::part`** for structural overrides, and use **`adoptedStyleSheets`** to share constructable stylesheets instead of duplicating `<style>` per instance. Accept what shadow DOM breaks: global utility classes (Tailwind) don't pierce, `@font-face` must live in the document, and cross-root focus/ARIA references remain awkward despite reference-target proposals. For SSR, **Declarative Shadow DOM** (`<template shadowrootmode>`) is supported in all evergreen browsers and Lit SSR renders to it — but hydration ordering matters: undefined elements render fallback, so ship `customElements.whenDefined` gates and style `:not(:defined)` to prevent FOUC. Rule: **Choose custom elements only when components must run in 2+ frameworks or in host pages you don't control; otherwise stay framework-native and revisit only when a second runtime actually materializes.**

BAD: "Build our internal React-only design system as web components so we're framework-agnostic someday" (you pay the shadow-DOM styling tax, wrapper generation, and SSR complexity daily for a portability benefit that may never be cashed in). GOOD: "React-only consumers → React components; the moment the Angular acquisition team becomes a real consumer, wrap the token layer and rebuild leaf primitives in Lit with `::part` contracts."

```
WEB COMPONENTS DECISION RECORD
══════════════════════════════════
Consumers: [frameworks/teams + versions] · Control over host pages: [yes/no]
Verdict: [custom elements / framework-native] · Trigger to revisit: [event]
If custom elements — Base: [Lit x / vanilla+ElementInternals] · Wrappers: [@lit/react etc.]
Styling contract: tokens=[CSS custom props] · overrides=[::part list] · sheets=[adoptedStyleSheets]
SSR: [Declarative Shadow DOM via Lit SSR / client-only] · FOUC guard: [:not(:defined) rule]
Known gaps accepted: [Tailwind piercing · cross-root ARIA · React<19 wrappers]
```

Skip when: the component library has one consumer framework and no embedding requirement, or you're building app-level (not leaf/primitive) components — routing, data-fetching, and state belong in the framework.

Gotchas: Teams adopt shadow DOM then immediately fight it with `::part(x) *` hacks — if you're piercing everywhere, you wanted light-DOM custom elements or scoped CSS instead; SSR'd Declarative Shadow DOM plus a client bundle that re-renders on definition causes visible content flash unless the element adopts the existing shadow root (Lit does, hand-rolled bases usually don't); events don't cross the boundary the way you expect — `composed: true` must be explicit or React/Vue listeners never fire; and slotted content is styled by the host page, not your component, so your "encapsulated" component still breaks under aggressive host CSS resets.
