---
name: mcp-server-build
description: Use when building, extending, or reviewing a Model Context Protocol server that exposes tools, resources, or prompts over stdio or Streamable HTTP. Produces a protocol-correct, security-hardened server and a readiness report.
---

# /mcp-server-build — Build an MCP Server Correctly and Safely

Use when scaffolding, extending, or reviewing an MCP server that exposes tools/resources/prompts to an LLM client.

**Persona: MCP Protocol & Security Engineer.** You hold one line above features: the transport is sacred and every tool input and output is hostile until proven otherwise. A server that corrupts its own stream or forwards a credential is worse than no server — protocol correctness and the trust boundary come first, capabilities second.

Use the official SDK (`@modelcontextprotocol/sdk`, or Python `mcp` / FastMCP) — never hand-roll JSON-RPC framing.

- **stdio:** stdout carries ONLY JSON-RPC messages. Route every log, `print`, and startup banner to stderr. One stray `console.log`/`print` desyncs the frame and the client silently disconnects — this is the #1 MCP bug.
- **Streamable HTTP:** bind `127.0.0.1`, never `0.0.0.0`; validate the `Origin` header on every request (DNS-rebinding defense) and use the `Mcp-Session-Id` header for sessions. The old HTTP+SSE transport is deprecated — use Streamable HTTP.
- **Handshake:** implement `initialize`, negotiate `protocolVersion` (echo a version you actually support, e.g. `2025-06-18`), and advertise only capabilities you have wired.
- **Errors are numbers:** return `-32601` method-not-found, `-32602` invalid-params, `-32603` internal, `-32700` parse; app errors live in `-32000..-32099`. A tool that *ran* but failed returns `isError: true` inside its result — NOT a protocol error.
- **Validate inputs** against a strict JSON Schema (zod/pydantic), reject unknown fields. Shell out via argv arrays, never string interpolation; canonicalize paths and confine to a root; block SSRF on any URL-fetching tool.
- **Never pass the client's token upstream** — spec-forbidden confused-deputy risk; the server holds its own credentials. Mark destructive tools with `destructiveHint`, but enforce authorization server-side — annotations are untrusted hints, not a control.

Decision rule: keep the exposed tool set ≤ ~20. Beyond that, model tool-selection accuracy degrades — split into focused servers or hide tools behind a discovery/filter tool. Verify with MCP Inspector (`npx @modelcontextprotocol/inspector <cmd>`) before wiring any real client.

BAD: `print("MCP server ready")` in a stdio server — the banner lands on stdout, garbles the first JSON-RPC frame, and the client reports "failed to parse message" then drops the connection.
GOOD: `print("MCP server ready", file=sys.stderr)` (or `console.error`) — stdout stays pure protocol and the banner still shows in the client's stderr log.

If a check was not run, write "not tested" — never assume a pass you did not observe.

```
═══════════════════════════════════════
MCP SERVER READINESS
═══════════════════════════════════════
Transport:   [stdio | streamable-http]   Bind: [127.0.0.1:PORT | n/a]
Protocol:    [2025-06-18]   SDK: [name vX]
Primitives:  tools:[n] resources:[n] prompts:[n]
Security:    stdout-clean:[pass|fail|n/a]  origin-validated:[pass|fail|n/a]
             input-schemas-strict:[pass|fail]  no-token-passthrough:[pass|fail]
             injection/path/ssrf-safe:[pass|fail]
Inspector handshake: [pass | fail | not tested]
Tool count:  [n]  ([ok | >20 → split/gate])
Verdict:     [SHIP | FIX — reasons]
═══════════════════════════════════════
```

Skip when: you are *calling* an existing MCP server as a client, or just adding one to a client config — this skill builds and hardens the server side.

Gotchas: advertising a capability you never implemented → the client calls it and errors (advertise only what's wired). A sync/blocking call inside an async tool handler stalls the entire server — offload or await. Returning a huge payload inline blows the model's context window — return a resource link or paginate instead.
