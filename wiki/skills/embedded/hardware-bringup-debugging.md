---
name: hardware-bringup-debugging
description: Use when bringing up a new board revision or debugging hardware that misbehaves — first power-on, dead or flaky peripherals, works-on-devkit-fails-on-board mysteries. Produces a bringup log with rail measurements, a halved-hypothesis debug trail, and an errata check, in strict order from power to peripherals.
---

# /hardware-bringup-debugging — Rails First, Then Everything Else

Use to bring up new hardware in a disciplined order — power, clocks, debug access, then one peripheral at a time — and to debug failures by instrumented bisection instead of printf and hope.

**Persona: Bringup Engineer.** You verify each layer before trusting the one above it and write down every measurement. You do not flash application firmware onto an unverified board, and you do not blame software until the electrons check out.

Order is non-negotiable: **power rails first** — before any firmware, measure every rail's voltage, ripple, and sequencing, and check total current against expectation; a rail off by more than ~5%, or board current deviating more than ~30% from the devkit/estimate, stops everything until explained (a warm regulator or short found now saves a smoked MCU later). Then verify the crystal actually oscillates and the SWD/JTAG connection enumerates (`probe-rs info`, J-Link, or OpenOCD reading the device ID is the true "hello world" — blinky comes after). Debug with visibility tools, not print statements: a **logic analyzer** (Saleae-class) on I2C/SPI/UART shows what actually crossed the wire versus what firmware believes it sent, hardware breakpoints via SWD beat printf that itself perturbs timing, and a scope belongs on any signal integrity suspicion (ringing on clock edges, sagging rails under radio TX bursts). When something fails, **isolate by halves**: split the system at a boundary — known-good firmware on new board vs new firmware on devkit, peripheral driven by a bus pirate vs by your driver, board powered from bench supply vs its own regulator — and each split must cut the hypothesis space roughly in half; three or four splits corner most faults. Before debugging any "silicon bug," read the **errata sheet** — I2C peripherals that lock the bus, ADC channels that crosstalk, and silicon-revision-specific workarounds are documented, and an hour there routinely saves a week. The devkit trap: devkits ship with pull-ups, load caps, level shifters, and clean power your board may lack — when devkit works and your board doesn't, diff the schematics for boot straps, crystal load capacitance, missing decoupling, and floating enables before touching code. Rule: **never advance a layer until the one below is measured and logged — no firmware until rails pass, no drivers until SWD enumerates, no application until each peripheral answers on the analyzer.**

BAD: "Board arrived, flashed the app, nothing on UART — spent two days adding printfs" (the 1.8V rail was sagging to 1.4V under load; no amount of logging runs on brownout). GOOD: "Bench supply with current limit at 1.5x expected, logged all rails within 3%, SWD ID read OK, then brought up UART, I2C, SPI one at a time with the analyzer confirming each transaction."

```
BRINGUP LOG — [board rev]
═══════════════════════════════════════
Rails:   [name · expected V · measured V · ripple mV · PASS/FAIL] ...
Current: [measured mA] vs [expected mA] ([Δ%], gate ±30%)
Clock:   [XTAL Hz · scoped? Y/N] · Debug: SWD ID [value] via [probe]
Bringup: [peripheral · driven-by · analyzer-verified · status] ...
Deltas vs devkit: [straps/pulls/caps differences found]
Errata:  [doc rev checked · applicable items]
Open faults: [symptom · halves tried · hypothesis remaining]
═══════════════════════════════════════
```

Skip when: debugging pure logic on a proven board revision with healthy hardware history (that's a software debug loop), or a production line failure with an established test fixture — follow the fixture's fault tree first.

Gotchas: probing an undecoupled clock or reset line with a 10x scope probe can change the behavior you're measuring — know your probe's loading. First prototypes deserve current-limited bench power, never USB straight in; USB happily delivers the amps that turn a solder bridge into a burned trace. "It worked once then died" points at sequencing or thermal, not code — re-measure rails warm. Trusting the schematic over the physical board wastes days: assembly swaps, wrong-value passives, and rotated parts are found with a meter and a microscope, not a diff.
