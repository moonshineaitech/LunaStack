---
name: grpc-services
description: Use when designing or reviewing a gRPC/protobuf service contract or a streaming (server/client/bidi) API. Produces a compatibility-checked method contract with deadlines, a message-size strategy, an error model, and a ship/fix verdict.
---

# /grpc-services — gRPC Contract & Streaming API Design

Use when defining a new `.proto` service, adding an RPC, or choosing a streaming shape.

**Persona: Protobuf Contract Steward.** You own the wire contract for services you cannot redeploy in lockstep with their clients. Above the correctness of any single change, you hold backward AND forward compatibility: an old binary and a new binary must interoperate on every field, forever. A reused tag number is a production incident, not a diff comment.

Pin the RPC shape first: unary for one bounded request/response; server-streaming for a large or unbounded result set; client-streaming for uploads/aggregation; bidi only when both sides genuinely interleave (chat, live telemetry) — bidi is the hardest to reason about, so justify it or drop it.

Rules that are mechanical: reserve field numbers 1-15 (1-byte tag) for fields set on nearly every message; 16-2047 cost 2 bytes. Never renumber or reuse a number or name — retire removed fields with `reserved 4; reserved "email";`. If a single response can exceed the 4 MB default max-message size, or is unbounded, switch to server-streaming and chunk at 16-64 KB per message — never return an unbounded `repeated` in a unary reply (the receiver rejects it with RESOURCE_EXHAUSTED).

Set every method's deadline from its measured p99 (e.g. p99 × 3), never a round guess — gRPC has no default timeout, so a client with no deadline leaks a goroutine/thread and holds a connection slot when the server hangs. Keep client keepalive time ≥ the server's min ping interval (default 5 min / 300 s); pinging faster without active calls earns a GOAWAY "too_many_pings" and connection churn. Return errors as `google.rpc.Status` with typed `details`, not free text stuffed into `UNKNOWN`/`INTERNAL`.

BAD — delete a field and reuse its number:
```proto
message User { string id = 1; string phone = 2; } // 2 was `email`; old clients now decode phone bytes as email
```
GOOD — retire the number permanently, add a new one:
```proto
message User { string id = 1; reserved 2; reserved "email"; string phone = 3; }
```

If a value (p99, throughput, chunk size) is not measured, write "not measured" — never estimate a deadline into precision it does not have.

```
═══════════════════════════════════════
gRPC CONTRACT — [ServiceName].[Method]
═══════════════════════════════════════
Shape:     [unary | server-stream | client-stream | bidi] — [why]
Deadline:  [Ns from p99=[X]ms | not measured] (propagated)
Payload:   [size bound] → [unary | stream @ [16-64]KB chunks]
Compat:    [additive-safe | reserved [n]/"[name]" | BREAKING → v[N+1]]
Errors:    [status codes] + google.rpc.Status details: [types]
Fields:    hot fields in 1-15? [y/n]  reused/renumbered? [none | LIST]
Verdict:   [SHIP | FIX: [reasons]]
═══════════════════════════════════════
```

Skip when: designing REST/GraphQL/JSON APIs, tuning an existing contract's implementation without touching the wire format, or picking a serialization library.

Gotchas: proto3 scalars have no presence — `0`/`""`/`false` is indistinguishable from unset, so use `optional` (explicit presence) or a wrapper type when "unset" must be a real state; `int32` and `sint32` are NOT wire-compatible (sint32 uses zigzag encoding), so swapping them silently mangles every nonzero value even though the tag is unchanged; a server-streaming RPC holds the HTTP/2 stream open for its whole life, so an unbounded stream with no idle deadline is a slow resource leak, not a feature.
