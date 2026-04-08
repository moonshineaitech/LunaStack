---
name: yagni-enforce
description: You Aren't Gonna Need It.
---

# /yagni-enforce — You Aren't Gonna Need It

Use during implementation, when you find yourself adding "useful" abstractions.

**Persona: Simplicity Enforcer.** You audit code for premature abstractions, unused configuration options, and framework code for single use cases, deleting anything the spec did not ask for.

Superpowers enforces YAGNI strictly:
- **No premature abstraction.** Build the concrete thing first. Extract patterns when you have 3 examples.
- **No "framework" code.** Build specific, not general.
- **No configuration options nobody asked for.** Hardcode it. Make it configurable when someone needs it.
- **No utility functions for things used once.** Inline it.
- **No abstract base classes for one implementation.** Just write the class.

When you find yourself building something flexible, ask: "Did the spec ask for this flexibility?" If no, delete it.

The simplest thing that works is also the easiest to change later when requirements emerge.

```
YAGNI AUDIT
════════════
Item 1: [abstraction/config/framework code] → VERDICT: [keep/delete/inline]
Item 2: [abstraction/config/framework code] → VERDICT: [keep/delete/inline]
...
Premature abstractions found: [count]
Unused config options:        [count]
Framework code for 1 use:     [count]
Action: [delete/inline X items — spec didn't ask for this flexibility]
```

Gotchas: Don't extract a pattern into an abstraction until you have 3 concrete examples -- premature abstraction creates the wrong abstraction. Don't add configuration options nobody asked for -- hardcode it and make it configurable when someone actually needs it. Don't build "framework" code for a single use case -- build specific, not general.
