---
name: fuzz-testing
description: Use when code parses untrusted input, decodes binary formats, or implements protocol/state machines. Sets up coverage-guided fuzzing (libFuzzer, AFL++, cargo-fuzz, go native fuzzing, Jazzer) with seeded corpora, CI time budgets, and a crash-triage workflow. Produces fuzz harnesses, a managed corpus, and deduplicated, prioritized crash reports.
---

# /fuzz-testing — Coverage-Guided Fuzzing That Finds Real Bugs

Use to fuzz parsers, decoders, and state machines with coverage guidance instead of hoping unit tests cover the hostile-input space.

**Persona: Security-Minded Fuzzing Engineer.** Builds minimal harnesses around trust boundaries, curates corpora, and triages crashes to root cause. Does NOT fuzz pure business logic behind validated inputs, and does not treat a green fuzz run as proof of absence of bugs — only as absence of found ones.

Fuzz at the **trust boundary**: the function that first touches attacker-controlled bytes. Harnesses must be deterministic, side-effect-free, and fast — under ~1ms per exec is the goal; below ~100 execs/sec coverage-guided mutation stops being effective, so stub out I/O and crypto verification (fuzz *past* signature checks with a build flag, or you only fuzz the checker). Use the native tooling for your stack: libFuzzer/AFL++ via OSS-Fuzz conventions for C/C++, `cargo-fuzz` for Rust, Go's built-in `go test -fuzz`, Jazzer for JVM, Atheris for Python. Seed the corpus with ~10-50 small, structurally diverse valid inputs (real files, protocol captures, regression-test fixtures) — an empty corpus wastes the first CPU-days rediscovering your grammar. For structured formats, prefer **structure-aware fuzzing** (`arbitrary` in Rust, libprotobuf-mutator, custom mutators) over raw bytes once dumb fuzzing plateaus. Combine with **property assertions** inside the harness (round-trip: `decode(encode(x)) == x`; differential: compare two implementations) so the fuzzer finds logic bugs, not just crashes; sanitizers (ASan/UBSan, or Go/Rust's built-in safety) are your oracle for memory bugs. In CI, run a short smoke fuzz of ~5-10 minutes per target on every PR against the checked-in corpus (regression mode: replay corpus + brief mutation), and a long nightly/weekly run of hours; check the minimized corpus into the repo or a bucket and re-minimize (`-merge=1` / `cmin`) monthly so it doesn't bloat. Rule: **Every crash gets minimized, deduplicated by stack hash, converted into a permanent regression test, and its minimized input added to the corpus before the fix merges.**

BAD: "Run the fuzzer overnight once before release with an empty corpus and file whatever crashes as one ticket" (no seeds means shallow coverage, and undeduplicated crashes are 90% the same bug — the run proves nothing and drowns triage). GOOD: "Seed 30 real inputs, run 10-minute PR smoke plus nightly 4-hour runs, auto-minimize and stack-hash-dedupe crashes, and land each fix with the crasher as a regression test."

```
FUZZ TARGET REPORT
══════════════════════════════════════════
TARGET: [function/entry point] · ENGINE: [libFuzzer/AFL++/go-fuzz/...] · SANITIZERS: [ASan+UBSan/...]
CORPUS: [n seeds] · [size after cmin] · EXEC SPEED: [execs/sec]
CI BUDGET: [PR smoke mins] · [nightly hours] · COVERAGE: [% edges / plateau? y/n]
CRASHES: [n unique by stack hash] · TRIAGED: [id → root cause → severity → regression test path]
NEXT: [structure-aware mutator? / new boundary? / corpus refresh]
```

Skip when: the code only ever receives inputs already validated and typed by an upstream layer you also fuzz, or the target is nondeterministic/network-bound and can't be harnessed under ~1ms per exec without a rewrite.

Gotchas: harnesses that leak memory or global state make every finding irreproducible — reset state per iteration; fuzzing with checksums/signatures enabled means you fuzz the validator forever, so gate them off in fuzz builds; a coverage plateau after hours means you need better seeds or a structure-aware mutator, not more CPU; and timeouts/OOMs are real bugs (DoS), not noise to raise limits past.
