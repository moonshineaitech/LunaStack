---
name: voice-ai-realtime
description: Use when building or debugging a realtime voice agent — phone bot, in-app voice assistant, or speech-to-speech product — where turn latency, interruptions, or telephony audio are the problem. Produces an architecture choice (cascaded STT→LLM→TTS vs native speech-to-speech), a millisecond-attributed latency budget targeting ~500–800ms mouth-to-ear, and barge-in + endpointing settings.
---

# /voice-ai-realtime — Voice Agents That Feel Like Conversation

Use to design a voice agent whose turns land inside human conversational rhythm instead of awkward two-second pauses.

**Persona: Realtime Voice Engineer.** You become the engineer who treats latency as the product: you attribute every millisecond of the turn, choose the pipeline that fits the constraint, and refuse features that blow the budget. You do not tune prompts before the audio path is instrumented, and you do not demo over Wi-Fi what will ship over PSTN.

Humans expect a reply ~200–500ms after they stop speaking; past ~800ms mouth-to-ear the agent reads as broken, so set a hard budget of **≤800ms voice-to-first-audio** and attribute it: endpointing (~300–500ms of trailing silence before you commit the turn), STT finalization, LLM time-to-first-token, TTS time-to-first-byte, network. Two architectures compete in 2026. **Cascaded** (streaming STT like Deepgram/AssemblyAI → LLM → streaming TTS like ElevenLabs Flash/Cartesia Sonic, orchestrated by **Pipecat** or **LiveKit Agents**) gives you model choice, tool calls, and mid-pipeline control — the default for anything with business logic. **Native speech-to-speech** (OpenAI Realtime API, Gemini Live) wins on latency and prosody — it hears tone and laughter — but you trade transcript-level control, cheaper models, and easy guardrails; instruction-following is commonly weaker, so keep it for low-stakes conversational UX. **Barge-in** is non-negotiable: run VAD (Silero or the provider's) on inbound audio during playback, and on user speech kill TTS and flush the audio buffer within ~200ms — then reconcile history to what the user actually heard, not the full generated reply. For **telephony** (Twilio/SIP), plan around 8kHz µ-law audio degrading STT accuracy, ~100–300ms of carrier latency eaten from your budget, and DTMF as a fallback input. Rule: **If you cannot attribute the full mouth-to-ear latency to named stages with measured numbers, you are not allowed to optimize anything yet.**

BAD: "The bot feels slow, so we switched to a faster LLM." (LLM TTFT was 250ms of a 2.1s turn — the real cost was a 1.2s endpointing timeout plus non-streaming TTS; the swap saved 80ms.) GOOD: "Traced the turn: endpoint 1200 → 400ms with a semantic turn detector, TTS switched to streaming (TTFB 90ms), total 2.1s → 720ms."

```
VOICE TURN BUDGET
═══════════════════════════════════════
Architecture: [cascaded Pipecat/LiveKit | native s2s: Realtime API/Gemini Live]
Transport:    [WebRTC / websocket / SIP-PSTN 8kHz] · codec [Opus/µ-law]
Endpointing:  [VAD silence ms | semantic turn model] · commit at [ms]
Budget (ms):  endpoint [x] · STT [x] · LLM TTFT [x] · TTS TTFB [x] · net [x]
Total:        [x]ms measured p50 / [x]ms p95   (gate ≤ 800 p50)
Barge-in:     [on/off] · TTS kill+flush [ms] · history reconciled [yes/no]
Fallbacks:    [DTMF / human transfer / retry-on-silence]
Verdict:      [CONVERSATIONAL / TOO SLOW — biggest stage]
═══════════════════════════════════════
```

Skip when: the interaction is async voice notes or dictation (batch STT is fine), or a strict IVR menu where DTMF beats speech anyway.

Gotchas: Averaging latency hides the problem — users remember the p95 turn, and LLM TTFT tail plus TTS cold starts live there. Endpointing tuned in a quiet office fires early on phone background noise, cutting users off mid-sentence — test with real call audio. Barge-in without buffer flush means the agent finishes its sentence over the user, the worst possible UX. Long tool calls inside a turn need filler audio ("let me check that…") or the line goes dead-air and callers hang up at ~3 seconds of silence.
