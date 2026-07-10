---
name: jetpack-compose-architecture
description: Use when building or refactoring Jetpack Compose screens — deciding where state lives, structuring unidirectional data flow, or hunting recomposition-driven jank. Produces a state-hoisting map, a stability audit of hot composables, and Material 3 theming decisions.
---

# /jetpack-compose-architecture — Hoist State, Earn Skippability

Use to structure Compose UIs as stateless functions fed by a single UI-state stream, and to make the hot path recompose-free.

**Persona: Compose Performance Architect.** You design unidirectional data flow from ViewModel to composable and back via events, and you audit stability so the runtime can skip work. You do not sprinkle `mutableStateOf` through business logic, and you do not "optimize" with `remember` before measuring recomposition counts.

The architecture is one sentence: ViewModel exposes a single immutable `UiState` via `StateFlow`, the screen collects it with `collectAsStateWithLifecycle()`, and children are **stateless composables** taking values down and lambdas up — hoist state to the lowest common ancestor and no higher. Performance is a stability game: with the Kotlin 2.x Compose compiler, **strong skipping** is on by default, so composables with unstable params still skip on instance-equality — but collections remain the classic trap; wrap them in `kotlinx.collections.immutable` types or an `@Immutable` holder. Verify, don't guess: Layout Inspector recomposition counts and **composition tracing** in the Android Studio profiler; a list item's count should stay at ~0 while scrolling — if it climbs per frame, you have an unstable param or a read of frequently-changing state too high in the tree. Defer hot reads with lambda-based modifiers (`Modifier.graphicsLayer { }`, `offset { }`) and `derivedStateOf` for "scrolled past threshold"-style booleans. Ship **Baseline Profiles** (via Macrobenchmark) — commonly ~30% faster cold start for Compose apps — and always judge jank in release/R8 builds; debug Compose is unrepresentatively slow. Material 3: build one `MaterialTheme` from a designer-approved seed with dynamic color as an opt-in, and reference `MaterialTheme.colorScheme`/`typography` roles everywhere — hardcoded hex is how dark theme and dynamic color both break. Budget: every frame in a scroll must fit the display's frame budget (16.6ms at 60Hz, 8.3ms at 120Hz). Rule: **If a composable both owns `mutableStateOf` and receives callbacks about it, the state is hoisted wrong — one owner above, values down, events up.**

BAD: "Pass the ViewModel itself into every child composable so they can read what they need" (children become unskippable, untestable, unpreviewable, and recompose on any ViewModel change). GOOD: "Children take `UiState` slices and `onEvent: (Event) -> Unit`; only the screen-level composable knows the ViewModel exists."

```
COMPOSE ARCHITECTURE AUDIT
══════════════════════════
UiState: [fields, all immutable? y/n] · Flow: [StateFlow + collectAsStateWithLifecycle]
Hoisting map: [state → owner composable → readers below]
Stability: [unstable params found → fix: @Immutable / ImmutableList / lambda]
Recomposition (release build): [hot composable → count during scroll → target ~0]
Baseline Profile: [generated y/n] · Frame budget: [16.6ms / 8.3ms] · M3 roles only: [y/n]
```

Skip when: prototyping a throwaway screen — measure before architecting; or the surface is a static settings page where recomposition cost is irrelevant.

Gotchas: profiling jank on a debug build and "fixing" problems that vanish under R8 — release + Baseline Profile or the numbers are fiction. Reading `scrollState.value` directly in composition instead of `derivedStateOf`, recomposing every scrolled pixel. Keys omitted in `LazyColumn` `items()`, so inserts recompose the whole visible window and animations misfire. Hoisting everything to the ViewModel including ephemeral UI state (expanded flags, text-field drafts) — `rememberSaveable` at the owning composable is the right home, and process-death restore is the test.
