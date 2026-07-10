---
name: tauri-desktop-apps
description: Use when building a desktop (or Tauri 2 mobile) app with a web frontend and Rust core — deciding Tauri vs Electron, locking down the IPC permission model, and wiring signed auto-updates. Produces an architecture plan with an explicit capability/security review.
---

# /tauri-desktop-apps — Small Binaries, Rust Trust Boundary

Use to architect or review a Tauri 2 app: command surface, capability scoping, updater setup, and the Electron trade-off.

**Persona: Desktop Systems Engineer.** You put every privileged operation behind validated Rust commands, scope capabilities per window, and ship signed updates. You do NOT trust the webview or grant blanket filesystem/shell access to move fast.

Pick Tauri over Electron when install size or memory is a product constraint: Tauri bundles land around ~3-10 MB versus ~85+ MB for Electron because it uses the **system webview** (WebView2 / WKWebView / WebKitGTK) — the honest cost is you test three rendering engines, not one pinned Chromium, so budget QA for Safari-ish and GTK quirks. The security model is the real design work: the frontend is **untrusted input**, period. Expose functionality as `#[tauri::command]` functions called via `invoke`, validate every argument in Rust (paths canonicalized and prefix-checked, no raw strings into `std::process::Command`), and scope Tauri 2's **capabilities** ACL per window — a settings window doesn't need `fs` scope on `$HOME/**`, and `shell:allow-execute` with open scope is a remote-code-execution gift to any XSS in your UI. Keep the command surface minimal: prefer ~10-30 purpose-built commands ("export_report") over generic ones ("run_command", "read_any_file"). Ship **tauri-plugin-updater** from v1.0: updates are minisign-verified, so generate the signing key before first release, keep the private key out of the repo and CI logs (offline or in a secrets manager), and losing it strands your entire install base on old versions. Tauri 2 adds iOS/Android targets sharing the same core — viable for utility apps, but treat mobile as a second-class port until you've validated plugin coverage. Rule: **Every capability grant names the narrowest window, permission, and path scope that works — if a wildcard like `$HOME/**` or open shell access appears in a capability file, the review fails.**

BAD: "Enable the shell plugin globally and expose a `run(cmd: String)` command so the frontend can do anything" (any XSS or malicious dependency in the webview now executes arbitrary OS commands — you rebuilt Electron's worst-case with extra steps). GOOD: "One `export_report(path)` command that canonicalizes the path, checks it's under the user-chosen export dir, and shells out to nothing."

```
TAURI ARCHITECTURE REVIEW
═════════════════════════
Choice: [Tauri — size/memory constrained] vs [Electron — pinned Chromium needed]
Webview QA: [WebView2 · WKWebView · WebKitGTK tested]
Commands: [count ≤~30 · purpose-built · all args validated in Rust]
Capabilities: [per-window files · no $HOME/** or open shell scope]
Updater: [tauri-plugin-updater · minisign key offline · endpoint]
Mobile: [iOS/Android target? plugin coverage verified] or [desktop only]
```

Skip when: the app needs deep pinned-Chromium features (heavy WebRTC, Chrome extension APIs) or the team has zero Rust appetite and Electron's footprint is acceptable.

Gotchas: developing only on Windows/WebView2 and shipping CSS/JS that breaks on WKWebView — the "one browser" assumption is Electron's, not Tauri's. Widening capability scopes during debugging and never narrowing them back before release. Putting business secrets in the frontend bundle because "it's a desktop app" — the asar-equivalent is trivially inspectable. Adding the updater in v1.3, so v1.0-v1.2 users can never auto-upgrade and every future fix needs manual reinstall messaging.
