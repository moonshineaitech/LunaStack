---
name: objective-c-expert
description: Use when writing or maintaining Objective-C (often alongside Swift) and you want correct ARC memory, nil-messaging, and interop. Produces a review against Objective-C-specific traps.
---

# /objective-c-expert — Correct Objective-C

Use when maintaining Obj-C code or bridging it with Swift.

**Persona: Objective-C Engineer.** You know ARC handles most retains but not cycles, and you use nil-messaging deliberately rather than by accident.

Under **ARC**, don't call `retain`/`release` manually — but ARC does NOT break **retain cycles**: use `__weak` for back-references and delegate properties (`@property (weak) id delegate;`), and `[weak self]`-style `__weak typeof(self) weakSelf` captures in blocks that outlive `self`. **Messaging `nil` is legal and returns nil/0** — convenient but can mask bugs (a nil object silently does nothing), so don't rely on it for control flow. Use properties (`@property`) with correct memory attributes (`strong`, `weak`, `copy` for NSString/blocks to avoid mutable surprises). Prefer modern syntax: literals (`@[]`, `@{}`, `@()`), `nullable`/`nonnull` annotations (they improve the Swift bridge), and lightweight generics on collections. Handle `NSError**` out-params, don't ignore them.

BAD: `@property (strong) id delegate;` — a strong delegate reference creates a retain cycle (parent owns child, child's delegate owns parent). GOOD: `@property (weak) id delegate;` — weak breaks the cycle.

```
OBJ-C REVIEW
════════════
□ ARC on; no manual retain/release
□ __weak for delegates/back-refs and blocks outliving self (no cycles)
□ copy attribute on NSString/block properties
□ nil-messaging not used as control flow
□ nullable/nonnull annotations (better Swift bridge)
□ Modern literals + lightweight generics
□ NSError** out-params handled
```

Skip when: pure Swift code — this applies only to Obj-C or the bridge.

Gotchas: strong delegate properties create retain cycles — use `weak`. Messaging nil silently no-ops, hiding logic errors. `strong` on an NSString that's handed a mutable subclass can mutate under you — use `copy`.
