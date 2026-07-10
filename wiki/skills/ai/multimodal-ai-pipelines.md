---
name: multimodal-ai-pipelines
description: Use when building a pipeline that feeds images, audio, or video into LLMs alongside text and cost, chunking, or grounding is undecided. Produces a per-modality preprocessing spec, media chunking plan, cross-modal grounding contract, and a routed cost budget.
---

# /multimodal-ai-pipelines — Vision, Audio, Text in One Pipeline

Use to design the ingestion path for media-heavy LLM features: how each modality is preprocessed, chunked, grounded, and priced.

**Persona: Multimodal Pipeline Engineer.** You own everything between raw media and the model call — resizing, transcription, frame selection, and the grounding contract. You do NOT train models or design the downstream product UX; you make media cheap, legible, and citable.

Preprocess per modality before any tokens are spent. **Images**: resize to the model's sweet spot (~1568px longest edge for Claude-class vision; larger is resized server-side anyway — you pay upload latency for nothing) and know your token math: a full-size image commonly costs ~1,100-1,600 tokens, so a 40-page scanned PDF as images is a ~50k-token decision someone should make on purpose. **Audio**: transcribe first (Whisper-class or provider-native ASR) with **word-level timestamps** and diarization, and pass text downstream — native-audio models are for prosody/emotion tasks, not for cheap transcription at scale. **Video**: never send video wholesale; sample frames adaptively — ~1 fps baseline, denser on scene changes (shot detection via PySceneDetect-style tooling), paired with the transcript aligned by timestamp. Chunk media on semantic boundaries: audio on speaker turns or ~30s silence-aware segments, video on shots, documents on layout blocks (tables and figures extracted separately — a table OCR'd as prose is destroyed data). The part juniors skip is the **grounding contract**: every model claim about media must be attributable, so require outputs to cite timestamps (audio/video) or page + bounding box (documents), and carry those anchors through the whole pipeline — grounding you drop at ingestion cannot be recovered at answer time. Control cost by routing: a cheap pass (small vision model or heuristics) filters/describes media, and only flagged segments reach the frontier model — commonly a 5-10x saving on video-heavy workloads. Rule: **Extract text and structure once, early, with timestamps/coordinates attached — then feed models the cheapest representation that preserves the evidence, not the raw media.**

BAD: "We base64 the whole 20-minute screen recording into the prompt and ask what happened" (thousands of near-duplicate frames, six-figure token cost, and answers with no timestamps to verify against). GOOD: "Shot-detected keyframes at ~1 fps + diarized transcript aligned by timestamp; cheap model tags segments; frontier model sees only the 4 flagged segments and must cite [mm:ss] for every claim."

```
MULTIMODAL PIPELINE — [feature]
═══════════════════════════════
Modalities:   [image/audio/video/doc] · volumes: [n/day, avg size]
Image:        resize→[1568px] · ~[n] tok/image · OCR/layout: [tool]
Audio:        ASR [model] · diarized? [Y] · word timestamps? [Y]
Video:        frames @[1]fps + scene-change densify · transcript aligned
Chunking:     [speaker turns / shots / layout blocks] → [n] tok units
Grounding:    citations required: [timestamp / page+bbox] · carried E2E? [Y]
Routing:      cheap pass [model] filters → frontier sees [x]% of media
Budget:       [$ per item] · measured [$ or "not measured"]
```

Skip when: a single modality with trivial volume (a few images per request) — call the vision model directly and skip the pipeline ceremony.

Gotchas: transcribing without diarization makes "who said it" unanswerable forever — re-processing the archive later costs more than doing it right once. Uniform frame sampling misses the 2-second moment that matters and duplicates 10 minutes of static slides; sample on change, not on the clock. Resolution downscaling that makes screenshots legible to humans can make UI text illegible to the model — verify OCR-ability at your chosen size. Media preprocessing failures (corrupt file, silent ASR error) must dead-letter loudly; a pipeline that silently skips the attachment answers confidently about media it never saw.
