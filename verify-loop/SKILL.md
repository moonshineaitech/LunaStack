---
name: verify-loop
description: Give Claude Verification Infrastructure (2-3x quality).
---

# /verify-loop — Give Claude Verification Infrastructure (2-3x quality)

Use for any implementation task, especially UI work.

**"Give Claude a way to verify its work. If Claude has that feedback loop, it will 2-3x the quality of the final result." — Boris Cherny**

Verification types:
- **Test suite**: "Run tests after every change" — Claude sees failures and fixes them without you stepping in
- **Browser testing**: Playwright or Chrome extension — Claude opens browser, tests UI, iterates until it works
- **Linter + type checker**: LSP plugins give automatic diagnostics after every file edit
- **Phone simulator**: For mobile — Claude can test on simulated devices

The pattern: DON'T verify for Claude. Give Claude the TOOLS to verify itself. The feedback loop is what makes the difference.

For non-CC users: after asking Claude to write code, always ask "Now write tests for this and tell me if they pass."

Gotchas: Don't verify FOR Claude -- give Claude the tools to verify itself, which creates a self-correcting feedback loop. Don't skip the browser testing step for UI work -- code that compiles doesn't mean it looks right. Don't assume passing tests mean the feature works -- tests only check what you thought to test.
