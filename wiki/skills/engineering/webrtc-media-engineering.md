---
name: webrtc-media-engineering
description: Use when building real-time audio/video — calls, live rooms, screen share — or when an existing WebRTC stack has quality or cost problems. Covers SFU vs mesh vs MCU selection, TURN economics, simulcast/SVC, connection-state UX, and the build-vs-CPaaS call. Produces a media architecture decision with topology, codec plan, and TURN budget.
---

# /webrtc-media-engineering — Topology First, Pixels Second

Use to choose the right real-time media architecture — mesh, SFU, MCU, or a CPaaS — and engineer the connection lifecycle users actually feel.

**Persona: Real-Time Media Architect.** You decide topology, codec strategy, and infrastructure economics for live audio/video. You do NOT design the product's call UI visuals or implement codec internals — you make the calls connect fast, degrade gracefully, and not bankrupt the company on TURN egress.

Topology is a head-count decision: **mesh** (P2P, no media server) works to ~3-4 participants because each sender uploads N-1 streams — beyond that uplinks saturate; an **SFU** (LiveKit, mediasoup, Janus — the 2026 defaults) forwards streams server-side and carries you to hundreds; an **MCU** (server-side compositing) is now a niche for SIP/telephony interop and recording, since compositing burns CPU and kills per-viewer layout. Large broadcasts (~500+ viewers) should exit WebRTC entirely into LL-HLS/WHEP-fed CDN delivery. On an SFU, enable **simulcast** (3 spatial layers for VP8/H.264) or **SVC with AV1/VP9** — AV1 SVC is production-real in 2026 and cuts bandwidth ~30% at equal quality, but budget client CPU on low-end mobile — so the SFU downgrades per-subscriber instead of tanking the whole room. **TURN is your hidden bill**: ~10-20% of connections commonly relay through TURN (CGNAT, corporate firewalls), and relayed video is full media egress — co-locate TURN with your SFU regions, force TCP/TLS-443 fallback for hotel-grade networks, and model TURN GB/month before launch, not after the invoice. Connection-state UX is engineering, not polish: distinguish ICE `disconnected` (transient — show "reconnecting", hold ~5-10s) from `failed` (trigger ICE restart, then full renegotiation), and surface per-user network quality from RTCStats so people blame their Wi-Fi, not your app. Build-vs-buy: below ~50k monthly call-minutes or without a dedicated media engineer, use a CPaaS (LiveKit Cloud, Daily, Twilio Video-class); self-host when media cost dominates or you need data-locality control. Rule: **Mesh past 4 participants is a design defect — move to an SFU with simulcast/SVC before adding the fifth tile.**

BAD: "Ship P2P mesh for group calls, we'll add a server later" (the 5th participant's uplink dies on real-world upload speeds; 'later' becomes an emergency rewrite mid-growth). GOOD: "SFU (LiveKit) with AV1-SVC where supported and VP8 simulcast fallback, TURN-TLS on 443 in each SFU region, mesh reserved for 1:1."

```
MEDIA ARCHITECTURE DECISION
═══════════════════════════
Topology: [mesh ≤4 | SFU | MCU(interop only) | CDN egress ≥~500 viewers] · stack: [LiveKit|mediasoup|CPaaS]
Codecs: [AV1-SVC|VP9|VP8 simulcast + Opus] · layers: [S/T config] · fallback: [chain]
TURN: regions [list] · est. relay %: [~10-20] · GB/mo budget: [$] · 443/TLS fallback: [Y]
Reconnect: disconnected→wait [5-10s] · failed→[ICE restart→renegotiate] · stats surfaced: [RTT·loss·bitrate]
Build vs buy: [CPaaS below ~50k min/mo] · exit criteria to self-host: [cost/control trigger]
```

Skip when: latency tolerance is over ~2-3 seconds — LL-HLS/WebSocket streaming is drastically cheaper and simpler than WebRTC. One-way audio notifications or turn-based apps don't need real-time media at all.

Gotchas: testing only on office Wi-Fi — the failures live on CGNAT mobile and corporate proxies; test with forced-TURN and packet-loss shaping. Ignoring `RTCPeerConnection` renegotiation ordering (glare) causes ghost failures when both sides offer at once — use perfect negotiation. Audio matters more than video: prioritize Opus with FEC/DTX and never let video bitrate starve audio. Skipping recording/compliance requirements until launch — server-side recording changes your topology choice (SFU egress pipeline vs MCU), so decide it up front.
