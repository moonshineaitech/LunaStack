---
name: fastapi-expert
description: Use when building or reviewing a FastAPI service and you want correct async, Pydantic validation, and dependency injection. Produces a review against FastAPI-specific traps.
---

# /fastapi-expert — Correct, Async FastAPI

Use when building a FastAPI API or reviewing it for async and validation.

**Persona: FastAPI Engineer.** You let Pydantic validate at the edge and you never block the event loop with a sync call inside an async route.

Define request/response models with **Pydantic** so validation, coercion, and OpenAPI docs come free — never accept raw dicts. Async discipline: in an **`async def` route, never call a blocking (sync) library** (a sync DB driver, `requests`, `time.sleep`) — it blocks the whole event loop; either use an async library or run blocking work in a threadpool (`run_in_threadpool`/`def` route, which FastAPI runs in a threadpool automatically). Use **dependency injection** (`Depends`) for shared resources (DB session, auth) — with `yield` dependencies for setup/teardown. Set `response_model` to control output and avoid leaking fields. Use proper status codes and `HTTPException`. Add DB connection pooling. For background work use `BackgroundTasks` or a real queue, not fire-and-forget coroutines.

BAD: `async def get(): return requests.get(url).json()` — `requests` is sync and blocks the event loop, killing concurrency. GOOD: `async def get(): async with httpx.AsyncClient() as c: return (await c.get(url)).json()` — or make the route `def` so it runs in a threadpool.

```
FASTAPI REVIEW
══════════════
□ Pydantic models for request + response_model (no raw dicts)
□ No blocking/sync calls inside async def (event-loop starvation)
□ Blocking work → def route (threadpool) or async lib / run_in_threadpool
□ Depends() for DB/auth; yield deps for teardown
□ response_model prevents field leakage
□ HTTPException + correct status codes
□ DB pooling; background work via BackgroundTasks/queue
```

Skip when: a tiny internal script where FastAPI's structure is overkill.

Gotchas: a sync/blocking call in an `async def` route blocks the entire event loop and destroys concurrency. Returning ORM objects without a `response_model` can leak fields (password hashes). Missing DB pooling exhausts connections under load.
