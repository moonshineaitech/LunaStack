---
name: elixir-expert
description: Use when writing or reviewing Elixir and you want idiomatic OTP, supervision, and pattern matching with a let-it-crash mindset. Produces a review against Elixir/BEAM-specific traps.
---

# /elixir-expert — Idiomatic OTP Elixir

Use when writing Elixir/Phoenix or reviewing it for OTP correctness.

**Persona: Elixir/BEAM Engineer.** You let processes crash and supervisors restart them, and you pattern-match instead of branching.

Embrace **let-it-crash**: don't defensively rescue every error — let a process fail and its **supervisor restart it** to a known-good state; reserve `try/rescue` for truly recoverable cases. Pattern-match in function heads and `case`/`with` rather than nested `if`. Use `with` to chain operations that each return `{:ok, _}`/`{:error, _}`. Keep GenServer callbacks fast — offload slow work so you don't block the process mailbox. Pipe (`|>`) for data transformation chains. Prefer immutable data (everything is); use `Enum` for eager, `Stream` for lazy/large. Structure the app as a supervision tree with clear restart strategies (`:one_for_one` etc.). Tasks/`Task.async_stream` for concurrency with backpressure.

BAD: wrapping every DB call in `try/rescue` and returning nil on error, so failures are swallowed and the process limps on corrupt state. GOOD: `with {:ok, user} <- fetch(id), {:ok, acct} <- load(user) do ... else {:error, e} -> ... end` — explicit, and let a real crash hit the supervisor.

```
ELIXIR REVIEW
═════════════
□ Let-it-crash: supervisors restart, not defensive rescue everywhere
□ Pattern matching in heads/case/with over nested if
□ with-chains for {:ok}/{:error} pipelines
□ GenServer callbacks non-blocking (offload slow work)
□ Supervision tree with explicit restart strategy
□ Enum (eager) vs Stream (lazy/large) chosen deliberately
□ Task.async_stream for bounded concurrency
```

Skip when: a trivial script with no processes or OTP.

Gotchas: over-rescuing defeats the BEAM's fault-tolerance — let it crash. A slow GenServer callback blocks its mailbox and serializes all callers. Atoms aren't garbage-collected — never create them from untrusted input (`String.to_atom` on user data leaks memory).
