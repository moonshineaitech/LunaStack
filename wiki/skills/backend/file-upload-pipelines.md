---
name: file-upload-pipelines
description: Use when designing or reviewing any user-facing file upload flow — avatars, documents, video. Produces an upload pipeline design covering presigned direct-to-storage ingress, resumable/multipart thresholds, magic-byte validation and virus scanning in a quarantine stage, async processing queues, and safe serving.
---

# /file-upload-pipelines — Uploads That Never Touch Your App Server

Use to design an upload path where clients write directly to object storage, bytes are validated by content not name, and processing happens off the request path.

**Persona: Storage platform engineer who has cleaned up after an "accept multipart on the API" incident.** You design the mint-verify-promote pipeline and its failure modes; you do NOT proxy file bytes through application servers, and you do not trust anything the client declares about its own payload.

The app server's only jobs are minting **presigned URLs** and reacting to completion events — bytes go browser-to-bucket (S3/R2/GCS presigned POST or PUT). Lock the presigned grant down: expiry ≤ 15 minutes, a server-generated key (never a client-supplied filename — path traversal and overwrites live there), and a `content-length-range` policy condition so a "5MB avatar" can't arrive as 5GB. Above ~100MB, switch to **resumable** upload — S3 multipart (8–16MB parts; 5MB is the API minimum) or the **tus** protocol / GCS resumable sessions — because a single PUT that dies at 99% on hotel Wi-Fi restarts from zero. Uploads land in a **quarantine** bucket/prefix with no public access; a storage event (S3 → SQS/EventBridge) triggers validation: sniff **magic bytes** (`file`/libmagic, not the extension, not the client's Content-Type — both are attacker-controlled), enforce a type allowlist, run malware scanning (GuardDuty Malware Protection for S3, or ClamAV in a container), then copy to the serving bucket and mark the DB record `ready`. Image/video work (sharp/libvips thumbnails, ffmpeg transcodes, EXIF stripping — GPS coordinates in avatars are a privacy leak) runs on a queue, never inline; the client polls or gets a websocket event when derivatives exist. Add a lifecycle rule aborting incomplete multipart uploads after ~7 days or you pay for invisible orphaned parts forever. Rule: **Clients upload only via short-lived presigned grants with content-length-range enforced, into quarantine — nothing is servable until magic-byte validation and scanning promote it.**

BAD: "Accept multipart/form-data on the API server and stream it to S3" (upload throughput now consumes app-fleet memory and connections, you pay bandwidth twice, and a slow-loris uploader stalls workers). GOOD: "POST /uploads returns a 15-min presigned POST with content-length-range and a server-chosen key; an S3 event triggers validate→scan→promote, and the record flips to ready."

```
UPLOAD PIPELINE DESIGN
══════════════════════════════════════════
Ingress:    presigned [POST|PUT] · expiry [≤15m] · key [server-generated] · cap [content-length-range]
Resumable:  [S3 multipart|tus] above [~100MB] · part [8–16MB] · abort-incomplete [7d lifecycle]
Validate:   magic bytes [libmagic] · allowlist [types] · client MIME/ext [ignored]
Scan:       quarantine [bucket/prefix] → [GuardDuty|ClamAV] → promote|reject+notify
Process:    queue [name] · [sharp|ffmpeg] · EXIF [stripped] · status [pending→ready]
Serve:      origin [separate domain/CDN] · SVG/HTML [sanitized or attachment] · Content-Disposition [set]
```

Skip when: files are machine-generated server-side (no untrusted ingress — write to the bucket directly), or it's an internal tool with a handful of trusted users and sub-MB files where a direct API upload is honestly fine.

Gotchas: SVG (and HTML, PDF) uploads execute script when served inline from your main origin — serve user content from a separate sandboxed domain or force `Content-Disposition: attachment`. Magic bytes alone misidentify zip-based formats (docx/xlsx/apk are all `PK`) — inspect the zip's internal structure for those, and cap decompressed size to block zip bombs. Presigned PUT (unlike POST) cannot enforce content-length-range — if you must use PUT, verify the object's actual size in the completion handler before promoting. Processing images synchronously in the upload response works in the demo and melts at the first 100-megapixel TIFF — queue it from day one.
