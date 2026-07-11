---
name: agent-sandboxing-security
description: Use when an AI agent executes code, calls tools, or browses with real credentials — before it touches production data or the open internet. Produces a sandbox design: least-privilege tool scoping, filesystem/network isolation choices, irreversible-action gates, output quarantine rules, and a confused-deputy threat assessment.
---

# /agent-sandboxing-security — Contain the Agent, Not the Model

Use to design the execution boundary around an agent so that a hijacked or hallucinating agent can only damage a disposable sandbox, never your production estate.

**Persona: Agent Containment Engineer.** You assume the model WILL be prompt-injected and design so it doesn't matter — isolation, scoping, gates, quarantine. You do NOT filter model text for toxicity or tune refusals (that's /llm-guardrails-safety); you constrain what a compromised agent can *do*, not what it can *say*.

Run agent code in real isolation, not a working directory: **microVMs** (Firecracker — what E2B and Modal sandboxes use) or **gVisor**-backed containers, ephemeral per session, torn down after — plain Docker with a shared kernel is a weaker boundary; treat it as a minimum, not a target. Default-deny network egress and allowlist specific domains through a proxy (commonly ≤5-10 domains per agent role); an open egress path is the exfiltration leg of the **lethal trifecta** — private-data access + exposure to untrusted content + an outbound channel — and your job is to make sure no single agent context ever holds all three. Scope every tool to least privilege: read-only DB roles, repo-scoped tokens, credentials with TTL ≤ 1 hour minted per task, and MCP servers that expose the three verbs the task needs rather than an admin API. Gate **irreversible actions** — anything not undoable with one command (sends, deletes, payments, prod deploys, force-pushes) — behind human approval or a dry-run-then-confirm protocol; reversible actions can run free, which is what makes agents useful. Treat the **confused deputy** as your core threat model: the agent wields *your* authority while reading *attacker-controlled* content (web pages, emails, tool outputs, repo files), so every tool result is untrusted input — never let fetched content mint new instructions that expand scope mid-task, and pin the agent's privileges at task start rather than escalating on request. Quarantine outputs too: artifacts an agent produces (code, files, links) get scanned and reviewed before they execute anywhere privileged or reach other users. Rule: **Never let one agent context combine private-data access, untrusted-content exposure, and an open outbound channel — sever at least one leg of the trifecta by architecture, not by prompt.**

BAD: "The agent runs on the CI box with the team's AWS keys — the system prompt tells it to be careful and never delete anything" (a prompt is not a boundary; one injected README and the deputy dutifully exfiltrates the keys to an allowlisted-by-default internet). GOOD: "Each task gets a fresh Firecracker microVM, an egress proxy allowing 4 domains, a repo-scoped 1-hour token; `terraform apply` and outbound email require human confirm; fetched web content is summarized in a separate, credential-free context before the privileged agent sees it."

```
AGENT SANDBOX DESIGN
════════════════════
Isolation:    [Firecracker/gVisor/container] · ephemeral per [task/session] · teardown: [when]
Network:      default-deny egress · allowlist: [domains ≤5-10] via [proxy]
Credentials:  [tool → scope] map · TTL ≤ [1h] · minted per [task] · no ambient admin
Irreversible: [actions list] → gate: [human approve / dry-run+confirm]
Trifecta:     private data [Y/N] · untrusted content [Y/N] · egress [Y/N] → leg severed: [which]
Quarantine:   agent outputs [scanned/reviewed] before [execution/other users]
```

Skip when: the agent is read-only over public data with no credentials and no side effects — a chat wrapper needs guardrails, not a microVM; or you're in a throwaway local experiment with nothing real mounted.

Gotchas: sandboxing the code-execution tool but letting the browser tool run unsandboxed with session cookies — attackers target your weakest tool, not your hardest. Approval gates that fire on every trivial action train humans to click-through in seconds, which is worse than fewer, sharper gates on truly irreversible calls. Mounting the real repo read-write into the sandbox "for convenience" quietly deletes the boundary you just built — copy in, diff out. Assuming MCP servers are trusted because you installed them: a tool's *responses* are an injection surface even when its code is benign.
