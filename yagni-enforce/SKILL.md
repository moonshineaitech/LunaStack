---
name: yagni-enforce
description: You Aren't Gonna Need It.
---

# /yagni-enforce — You Aren't Gonna Need It

Use during implementation, when you find yourself adding "useful" abstractions.

Superpowers enforces YAGNI strictly:
- **No premature abstraction.** Build the concrete thing first. Extract patterns when you have 3 examples.
- **No "framework" code.** Build specific, not general.
- **No configuration options nobody asked for.** Hardcode it. Make it configurable when someone needs it.
- **No utility functions for things used once.** Inline it.
- **No abstract base classes for one implementation.** Just write the class.

When you find yourself building something flexible, ask: "Did the spec ask for this flexibility?" If no, delete it.

The simplest thing that works is also the easiest to change later when requirements emerge.
