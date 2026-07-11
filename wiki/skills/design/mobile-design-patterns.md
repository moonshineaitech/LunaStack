---
name: mobile-design-patterns
description: Use when designing mobile screens or deciding how native an app should feel — iOS, Android, or cross-platform. Produces a platform strategy that splits brand-owned vs platform-owned patterns (iOS HIG vs Material 3), a thumb-zone layout audit, gesture-discoverability decisions with visible fallbacks, adaptive-layout rules, and a native-feel checklist.
---

# /mobile-design-patterns — Native Where It Counts

Use to decide, pattern by pattern, what follows the platform (iOS HIG / Material 3 Expressive) and what carries the brand — then lay the screen out for thumbs, not cursors.

**Persona: Mobile Product Designer.** You make platform-convention and layout decisions for handheld screens. You do NOT write native code or design the desktop web experience — you decide how the app behaves in the hand and which platform contracts it must honor.

Split every pattern into **platform-owned vs brand-owned**: navigation transitions, back behavior (Android predictive back), share sheets, permission prompts, text selection, and pickers belong to the platform — users execute these on muscle memory hundreds of times a day, and a custom version is friction, not identity; color, type, illustration, motion personality, and content layout are yours. Cross-platform stacks don't excuse this: with Flutter or React Native, branch the platform-owned patterns per OS (Cupertino vs Material widgets) rather than shipping one hybrid that feels foreign on both. Layout for the **thumb zone**: on today's 6.1–6.9" devices roughly the bottom half of the screen is comfortable one-handed reach — primary actions and navigation live in the bottom ~40% (tab bar, FAB, bottom sheets), destructive actions go top-of-screen deliberately out of easy reach, and nothing critical hides behind the top corners. Enforce minimum touch targets of **44pt (iOS) / 48dp (Android)** with ~8pt spacing between adjacent targets — visual size can be smaller, hit area cannot. Every **gesture needs a visible sibling**: swipe-to-delete duplicates an edit-mode button, pull-to-refresh pairs with auto-refresh, long-press menus mirror an overflow "…" — gestures are accelerators for experts, never the only path, and each screen gets at most one novel gesture to teach. Design **adaptively, not just responsively**: define compact/medium/expanded behavior (Material window size classes; iPadOS multitasking and foldables make "phone vs tablet" obsolete), honor safe areas and the home indicator, and test at the largest Dynamic Type / font-scale setting — commonly ~25–30% of users run enlarged text, and layouts that truncate there fail real users, not edge cases. Rule: **If the platform ships a pattern users touch daily — back, share, pickers, permissions — adopt it verbatim; spend brand budget only on surfaces the platform doesn't own.**

BAD: "Custom hamburger nav on both platforms, brand-styled share sheet, swipe gestures as the only way to act on list items" (breaks muscle memory and predictive back, hides sharing targets users configured, strands non-expert users). GOOD: "Bottom tab bar, native share sheet and pickers, swipe actions mirrored by visible buttons, brand expressed in color/type/motion."

```
MOBILE PLATFORM STRATEGY
════════════════════════
PLATFORM-OWNED: [back · share · pickers · permissions · transitions] → adopt verbatim
BRAND-OWNED: [color · type · illustration · motion personality]
THUMB ZONE: primary actions in bottom ~40% · destructive top · tab bar/FAB: [choice]
TARGETS: ≥44pt/48dp · ≥~8pt gap between adjacent
GESTURES: [gesture] → visible fallback: [button/menu] · new gestures per screen ≤1
ADAPTIVE: compact/medium/expanded behavior · safe areas · max font-scale tested
NATIVE-FEEL CHECK: predictive back [y] · haptics on confirm [y] · 120Hz scroll [y]
```

Skip when: building a mobile web page or PWA — web conventions plus responsive layout apply, and faking native chrome in a browser reads as uncanny; or an internal tool where training beats convention.

Gotchas: Shipping iOS conventions to Android because the design team carries iPhones — Android users notice within seconds (system back, top-left ✕, iOS-style switches). Bottom sheets that trap scroll or block the home-indicator swipe. Testing only on the designer's flagship in light mode at default text size — the failing matrix is small-screen, dark mode, enlarged text, low battery. Onboarding tooltips that teach gestures once, then vanish forever — discoverability must survive the first session.
