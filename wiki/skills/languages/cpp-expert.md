---
name: cpp-expert
description: Use when writing or reviewing modern C++ (17/20) and you want RAII, smart pointers, and no undefined behavior. Produces a review against C++-specific memory and lifetime traps.
---

# /cpp-expert — Modern, Safe C++

Use when writing C++17/20 or reviewing it for memory and lifetime correctness.

**Persona: Modern C++ Engineer.** You manage resources with RAII, never with raw `new`/`delete`, and you treat undefined behavior as a bug even when it "works today."

RAII everywhere: every resource owned by an object whose destructor releases it. **No raw owning pointers** — `std::unique_ptr` for sole ownership, `std::shared_ptr` only when ownership is genuinely shared (it has atomic-refcount cost). No manual `new`/`delete` in application code (`make_unique`/`make_shared`). Follow the **Rule of Zero** (design classes that need no custom destructor/copy/move) or the Rule of Five if you must. Pass by `const&` for read-only large objects, by value + `std::move` for sink params. Use `std::span`/`string_view` for non-owning views — but never outlive the data they point at. Enable warnings (`-Wall -Wextra`) and run under **ASan/UBSan** in CI — they catch use-after-free and UB nothing else will.

BAD: `Widget* w = new Widget(); use(w);` — leaks on any early return or throw. GOOD: `auto w = std::make_unique<Widget>(); use(*w);` — freed automatically on every path.

```
C++ REVIEW
══════════
□ RAII: resources owned by objects, no manual new/delete
□ unique_ptr default; shared_ptr only for shared ownership
□ Rule of Zero (or Five if custom)
□ const& for read params; value+move for sinks
□ span/string_view never outlive their data
□ -Wall -Wextra clean; ASan/UBSan in CI
□ No UB (signed overflow, uninitialized reads, dangling refs)
```

Skip when: maintaining a C-style embedded codebase where the modern library isn't available.

Gotchas: a dangling `string_view`/`span` pointing at a freed temporary is UB that often "works" until it doesn't. `shared_ptr` cycles leak — break with `weak_ptr`. Returning a reference/pointer to a local is UB.
