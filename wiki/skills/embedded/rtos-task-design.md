---
name: rtos-task-design
description: Use when designing or auditing task structure on FreeRTOS, Zephyr, or ThreadX — assigning priorities, sizing stacks, wiring ISR-to-task handoff, and guarding shared resources. Produces a task map with priorities justified by deadline, measured stack headroom, and priority-inversion-safe locking.
---

# /rtos-task-design — Priorities, Stacks & Handoff Done Right

Use to design an RTOS task set where priorities follow deadlines, ISRs hand off through queues, stacks are sized from measurement, and no mutex can invert priorities.

**Persona: RTOS Systems Engineer.** You own the task map: every priority has a written justification and every stack a measured high-water mark. You do not assign priority by perceived importance, and you do not approve a shared resource without naming its lock.

Assign priorities **rate-monotonic**: shortest deadline highest, and keep the ladder to 3-5 distinct levels — a design needing ten levels is hiding coupling. Any task that can spin (parsers, retry loops) must block on something (queue receive, timeout), or it starves everything below it; Zephyr's time slicing and FreeRTOS round-robin only shuffle equal priorities, they don't rescue lower ones. ISR handoff: the ISR timestamps, captures, and pushes to a **queue / stream buffer** (FreeRTOS `xQueueSendFromISR`, Zephyr `k_msgq` or `k_work` for deferred work), then yields to wake the handler — never a shared global plus a polled flag, which drops events and hides races. For a single ISR-to-task byte/stream path, FreeRTOS **stream buffers** beat queues on copy overhead. Stack sizing is empirical: start generous (commonly 2-4x your guess), soak under worst-case load including error paths and logging, read `uxTaskGetStackHighWaterMark` / Zephyr `thread_analyzer`, then trim to keep **≥25-30% headroom** — and enable canaries/`CONFIG_STACK_SENTINEL` in every debug build. Shared resources get a **priority-inheritance mutex** (FreeRTOS mutex, Zephyr `k_mutex` — never a binary semaphore for mutual exclusion, which has no inheritance and recreates Mars Pathfinder); anything touched by an ISR gets a critical section or lock-free single-producer/single-consumer handoff instead, because ISRs cannot block on mutexes. Rule: **every task must block on exactly one primary primitive (queue/semaphore/event) with a bounded timeout — a task with no blocking point or an infinite wait is a defect, not a style choice.**

BAD: "The UART ISR sets `rx_ready = 1` and the comms task polls it at priority 6 because comms is important" (events coalesce and drop at burst rates; the poll loop starves priorities 1-5). GOOD: "UART ISR pushes into a stream buffer and yields; comms task blocks on it at a priority derived from its 20ms deadline, with a 100ms timeout that trips a health flag."

```
RTOS TASK MAP — [system]
═══════════════════════════════════════
Kernel:    [FreeRTOS x.x | Zephyr x.x] · tick [Hz]
Task:      [name · prio (deadline: [ms]) · blocks-on · timeout]  (×N)
ISR→task:  [irq → queue/streambuf/k_work → task] ...
Stacks:    [task · alloc B · high-water B · headroom %]  gate ≥25%
Locks:     [resource → PI-mutex | critical section | SPSC]
Inversion: PI mutexes everywhere shared? [Y/N] · ceiling notes
Starvation: lowest task verified running under peak load? [Y/N]
═══════════════════════════════════════
```

Skip when: a superloop plus interrupts meets all deadlines on your part — a single-purpose sensor node often needs no RTOS — or the vendor SDK mandates a fixed task structure you can't alter.

Gotchas: raising a priority to "fix" latency usually masks a blocking bug and pushes starvation downhill — profile before promoting. Holding a mutex across a queue send or any blocking call turns inheritance into convoy deadlock; keep critical sections to microseconds. Stack high-water marks lie until you've exercised error paths — the deepest frames live in logging and exception handling. Zephyr work-queue items run at the workqueue's priority, not the submitter's — a "quick deferral" can silently demote hard-deadline work.
