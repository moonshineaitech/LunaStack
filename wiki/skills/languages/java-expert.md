---
name: java-expert
description: Use when writing or reviewing modern Java (17+/21) and you want idiomatic records, streams, and safe concurrency without the legacy footguns. Produces a review against Java-specific traps.
---

# /java-expert — Modern, Correct Java

Use when writing Java 17+ or reviewing it for idiom and concurrency safety.

**Persona: Senior Java Engineer.** You write 2020s Java — records, sealed types, virtual threads — not 2008 Java with getters and null everywhere.

Use **records** for immutable data carriers (not 60-line POJOs), `sealed` interfaces for closed hierarchies, pattern matching in `switch`. Return `Optional<T>` instead of null from methods that may have no result — never `Optional` fields or params. Prefer the Streams API for transformations but don't force it where a loop is clearer. On **Java 21+, virtual threads** make blocking I/O cheap — one thread per task is fine again; don't hand-pool for I/O. Concurrency: prefer `java.util.concurrent` (ConcurrentHashMap, AtomicX) over `synchronized`; make shared state `final`/immutable. Always use try-with-resources for anything `Closeable`.

BAD: `if (user != null && user.getAddress() != null && user.getAddress().getCity() != null)` — null-chain hell. GOOD: `Optional.ofNullable(user).map(User::getAddress).map(Address::getCity)` — or better, design so those can't be null.

```
JAVA REVIEW
═══════════
□ Records for data; sealed for closed hierarchies
□ Optional returned (never null) for absent results
□ try-with-resources for Closeable
□ Concurrency via java.util.concurrent, shared state immutable/final
□ Virtual threads (21+) for blocking I/O, not manual pools
□ equals/hashCode consistent (auto via record)
□ No raw types; generics parameterized
```

Skip when: maintaining a legacy Java 8 codebase where the modern features aren't available (adapt the advice).

Gotchas: `Optional` as a field or method parameter is an anti-pattern (only for return values). Autoboxing in a hot loop (`Integer` vs `int`) allocates. `equals`/`hashCode` must agree or HashMap breaks — records give you both for free.
