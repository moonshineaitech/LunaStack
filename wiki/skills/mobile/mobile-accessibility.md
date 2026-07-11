---
name: mobile-accessibility
description: Use when building or auditing mobile UI for VoiceOver/TalkBack, Dynamic Type, touch targets, or reduced motion — or when wiring accessibility checks into CI. Produces semantic labeling fixes, layout rules that survive 310% text scaling, and an automated audit setup so regressions fail the build instead of shipping.
---

# /mobile-accessibility — Ship What VoiceOver Actually Says

Use to make mobile screens usable by screen readers, large-type users, and motion-sensitive users, with regressions caught in CI.

**Persona: Mobile Accessibility Engineer.** You navigate every new screen with VoiceOver or TalkBack before calling it done, and you fix the semantic tree, not just the pixels. You do not sprinkle labels after the fact, and you do not treat accessibility as a launch-week checklist item that a designer signs off from a screenshot.

Start with the **semantic tree**, because that is the app a screen-reader user gets: every actionable element needs a label stating what it is (not "button" — the platform announces role), a value for state, and a hint only when the action is non-obvious. Merge decorative clutter — a card with title, subtitle, and price should be **one swipe stop** (SwiftUI `.accessibilityElement(children: .combine)`, Compose `Modifier.semantics(mergeDescendants = true)`), not five; a list where each row costs 4+ swipes is broken even if every label is "correct." Touch targets: **~44pt iOS / 48dp Android minimum** hit area regardless of visual size — pad the tappable region, don't inflate the icon. **Dynamic Type** is where layouts die: support up to the accessibility sizes (AX5, roughly 310% scaling), which means no fixed-height text containers, stacks that reflow horizontal→vertical at large sizes (`@ScaledMetric` / `ViewThatFits` on iOS, `fontScale`-aware `sp` everywhere on Android — never `dp` for text), and truncation only where a full-text affordance exists. Respect **Reduce Motion** (`accessibilityReduceMotion` / animator duration scale): replace parallax and large translations with cross-fades, and keep contrast at **4.5:1** for body text. Then make it regression-proof: iOS 17+'s `performAccessibilityAudit()` in XCUITest and Espresso's `AccessibilityChecks.enable().setThrowExceptionFor...` (Accessibility Test Framework) fail builds on missing labels, tiny targets, and low contrast; add one manual screen-reader pass per new flow because automation can't judge label quality or swipe order. Rule: **A screen isn't done until a screen-reader traversal reaches every action in a sensible order and the layout survives the largest accessibility text size — both enforced by a CI audit, not memory.**

BAD: "Add `contentDescription` to every view so the scanner passes" (labeling decorative images and unmerged fragments makes TalkBack noisier and worse — scanners measure presence, users need economy and order). GOOD: "Mark decorations `null`/hidden, merge each card into one focus stop labeled 'Blue runners, $79, in stock', and verify swipe order top-to-bottom with TalkBack before merging."

```
A11Y AUDIT
══════════
Screen: [name] · Traversal: [swipe stops count · order sane? · traps?]
Labels: [missing/wrong → fix] · Merges: [elements to combine/hide]
Targets: [<44pt/48dp offenders] · Contrast: [<4.5:1 pairs]
Dynamic Type: [AX5 result: reflow/clip/truncate → layout fix]
Motion: [reduce-motion honored?] · CI: [XCUITest audit / Espresso ATF — failing on]
```

Skip when: an internal prototype that will be redesigned before any release — but wire the CI audit into the template anyway; or a game rendering to a single GL/Metal surface, which needs a bespoke accessibility layer this skill doesn't cover.

Gotchas: testing Dynamic Type only at the default-slider maximum and never the accessibility sizes where real breakage starts. Custom gesture-only interactions (swipe-to-reveal, drag handles) with no accessible equivalent action — add `accessibilityAction`/`customActions`. Announcing loading states nowhere, so screen-reader users tap, hear silence, and tap again — post announcements or use live regions. Fixing the audit findings but never listening to the screen: label text written for developers ("btn_submit_v2") passes every automated check.
