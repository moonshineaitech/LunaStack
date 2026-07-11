---
name: media-playback-web
description: Use when shipping audio or video playback on the web — choosing progressive files vs adaptive streaming, handling autoplay policies, wiring the Media Session API, and meeting caption requirements. Produces a playback architecture spec with delivery format, preload strategy, autoplay fallback chain, and accessibility deliverables.
---

# /media-playback-web — Ship Playback That Streams, Starts, and Captions

Use to design web media delivery that starts fast on bad networks, respects autoplay policy, and treats captions as a launch requirement.

**Persona: Media Delivery Engineer.** Chooses encoding/delivery per content length and audience network, and specifies the player, preload, and accessibility contract. Does NOT hand-roll an ABR player when hls.js or a hosted pipeline (Mux, Cloudflare Stream) exists, and does not ship video whose bandwidth bill nobody modeled.

The delivery fork: a progressive MP4 (`<video src>`) is fine for short clips — commonly under **~60 seconds at a single bitrate** — but anything longer, or anything watched on cellular, needs **adaptive streaming**: HLS with fMP4/CMAF segments (which lets one encode serve HLS and DASH) at a 3–5 rung bitrate ladder. Safari plays HLS natively; everywhere else use **hls.js** over Media Source Extensions, and note Safari 17.1+ ships **Managed Media Source**, which hls.js already uses to cut battery drain on iOS — iPhone MSE support means you no longer need the native-HLS-only path. Don't build the pipeline yourself below serious scale: Mux or Cloudflare Stream give you the ladder, CDN, and analytics for less than an engineer-week costs. **Autoplay policy** is capability, not permission: unmuted autoplay requires prior user interaction or a high Media Engagement score, so the reliable chain is `muted` + `playsinline` autoplay → check the `play()` promise rejection → fall back to a visible tap-to-unmute affordance; never assume `play()` succeeded. Preload is an economics decision — `preload="metadata"` as the default (duration and dimensions for a few hundred KB), `preload="none"` for lists of many videos (a grid of `preload="auto"` players can pull tens of MB nobody watches), `auto` only for the one hero video the user almost certainly plays; ABR players similarly should cap forward buffer (~30s) rather than buffering the whole asset. Wire the **Media Session API** (`navigator.mediaSession.metadata` + action handlers for play/pause/seek/next) so lock screens, headphone buttons, and smartwatches control your player — a table-stakes signal of a real media product. Captions are non-negotiable (WCAG 1.2.2 Level A): WebVTT via `<track kind="captions">` or muxed into the HLS manifest, plus a transcript for audio-first content — which also happens to be your SEO and search-inside-media surface. Rule: **Content over ~60s or served to mobile networks ships as CMAF/HLS via hls.js (or a hosted pipeline) — and autoplay is always attempted muted with the play() promise checked, never assumed.**

BAD: "Serve the 20-minute course video as one 1080p MP4 with preload=auto — simpler than streaming" (cellular users buffer for 30s then bounce, everyone else downloads 500MB they may not watch, and seeking past the buffer stalls). GOOD: "CMAF/HLS with a 240p–1080p ladder through Mux, hls.js on non-Safari, preload=metadata, muted-autoplay preview with tap-to-unmute, WebVTT captions in the manifest."

```
MEDIA PLAYBACK SPEC
══════════════════════════════════
Content: [type/length] · Delivery: [progressive MP4 / HLS-CMAF] · Ladder: [rungs]
Player: [native / hls.js / hosted: Mux-CF-Stream] · Buffer cap: [~30s forward]
Preload: [none/metadata/auto + why] · Poster: [image strategy]
Autoplay chain: [muted+playsinline → play() promise check → tap-to-unmute UI]
Media Session: [metadata + handlers: play/pause/seek/prev/next]
A11y: [WebVTT captions] · [transcript] · [audio descriptions if needed] · Keyboard controls: [yes]
```

Skip when: it's a handful of short UI/demo clips — a compressed MP4 (or silent WebM treated like an animated image) with `preload="metadata"` and captions burned or tracked is the entire architecture.

Gotchas: Testing autoplay only on desktop Chrome where your own repeated visits inflated the engagement score, then shipping silent black rectangles to first-time mobile users; forgetting `playsinline`, so iOS hijacks playback into fullscreen; rendering a page of ten `preload="auto"` players and wondering why LCP and the CDN bill exploded; and treating captions as a post-launch ticket — retrofitting VTT timing across an existing library costs far more than captioning in the encode pipeline from day one.
