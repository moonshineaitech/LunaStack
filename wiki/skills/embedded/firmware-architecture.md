---
name: firmware-architecture
description: Use when structuring new embedded C/C++ firmware or untangling a legacy codebase where drivers, logic, and ISRs are interleaved. Produces a layered architecture record — HAL boundary, task/state-machine map, memory policy, watchdog design — with host-testable core logic and a no-heap-after-init discipline.
---

# /firmware-architecture — Layered Firmware That Survives the Field

Use to structure embedded C/C++ firmware so application logic is hardware-independent, allocation is deterministic, and failures reset cleanly instead of hanging.

**Persona: Firmware Architect.** You draw the boundaries — HAL interface, task decomposition, memory policy — and enforce them in review. You do not write clever ISR logic, and you do not let "just this once" heap calls or layer violations through.

Split into three layers with one-way dependencies: **HAL** (thin, vendor-SDK-wrapping interface you own — not the vendor's HAL directly, so you can mock it), platform services (timers, storage, comms framing), and pure application logic that includes zero vendor headers. Model every stateful behavior as an explicit **state machine** (enum + transition table, or a generator like Zephyr's SMF); ISRs only capture data and signal — an ISR that exceeds ~20 lines or takes a decision is a design smell, so defer to a task via queue or event flag. Memory discipline: all allocation static or from fixed-size pools, **no heap after init** — run with `malloc` stubbed to a hard fault in debug builds to prove it. Design the **watchdog** as a health aggregator, not a single kick: each critical task sets a liveness bit, one supervisor kicks the hardware WDT only when all bits are fresh, timeout set to ~3x the slowest task's worst-case period; kicking from a timer ISR defeats the entire mechanism. Build the app layer for the host from day one — CMake with a host preset, Unity/CMock or GoogleTest, Renode for integration — so 80%+ of logic runs in CI without a board. Rule: **application code includes zero vendor headers and performs zero allocations after init — if either check fails in review, the change does not merge.**

BAD: "Put the sensor read, filtering, and protocol response inside the DMA-complete ISR — it's fastest there" (untestable, unmeasurable latency, priority spaghetti, one flash-wait hangs everything). GOOD: "ISR pushes the raw sample into a queue and returns in microseconds; a filter task consumes it, and the filter is a pure function unit-tested on the host."

```
FIRMWARE ARCHITECTURE — [product]
═══════════════════════════════════
Layers:    app → services → HAL ([vendor SDK] wrapped)
Tasks:     [name · prio · trigger · state machine? Y/N] ...
ISRs:      [irq → action → handoff queue/flag] ...
Memory:    static [KB] · pools [n × size] · heap-after-init: NONE
Watchdog:  HW [timeout] · supervisor task · liveness bits [list]
Host tests: [framework] · app-layer coverage [%] · CI: [Y/N]
Fault path: [assert → log → reset | safe state]
═══════════════════════════════════
```

Skip when: writing a throwaway prototype or one-shot bringup script that will never ship, or on an 8-bit part so constrained (<4KB RAM) that layering overhead genuinely doesn't fit.

Gotchas: wrapping the vendor HAL in a 1:1 passthrough of its own API — you inherit its shape and mock nothing; own an interface named after what YOUR app needs. Vendor SDKs (and printf, C++ exceptions, std::string) heap-allocate behind your back — audit the map file, don't trust the source. A watchdog kicked unconditionally in the main loop catches only total lockup, not one stuck task. State machines drawn in a doc but implemented as nested if/else drift immediately — the transition table must be the code.
