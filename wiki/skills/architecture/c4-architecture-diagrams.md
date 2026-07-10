---
name: c4-architecture-diagrams
description: Use when a system needs explaining — onboarding, design review, or an architecture doc — and prose or whiteboard photos aren't cutting it. Produces C4 diagrams as code (Structurizr DSL or Mermaid C4) at the right abstraction level for the stated audience, with element counts kept legible.
---

# /c4-architecture-diagrams — One Level, One Audience

Use to draw software architecture at a deliberate zoom level instead of one everything-diagram.

**Persona: Architecture Illustrator.** Becomes the communicator who picks the C4 level from the audience first, then draws only that level, as code, in version control. Does NOT produce a single mega-diagram, hand-drawn exports that rot, or Component diagrams nobody asked for.

C4's real insight is that a diagram is for an audience, and each level has exactly one: **System Context** (your system as one box plus users and neighboring systems — for executives, product, and new hires; if a non-engineer can't follow it, it isn't a context diagram), **Container** (deployable/runnable units — apps, services, databases, queues — for engineers joining or reviewing; this is the workhorse, and 80% of teams need only these top two levels), **Component** (inside one container — draw only for containers under active heavy change, since these rot fastest), and Code (never draw; your IDE generates it on demand). Write diagrams as code so they diff in PRs: **Structurizr DSL** is the strongest fit because one model emits all views consistently (renderable via Structurizr Lite/on-prem, exportable to Mermaid/PlantUML); **Mermaid's C4 syntax** wins when you want zero extra tooling and native GitHub/GitLab rendering; **LikeC4** is a solid newer alternative with live embedding. Legibility budget: keep any diagram to ~15-20 elements — beyond that, split into multiple views of the same model rather than shrinking the font. Every arrow gets a verb and a protocol ("sends order events via Kafka"), because an unlabeled line transmits zero information; every diagram gets a title stating level and scope. Review diagrams in the PRs that change the architecture they depict — a diagram that isn't in version control is already wrong. Rule: **Name the audience before drawing; if you can't say who the diagram is for, don't draw it — and stop at Container level unless a specific team asks for Component detail.**

BAD: "One master Visio diagram showing every service, pod, lambda, and table — 90 boxes, updated whenever someone remembers" (no audience can parse it, nobody updates it, and it's wrong within a sprint). GOOD: "Structurizr DSL in-repo: one Context view for stakeholders, one Container view per system for engineers, rendered in CI, changed in the same PR as the architecture."

```
C4 DIAGRAM PLAN
═══════════════
View: [context/container/component] · Audience: [who] · Question it answers: [one line]
Scope: [system/container name] · Elements: [count ≤ ~20] · Tool: [Structurizr DSL / Mermaid C4 / LikeC4]
Source path: [docs/architecture/*.dsl] · Rendered in: [CI job / README embed]
Arrow spec: [A → B: "verb + payload via protocol"]
Refresh trigger: [PRs touching architecture must update the model]
```

Skip when: the system is one deployable with one datastore — a paragraph plus the repo layout beats a diagram; or you need a runtime/sequence explanation, where a Mermaid sequence diagram is the right tool, not C4.

Gotchas: mixing zoom levels in one picture (a Kubernetes pod next to "The Internet") destroys the abstraction that makes C4 readable; drawing deployment topology on a Container diagram — C4 has a separate Deployment view for regions/nodes; unlabeled arrows and cryptic box names ("SvcX") force readers to interview the author, defeating the point; treating diagrams as launch artifacts instead of living code — stale architecture diagrams are worse than none because people trust them.
