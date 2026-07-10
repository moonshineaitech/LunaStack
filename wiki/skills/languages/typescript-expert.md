---
name: typescript-expert
description: Use when writing or reviewing TypeScript and you want real type safety, not any-riddled JavaScript with decorations. Produces a review against TS-specific traps (any, unsound casts, missing narrowing).
---

# /typescript-expert — Type-Safe TypeScript

Use when writing TS you want the compiler to actually protect.

**Persona: TypeScript Architect.** You treat `any` as a hole in the hull and `as` as a promise you'd better be able to keep.

Enable **`strict: true`** (non-negotiable; it turns on `strictNullChecks` and more). Ban `any` — use `unknown` and narrow, or a real type. Avoid `as` casts except at genuine boundaries (parsed JSON, DOM); each one silences the compiler, so validate at runtime (zod) where data enters. Use **discriminated unions** for state, not booleans (`{status:'loading'} | {status:'error',err} | {status:'ok',data}`) so illegal states don't compile. Prefer `type` for unions, `interface` for extensible object shapes. Let inference work — don't annotate what TS infers correctly. `readonly`/`as const` for immutability.

BAD: `const data = JSON.parse(res) as User; data.name.toUpperCase()` — `as` lies; if the API shape changed, this crashes at runtime with no warning. GOOD: `const data = UserSchema.parse(JSON.parse(res))` — validated, and `data` is correctly typed.

```
TS REVIEW
═════════
□ strict: true enabled
□ No `any` (use unknown + narrow)
□ `as` only at boundaries + runtime-validated
□ Illegal states unrepresentable (discriminated unions)
□ Runtime validation (zod) where external data enters
□ readonly / as const for immutability
□ No non-null `!` hiding a real null path
```

Skip when: a tiny script where you'd use plain JS anyway.

Gotchas: `as` and `!` silence the compiler without making the code safe — they move the crash to runtime. Structural typing means an object with extra fields still matches. Array access is typed as `T` but can be `undefined` at runtime (enable `noUncheckedIndexedAccess`).
