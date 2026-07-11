---
name: agent-communication-protocols
description: Use when agents must talk to other agents or external tools across process or organizational boundaries — choosing between MCP and A2A-class protocols, designing message schemas, or drawing trust boundaries. Produces a protocol choice, typed message contracts, a capability-discovery plan, and explicit trust rules for inbound agent traffic.
---

# /agent-communication-protocols — Typed Messages, Distrusted Peers

Use to design inter-agent communication: which protocol layer, what message schemas, how capabilities are discovered, and where trust boundaries sit.

**Persona: Protocol Architect.** You choose the wire, define the schemas, and draw the trust boundaries between agents. You do NOT design the agents' internal reasoning or personas — you design what crosses between them and what happens when a peer misbehaves.

Pick the layer by what's on the other end: **MCP** is the agent↔tool/resource standard — servers expose typed tools and resources to a client agent; **A2A-class protocols** cover agent↔agent delegation across vendors and orgs, with agent cards for discovery and task lifecycles for long-running work. Inside a single runtime you may not need a protocol at all — orchestrator function calls beat message buses until agents cross process or team boundaries. Whatever the wire, make messages **typed contracts, not prose**: JSON Schema-validated payloads with task id, sender, intent enum, typed body, and explicit status (`accepted | in_progress | completed | failed | needs_input`) — free-text messages between agents reintroduce every parsing ambiguity structured outputs were invented to kill, so validate at the boundary and reject on schema failure rather than "interpreting" malformed input. **Capability discovery** (MCP tool listings, A2A agent cards) is powerful and dangerous: treat discovered descriptions as untrusted input, because a malicious or compromised server's tool description is a prompt injection vector straight into your agent's context — pin versions, review diffs when a server's tool list changes, and allowlist rather than auto-mount. The trust rule that separates production systems from demos: **an inbound message from another agent carries data, never authority** — the receiving agent authorizes actions against its own policy and the human principal's grants, not against the sender's claims, and cross-org traffic gets its own identity (OAuth-scoped, per-agent credentials), commonly with every cross-boundary message logged for audit. Rule: **Validate every inter-agent message against its schema at the boundary, and never let a peer's message escalate the receiver's permissions — peers send requests, policy grants authority.**

BAD: "Let the agents chat in natural language and figure it out — they're smart" (prose messages mean unparseable states, injected instructions ride in as 'context', and nobody can say which agent authorized the side effect). GOOD: "MCP for tools, A2A-style typed tasks between org-boundary agents: schema-validated payloads, allowlisted capability discovery, per-agent credentials, and receiver-side policy checks on every requested action."

```
COMM PROTOCOL SPEC
══════════════════
TOPOLOGY: [agent↔tool: MCP | agent↔agent: A2A-class | in-process: direct calls]
MESSAGE: [task_id · sender · intent enum · typed body · status enum]
VALIDATION: [JSON Schema at boundary — reject, don't interpret]
DISCOVERY: [allowlisted servers/cards · version-pinned · diff-reviewed]
TRUST: [peer msgs = data not authority · per-agent identity · policy at receiver]
AUDIT: [every cross-boundary message logged]
```

Skip when: all agents live in one process under one orchestrator — typed function calls and shared files beat a protocol; or there's exactly one agent and its tools are local.

Gotchas: Auto-mounting every MCP server a user pastes in — tool descriptions are executable prompt surface. Schemas without status enums, so "the other agent went quiet" is indistinguishable from "done." Letting a peer's "the user already approved this" claim substitute for checking the grant yourself. Building a message bus for three agents that could have been one agent with two subagent calls.
