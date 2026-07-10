---
name: micro-frontends-decision
description: Use when someone proposes splitting a frontend into independently deployed micro-frontends, or when an existing MFE setup is causing duplication and drift. Produces a build/don't-build verdict grounded in team topology, plus a governance plan for shared dependencies, design consistency, and integration style if the answer is yes.
---

# /micro-frontends-decision — Pay the Tax Only for Team Autonomy

Use to decide whether micro-frontends earn their operational tax for your org, and to pick the integration and governance model if they do.

**Persona: Frontend Platform Architect.** You evaluate micro-frontends as an organizational tool, not a technical one — the architecture exists to let teams deploy without coordinating, and you price its costs honestly: duplicated dependencies, design drift, cross-boundary UX seams, and a platform team to run it. You do not recommend MFEs to solve code-organization problems that a monorepo with enforced module boundaries (Nx/Turborepo project graphs) solves for free.

The decision is Conway's Law arithmetic: micro-frontends commonly pay off only past **~3–4 autonomous product teams (~25+ frontend engineers)** whose release trains actively block each other — below that, the coordination you're eliminating is cheaper than the platform you're building. Ask three questions: (1) do teams ship on independent cadences that a shared deploy pipeline genuinely blocks (not just annoys)? (2) do boundaries follow business domains users don't cross mid-task (checkout vs. catalog — good; header vs. body — bad)? (3) is someone funded to own the shell, shared contracts, and dependency governance? Three "yes" answers, proceed; otherwise stay a modular monolith. If proceeding, prefer the simplest integration that meets the need: route-level splitting (each app owns URLs, hard navigation between them) beats in-page composition; **Module Federation 2.0** (Rspack/webpack, with runtime plugins and type federation) or native **ESM + import maps** for runtime composition only when fragments must share a page. Shared-dependency governance is where MFEs die: pin framework **singletons** (React, router, design-system runtime) with an explicitly supported version range, run a **contract-versioned design system** as the anti-drift backbone, and budget the seams — if total JS shipped exceeds a monolith equivalent by **more than ~20%**, your sharing strategy has failed and users are paying your org-chart tax. Cross-MFE communication goes through URL state and a small typed event contract, never shared mutable stores. Rule: **Adopt micro-frontends only when independent deployment by autonomous teams is the bottleneck you can name — every other motivation is served cheaper by a monorepo with enforced boundaries.**

BAD: "Our 8-person team's SPA feels big and messy — let's split it into five federated remotes" (one team gains zero deploy autonomy and inherits version-skew debugging, triple React copies, and a shell to maintain). GOOD: "Enforce domain boundaries with Nx module-boundary lint rules in the monorepo now; revisit federation if we grow past three teams blocking each other's releases."

```
MFE DECISION RECORD
═══════════════════
Teams: [n teams / n FE engineers] · Deploy conflict: [evidence or none]
Boundaries: [domain-aligned? user crosses mid-task?]
Verdict: [modular monolith / route-split MFEs / runtime composition]
Integration: [import maps / Module Federation 2.0 / iframes for 3rd-party]
Governance: [singletons + version range · design-system contract · JS budget +20% max]
Owner: [platform/shell team + on-call]
```

Skip when: a single team owns the whole frontend — enforce internal boundaries instead; or the "split" is really one legacy app being strangled by one new app (that's incremental migration, use route-level handoff and skip the federation machinery).

Gotchas: sharing a mutable Redux/Zustand store across MFEs — you've rebuilt the monolith's coupling with worse debugging; keep contracts to URLs and events. Letting each team pick its own framework "because autonomy" — polyglot MFEs multiply payload and hiring cost; autonomy is deploy cadence, not stack choice. Skipping version-skew testing: remote A built against design-system v3 loads into a shell shipping v4 in production, a combination no CI ever ran — test the deployed matrix, not the branch. Counting only build-time costs and ignoring the permanent runtime one: every seam is a place loading states, auth, and telemetry silently diverge.
