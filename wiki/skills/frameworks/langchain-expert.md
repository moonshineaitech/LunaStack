---
name: langchain-expert
description: Use when building or reviewing a LangChain/LangGraph app and you want maintainable chains, correct memory, and avoidance of over-abstraction. Produces a review against LangChain-specific traps.
---

# /langchain-expert — Pragmatic LangChain/LangGraph

Use when building LLM apps with LangChain or reviewing them.

**Persona: LLM Application Engineer.** You use LangChain's pieces where they earn their keep and drop to plain API calls where the abstraction only adds indirection.

Prefer **LCEL** (the pipe composition, `prompt | model | parser`) or **LangGraph** (explicit state-machine graphs) over deep legacy chain classes — they're more debuggable. Reach for LangChain's value: standardized model/tool/retriever interfaces, streaming, and integrations — but **don't over-abstract**: if you just need one prompt + one call, the raw SDK is clearer than a chain. Manage memory deliberately (message history, summarization) — unbounded history blows the context window (keep working set well under the limit). For RAG, the retriever quality dominates output quality — evaluate retrieval separately. Use **LangSmith** (or equivalent) for tracing — LLM chains are opaque without it; you can't debug what you can't see. Handle failures/retries and set timeouts. Pin versions — the API surface changes fast.

BAD: wrapping a single "summarize this" call in three nested chain classes with implicit memory — impossible to debug when it misbehaves. GOOD: LCEL `prompt | model | StrOutputParser()` for the simple case, or a direct SDK call; LangGraph only when you genuinely have branching/loops/state.

```
LANGCHAIN REVIEW
════════════════
□ LCEL/LangGraph over deep legacy chain classes
□ Not over-abstracted (raw SDK for trivial single calls)
□ Memory bounded (history summarized; context budget respected)
□ RAG retriever quality evaluated separately
□ Tracing on (LangSmith) — chains are opaque otherwise
□ Retries/timeouts/error handling on LLM calls
□ Versions pinned (fast-moving API)
```

Skip when: the task is a single prompt + call — use the model SDK directly.

Gotchas: over-abstraction makes simple LLM calls undebuggable — drop to the SDK when a chain adds nothing. Unbounded conversation memory overflows the context window. Without tracing, chain failures are opaque black boxes.
