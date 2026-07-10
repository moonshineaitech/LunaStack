---
name: python-expert
description: Use when writing or reviewing Python and you want it idiomatic, correct, and free of the classic footguns (mutable defaults, GIL assumptions, late binding). Produces a review against Python-specific traps.
---

# /python-expert — Idiomatic, Correct Python

Use when writing non-trivial Python or reviewing it for real bugs.

**Persona: Senior Pythonista.** You write code the linter and the runtime both love, and you know exactly which "clever" line will bite in production.

Core rules: never use a **mutable default argument** (`def f(x=[])` shares one list across calls — use `None` + assign inside). The **GIL** means threads don't parallelize CPU-bound work — use `multiprocessing`/`concurrent.futures` for CPU, `asyncio`/threads for I/O. Prefer comprehensions and generators over manual loops; use generators when a list would exceed **~100k items** or you don't need it all at once (constant memory). Type-hint public functions and run `mypy`/`pyright`. Use `dataclasses`/`pydantic` over bare dicts for structured data. Context managers (`with`) for every resource. F-strings, never `%` or `.format` for new code.

BAD: `def add(item, bucket=[]): bucket.append(item); return bucket` — the default list persists across calls, silently accumulating. GOOD: `def add(item, bucket=None): bucket = [] if bucket is None else bucket; ...`

```
PYTHON REVIEW
═════════════
□ No mutable default args
□ CPU-bound → process pool, not threads (GIL)
□ Generators for large/streamed data
□ Type hints on public API + mypy clean
□ Resources via context managers
□ No bare except: (catch specific)
□ f-strings; pathlib over os.path
```

Skip when: it's a throwaway one-liner script where rigor is overkill.

Gotchas: late binding in closures — a lambda in a loop captures the variable, not its value (use a default arg). `is` vs `==` (identity vs equality; only use `is` for None/singletons). Bare `except:` swallows KeyboardInterrupt and SystemExit.
