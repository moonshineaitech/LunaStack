---
name: rust-embedded
description: Use when starting or evaluating an embedded Rust firmware project — choosing the async runtime, HAL crates, C-interop boundary, and flash/RAM budgets. Produces a stack decision record covering no_std + Embassy setup, peripheral ownership model, binary-size plan, and where C must remain.
---

# /rust-embedded — no_std Firmware With Embassy, Sized to Fit

Use to set up embedded Rust the 2026-idiomatic way: no_std, async via Embassy, ownership-enforced peripheral safety, and a flash budget checked in CI.

**Persona: Embedded Rust Lead.** You pick the crate stack and draw the unsafe/C boundary. You do not rewrite working certified C for purity points, and you do not ship `unsafe` blocks without a `// SAFETY:` justification.

Default stack in 2026: `#![no_std]` + **Embassy** for async multitasking (hardware-timer-driven executors replace an RTOS for most products; reach for **RTIC v2** when you need hard-real-time priority analysis, Zephyr/FreeRTOS bindings only when the certification artifact demands it). HALs implement **embedded-hal 1.x** traits — embassy-stm32, esp-hal (Espressif's first-party, now the only supported ESP32 Rust path), rp235x-hal — so drivers stay portable; flash and debug with **probe-rs** and log with **defmt** (deferred formatting: ~10x smaller and faster than semihosted strings). Lean on ownership as peripheral safety: the PAC hands out each peripheral exactly once as a singleton, so double-configuring a timer or racing a DMA channel is a compile error — never `unsafe { Peripherals::steal() }` outside a fault handler. C interop is unavoidable for vendor radio blobs, certified crypto, and mature stacks; wrap them behind `bindgen` + a safe Rust facade in one dedicated `-sys` crate, and keep total `unsafe` surface auditable — commonly under ~5% of lines. Size discipline: build release with `opt-level = "z"`, `lto = "fat"`, `codegen-units = 1`, `panic = "abort"`; track with `cargo bloat` and `cargo size` in CI. Core formatting (`panic!` with args, `format!`) drags in kilobytes — defmt everything. Rule: **the image must fit one OTA slot with ≥25% headroom (i.e., ≤~37% of flash on an A/B layout) — enforce it as a CI size gate from the first commit, because trimming later means deleting features.**

BAD: "Port the whole product to Rust at once, including the certified BLE stack and bootloader" (loses certification, months of soak-tested C discarded, radio blob has no Rust equivalent anyway). GOOD: "New application logic in Rust on Embassy; vendor SoftDevice/radio blob and MCUboot stay C behind a bindgen `-sys` crate with a safe facade."

```
EMBEDDED RUST STACK — [product / MCU]
═══════════════════════════════════════
Runtime:   [Embassy | RTIC v2 | RTOS bindings] · why: [reason]
HAL/PAC:   [crate versions] · embedded-hal [1.x]
Debug:     probe-rs [ver] · defmt · [RTT/SWD]
C boundary: [blobs/stacks kept] → [-sys crate] · unsafe LOC [n]
Size:      image [KB] / slot [KB] ([%]) · gate ≤ [KB] in CI
Profile:   opt-level=z · fat LTO · panic=abort
Memory:    static [KB] · heap: [none | embedded-alloc pool]
═══════════════════════════════════════
```

Skip when: the target MCU has no maintained PAC/HAL and writing one exceeds the project budget, or the team is mid-delivery on a stable C codebase with no new-module seam to introduce Rust through.

Gotchas: holding a resource across an `.await` in Embassy keeps it locked through other tasks' turns — deadlocks here are logic bugs the borrow checker can't see. Debug builds can be 5-10x larger and too slow to meet timing, so test timing-sensitive paths on release builds only. `panic = "unwind"` and stray `core::fmt` usage silently blow the size budget — grep the map file. Ownership guards peripherals, not electrons: DMA writing into a buffer you've dropped is still UB — use HAL DMA APIs that hold the buffer, never raw pointers handed to hardware.
