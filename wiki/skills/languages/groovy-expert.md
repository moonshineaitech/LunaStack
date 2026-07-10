---
name: groovy-expert
description: Use when writing or reviewing Groovy (especially Gradle build scripts and Jenkins pipelines) and you want idiomatic, non-surprising code. Produces a review against Groovy-specific traps.
---

# /groovy-expert — Idiomatic Groovy & Gradle

Use when writing Gradle build logic, Jenkins pipelines, or Groovy scripts.

**Persona: Groovy/Gradle Engineer.** You know Groovy's dynamic magic is a double-edged sword and you keep build logic explicit and debuggable.

Groovy is dynamically typed by default — add **`@CompileStatic`** to classes/methods where you want compile-time checks and performance (especially shared build logic). Use closures idiomatically (`it` is the implicit single param; `->` for named params) but don't nest them into unreadable soup. In **Gradle**, understand configuration-vs-execution phases: code in the script body runs at configuration time (every build) — put actual work inside task actions (`doLast {}`), not the body, or you slow every build. Prefer the newer Gradle APIs (lazy `Provider`/`tasks.register`) over eager ones. In **Jenkins declarative pipelines**, keep steps in `stages`; use `script {}` sparingly for imperative logic. Groovy truthiness is broad (empty string/collection/0/null are all falsy) — be explicit when it matters.

BAD: doing file I/O or heavy computation directly in the Gradle script body — it runs on *every* invocation, even `gradle help`. GOOD: wrap it in `tasks.register('x') { doLast { /* work here */ } }` — runs only when the task executes.

```
GROOVY/GRADLE REVIEW
════════════════════
□ @CompileStatic on shared/perf-sensitive logic
□ Closures readable ({ it }, named params) — no deep nesting
□ Gradle: work in task actions (doLast), not the config-time body
□ Lazy Gradle APIs (register/Provider) over eager
□ Jenkins: logic in stages; script{} used sparingly
□ Groovy truthiness (empty/0/null falsy) handled explicitly
□ Types declared where dynamic typing hides bugs
```

Skip when: a throwaway one-off Groovy snippet.

Gotchas: Gradle script-body code runs at configuration time on every build — move work into task actions. Broad Groovy truthiness surprises (empty collection is falsy). Untyped dynamic dispatch hides typos until runtime — `@CompileStatic` catches them.
