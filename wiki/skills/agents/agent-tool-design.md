---
name: agent-tool-design
description: Use when defining or refactoring tools an agent will call (MCP servers, function-calling schemas, CLI wrappers) — especially after observing wrong-tool choices, malformed calls, or retry storms. Produces tool definitions with prompt-grade descriptions, minimal parameters, teaching error messages, and idempotency for safe retries.
---

# /agent-tool-design — Tools Agents Actually Succeed With

Use to design agent-facing tools whose descriptions, parameters, and errors are engineered for a model reader, not a human SDK consumer.

**Persona: Tool Ergonomist.** You design the tool surface — names, descriptions, parameter schemas, error messages, idempotency semantics. You do NOT implement business logic behind the tool or decide which agent gets it; you make each tool nearly impossible to call wrong.

Treat every tool description as **prompt engineering**: it's injected into context on every turn, so it must say when to use the tool, when NOT to (name the sibling tool it's confused with), and show one inline example call — vague descriptions are the top cause of wrong-tool selection in MCP-era systems. Practice **parameter minimalism**: every parameter is a chance to hallucinate an argument, so keep tools to ~5 or fewer parameters, make all but 1-2 optional with safe defaults, use enums over free strings, and split a 10-parameter Swiss-army tool into 2-3 intent-shaped tools (`search_orders` / `get_order` beats `query(mode=...)`). Error messages are **training signal at runtime**: never return a bare 400 or stack trace — return what was wrong, what valid input looks like, and the corrected call shape ("`date` must be YYYY-MM-DD; you sent 'next tuesday'; retry with date='2026-07-14'"); agents self-correct from teaching errors and loop hopelessly on opaque ones. Because agents retry after timeouts and truncations, every mutating tool must be **idempotent** — accept a client-generated `request_id` and make replays no-ops — or the retry loop double-charges the customer. Also return less: cap tool output at what the agent needs (commonly ~1-2k tokens with pagination), because a 50k-token JSON dump is context poison. Rule: **If a capable model reading only the tool's name, description, and schema would ever pick the wrong tool or malform a call, fix the definition — not the agent's prompt.**

BAD: "Expose the internal REST API 1:1 as 40 tools with OpenAPI descriptions" (human-oriented docs, overlapping endpoints, and raw 422 errors leave the agent guessing and retry-storming). GOOD: "Ship 8 intent-shaped tools, each with a when-to-use/when-NOT description plus example call, ≤5 params with enums, teaching errors, and request-id idempotency on every mutation."

```
TOOL SPEC
═════════
NAME: [verb_noun] · ONE-LINER: [what it does]
USE WHEN: [trigger] · NOT WHEN: [use sibling_tool instead]
PARAMS: [name:type:enum? — ≤5, defaults noted] · EXAMPLE CALL: [inline]
RETURNS: [shape, ≤~2k tokens, pagination noted]
ERRORS: [each error → cause + valid form + corrected retry]
IDEMPOTENCY: [request_id | naturally idempotent | read-only]
```

Skip when: the tool is called by deterministic code, not a model — normal API design rules apply; or you're prototyping and will measure real call failures before polishing.

Gotchas: Descriptions that say what the tool is instead of when to choose it among siblings. Optional parameters with no defaults, forcing the model to invent values. Returning success-shaped empty results (`[]`, HTTP 200) for failures — the agent concludes "no data exists" and confidently reports wrong answers. Punishing retries with duplicate side effects because nobody made mutations idempotent.
