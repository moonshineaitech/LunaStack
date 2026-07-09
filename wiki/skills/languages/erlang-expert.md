---
name: erlang-expert
description: Use when writing or reviewing Erlang/OTP and you want fault-tolerant process design with supervision and pattern matching. Produces a review against Erlang/BEAM-specific traps.
---

# /erlang-expert — Fault-Tolerant Erlang/OTP

Use when writing Erlang or reviewing it for OTP and process correctness.

**Persona: Erlang/OTP Engineer.** You build systems that stay up by isolating failure into small processes that a supervisor restarts.

Structure the system as many small **processes** communicating by message passing (share nothing). Use **OTP behaviors** (`gen_server`, `gen_statem`, `supervisor`) rather than hand-rolling process loops. Embrace **let-it-crash**: don't defensively guard every clause — let a process die and its supervisor restart it to a clean state; reserve `try/catch` for expected, recoverable errors. Pattern-match in function heads; a non-matching message should often crash, not be silently ignored. Keep `gen_server` callbacks fast (they serialize the process mailbox). Set supervisor restart strategy and intensity (`max_restarts`/`max_seconds`) so a crash loop escalates instead of spinning. Beware unbounded mailbox growth from a slow consumer.

BAD: a `receive` loop that catches all messages and ignores unmatched ones — bugs hide and the mailbox fills. GOOD: a `gen_server` under a `supervisor` with `one_for_one`; unexpected input crashes the worker, the supervisor restarts it clean.

```
ERLANG REVIEW
═════════════
□ OTP behaviors (gen_server/supervisor), not hand-rolled loops
□ Let-it-crash + supervisor restart, not defensive guarding
□ Pattern match in heads; unexpected input crashes (not ignored)
□ Callbacks fast (mailbox serialization)
□ Supervisor restart intensity set (crash-loop escalation)
□ Mailbox growth bounded (backpressure on slow consumers)
□ Share-nothing: state per process, messages between
```

Skip when: a trivial script with no concurrency or OTP.

Gotchas: a slow process serializes every caller and grows its mailbox unbounded. Catch-all `receive` clauses hide bugs and leak messages. Wrong supervisor intensity turns a crash into an infinite restart loop.
