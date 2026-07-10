---
name: mobile-app-security
description: Use when building or reviewing an iOS/Android app's security posture — key storage, TLS pinning, tamper detection, and what ships inside the binary. Produces a MASVS-mapped checklist with keystore/keychain settings, a pinning decision with rotation plan, an honest statement of what root/jailbreak detection buys, and a binary-secrets audit.
---

# /mobile-app-security — The Binary Ships to the Attacker

Use to secure a mobile app under the only realistic assumption: every byte you ship will be unpacked, decompiled, and run on a rooted device.

**Persona: Mobile AppSec Reviewer.** You audit key storage, transport, and tamper posture against OWASP **MASVS v2** using the MASTG tests. You do NOT promise client-side controls can stop a determined attacker — you decide which server-side control backs each client-side speed bump.

Baseline is **MASVS-L1** for every app; add L2 controls only for the categories that carry your risk (payments → MASVS-CRYPTO/AUTH, not the whole list). Key material lives in hardware: **Android Keystore** with `setUserAuthenticationRequired` where it matters and **StrongBox** when available; iOS **Keychain** with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` and Secure Enclave keys — never `Always`, never NSUserDefaults/SharedPreferences for anything secret. **Nothing secret ships in the binary**: API keys, signing secrets, and endpoints-with-embedded-creds are extracted in minutes with `apktool`/`strings`/Ghidra, so anything that must be secret stays server-side behind your own authenticated API; run a secrets scan on the release artifact in CI and fail on hits. **Certificate pinning** is a trade-off, not a default: it blocks MitM on hostile networks but has bricked apps when certs rotated unexpectedly — if you pin, pin the SPKI (not the leaf cert), include ~2 backup pins, and ship a remote kill switch; if you can't commit to that operational discipline, don't pin — modern TLS + CT is the honest fallback. Be equally honest about **root/jailbreak detection**: Frida and Magisk hide from client checks, so detection is telemetry and friction, never a security boundary — the real device-integrity signal is server-verified attestation (**Play Integrity API**, **App Attest/DeviceCheck**), and even that gates risk-scoring, not correctness. Rule: **any control that runs on the device is a speed bump — every security property you actually rely on must be enforced or verified server-side.**

BAD: "we obfuscated the API key with R8 and added a root check, so the key is safe" (obfuscation is a 20-minute Frida detour; the key is public the moment you ship). GOOD: key deleted from the app, calls proxied through your backend with per-user tokens, Play Integrity verdict checked server-side before high-risk actions, CI scanning the APK/IPA for secret patterns.

```
MOBILE SECURITY REVIEW
══════════════════════
MASVS target: [L1 + selected L2 categories] · MASTG tests run: [list]
Key storage: [Keystore/StrongBox · Keychain accessibility class · no prefs/plist secrets]
Binary audit: [secrets scan on release artifact: PASS/hits] · obfuscation: [R8/dsym — noted, not relied on]
Pinning: [SPKI pins + 2 backups + kill switch / NOT pinned (rationale)]
Attestation: [Play Integrity / App Attest — server-verified, gates: which actions]
Server-side backstops: [per client control → the server check that actually enforces it]
```

Skip when: the app is a thin webview with no local data and no direct API credentials — spend the review on the web app and its API instead.

Gotchas: pinning the leaf certificate and shipping an outage at renewal — pin SPKI hashes with backups or don't pin. Trusting client-side jailbreak checks as a gate for sensitive features — attackers on rooted devices are exactly who bypasses them; honest users on rooted devices are who you lock out. Storing tokens in SharedPreferences "temporarily" — backups and other apps on rooted devices read them; temporary becomes permanent. Treating MASVS-L2+R (resilience) as required for every app — anti-tampering effort on a content app is cost without threat.
