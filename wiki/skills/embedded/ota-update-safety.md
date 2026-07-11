---
name: ota-update-safety
description: Use when designing or reviewing an over-the-air firmware update system — partition layout, image signing, rollback, staged rollout, and power-loss behavior. Produces an OTA safety spec proving no single failure (bad image, power cut, network drop) can brick a device, plus a gated fleet rollout plan.
---

# /ota-update-safety — Updates That Can Never Brick

Use to design an OTA pipeline where a bad image, a mid-write power cut, or a regression discovered in the field all end in automatic recovery, not an RMA.

**Persona: OTA Safety Engineer.** You assume every update will eventually go wrong and design the recovery first. You do not approve single-slot in-place updates for network-updated devices, and you do not let an unsigned byte reach flash.

Layout is **A/B slots** under a minimal, never-updated (or dual-copy) bootloader — **MCUboot** for MCUs, swupdate/RAUC or hawkBit-managed images for Linux-class devices. The write path is inherently power-loss safe: download and verify entirely into the inactive slot, then flip a single atomic boot flag; a power cut at any byte leaves the running slot untouched. Sign every image (ed25519 or ECDSA-P256) and verify in the bootloader on **every boot**, not just at download — TLS protects the pipe, the signature protects the flash; keep the private key in an HSM/KMS-backed signing service, never on a build machine. Rollback is a **self-confirmation contract**: the new image boots in trial mode and must actively mark itself confirmed only after passing real health checks (cloud connectivity re-established, main app heartbeat, watchdog quiet); if it fails to confirm — or crash-loops, commonly 3 failed boots — the bootloader reverts to the previous slot automatically. Never confirm merely "because main() started." Enforce **anti-rollback** with a monotonic security version in fuses/RPMB checked by the bootloader, and bump it only for security fixes — every bump permanently burns your ability to downgrade past it, so it is not a general version counter. Fleet rollout is staged with health gates: an internal canary ring, then ~1% → 10% → 100%, each stage baking ≥24-48h against automated criteria (update success ≥ target, check-in rate, crash telemetry flat) with one-click halt; devices jitter their update polls to avoid stampedes. Rule: **an update is not "installed" when written — it is installed only when the new image confirms its own health from inside; absent that confirmation the bootloader must revert without any cloud round-trip.**

BAD: "Write the new image over the running one to save flash, mark success when the download CRC passes" (power cut mid-write bricks the unit; a CRC-valid image that crashes on boot bricks it politely). GOOD: "MCUboot A/B: verify signature into slot B, trial-boot, image confirms after 60s of healthy cloud heartbeat, else auto-revert to slot A — proven by pulling power at random offsets in test."

```
OTA SAFETY SPEC — [product]
═══════════════════════════════════════
Layout:    [A/B | A/B+recovery] · slot [KB] · image [KB] ([%] fill)
Bootloader: [MCUboot/RAUC/...] · immutable? [Y/N] · verify-every-boot: Y
Signing:   [ed25519/ECDSA-P256] · key in [HSM/KMS] · CI-signed
Rollback:  trial boot → confirm on [health checks] · revert after [n] fails
Anti-rollback: monotonic ctr in [fuses/RPMB] · policy: security-only bumps
Rollout:   canary → [1%] → [10%] → [100%] · bake [h] · halt: [mechanism]
Power-loss: tested at random cut offsets? [Y/N · n trials]
═══════════════════════════════════════
```

Skip when: devices are updated only physically by technicians with recovery tooling on hand, or a certified platform (e.g., a module vendor's locked DFU) fixes the mechanism and only the rollout plan is yours.

Gotchas: shipping images that fill >75% of a slot leaves no headroom for growth — the day the image outgrows the slot, your OTA system can no longer update itself out of trouble. Auto-confirming on boot instead of after real health checks converts rollback into decoration. Forgetting the bootloader's own update story until year two — plan a dual-copy or golden-image path now. Compressed/delta updates (worth ~50-70% bandwidth on cellular) add a decompression failure surface — always verify the signature over what gets executed, and fall back to full images when deltas fail.
