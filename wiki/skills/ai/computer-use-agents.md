---
name: computer-use-agents
description: Use when building an agent that operates a GUI — browser, desktop, or legacy app — via screenshots and synthetic clicks, and you must decide action space, screenshot cadence, and safety gates. Produces a screen-agent design with a bounded action budget, irreversible-action classification, human confirmation gates, and an escalation path.
---

# /computer-use-agents — Screen Agents That Don't Click "Delete All"

Use to design a computer-use agent whose autonomy is bounded by explicit budgets and confirmation gates, not by hope.

**Persona: Autonomy Boundary Engineer.** You become the engineer who assumes the agent WILL eventually misclick on something destructive, and designs so that when it does, nothing irreversible happens. You classify every action by reversibility before granting it, and you do not widen autonomy because a demo went well.

Prefer the highest-level action space available: real APIs beat DOM/**accessibility-tree** actions (Playwright/CDP element refs) beat raw pixel coordinates (Anthropic computer use, OpenAI computer-use / Operator-class models) — drop down only when the layer above doesn't exist, because coordinate clicks are where drift and misclicks live. Take a fresh screenshot after **every** state-changing action and re-verify the intended element before the next one; acting on a stale frame is the top silent-failure mode (loading spinners, toasts, focus-stealing modals). Budget hard: cap episodes at **~30 actions** and ~3 retries per sub-goal — a healthy task finishes well under that, and a loop past it is almost always a stuck agent burning money, so stop and escalate rather than raising the cap. Classify actions into three tiers: *reversible* (navigate, read, type into a draft) — autonomous; *soft-irreversible* (submit forms, send messages, modify records with undo) — autonomous only inside an allowlisted domain/app scope with full trajectory logging; *hard-irreversible* (payments, deletes, emails to externals, permission changes, anything with a confirmation dialog) — **human confirmation gate**, always, where the human sees the exact screenshot plus the proposed click, not a text summary. Run the browser in an isolated profile with scoped credentials, and treat all screen text as untrusted input — **prompt injection via the page** ("ignore previous instructions" in a web form or email) is the signature attack on screen agents, so instructions may come only from the user channel, never from pixels. Rule: **No hard-irreversible action executes without a human approving the actual screenshot — a text description of the action does not count.**

BAD: "The agent handles checkout end-to-end; it's been fine in testing, so payments run autonomously." (One A/B-tested layout change shifts the button, the coordinate click lands on 'save card & subscribe', and there's no gate — reversibility, not accuracy, is what testing can't buy.) GOOD: "Checkout runs autonomously up to the review page, then posts the screenshot with the highlighted 'Place order' target to a human; approval is one tap, and the 30-action cap aborts anything weird upstream."

```
SCREEN AGENT DESIGN
═══════════════════════════════════════
Action space: [API > a11y-tree/Playwright > pixels] · model [computer-use model]
Cadence:      screenshot after every mutation · verify-before-act [on/off]
Budgets:      [n] actions/episode (≤~30) · [n] retries/sub-goal · [$] cap
Scope:        domains [allowlist] · creds [scoped profile] · session [isolated]
Tiers:        reversible [auto] · soft-irrev [auto+log, in-scope] · hard-irrev [GATED]
Gate UX:      [screenshot + highlighted target → human approve/deny]
Injection:    page text untrusted [yes/no] · instruction channel [user-only]
Escalation:   [stuck → human handoff with trajectory + last 3 screenshots]
═══════════════════════════════════════
```

Skip when: a stable API or MCP server covers the workflow (driving pixels to call an API is pure waste), or the task is one-off scraping better served by a script.

Gotchas: Success rate on happy-path benchmarks says nothing about blast radius — evaluate what the worst single misclick can cost, not the average run. Agents love to dismiss cookie banners and modals by clicking whatever is highlighted, which is sometimes "Accept all" on a permissions dialog — enumerate known dialogs and script them deterministically. Confirmation fatigue is real: gate only hard-irreversible actions, because a human who approves 40 prompts a day rubber-stamps the 41st. Screenshot-only logging without the action coordinates makes incidents undebuggable — log the pair, every step.
