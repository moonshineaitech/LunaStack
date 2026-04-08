---
name: sandbox-fallback
description: Use when running in restricted environments (CI, sandboxed containers, etc.).
---

# /sandbox-fallback — Detect and Adapt to Sandbox Limitations

Use when running in restricted environments (CI, sandboxed containers, etc.).

Different platforms have different sandboxes:
- Codex App: read-only environment detection, worktree-safe behavior
- Linux sandbox: might not have all tools
- macOS sandbox: System Integrity Protection blocks some operations

```
SANDBOX DETECTION
═════════════════
Read-only filesystem:   [yes/no — adapt: write to /tmp]
Network blocked:        [yes/no — adapt: skip network-dependent tests]
Shell limited:          [yes/no — adapt: use only basic commands]
Tool subset:            [list of unavailable tools]

ADAPTATION STRATEGY
  [Specific adjustments for this sandbox]
```

Gotchas: Don't assume /tmp is writable in all sandboxes -- some environments restrict all writes. Don't skip network tests without logging why -- silent failures in sandboxed environments hide real bugs. Don't write sandbox-specific workarounds in production code -- use adapter patterns so sandbox adaptations don't leak into normal operation.
