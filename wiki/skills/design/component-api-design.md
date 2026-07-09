---
name: component-api-design
description: Use when designing the props/API of a reusable UI component so it's flexible without becoming a prop-explosion mess. Produces a component-API review.
---

# /component-api-design — Clean Component APIs

Use when building a reusable component others will consume.

**Persona: Component Library Engineer.** You design props like a public API — because for a shared component, that's exactly what they are.

Keep the prop surface **small and orthogonal**: a `variant` enum (`primary|secondary|danger`) beats a pile of booleans (`isPrimary`, `isDanger`, `isSecondary`) that can conflict. Prefer **composition over configuration** for complex content — accept `children`/slots rather than a dozen props to configure inner layout (`<Card><Card.Header/>...` beats `<Card headerText= footerButtons=...>`). Make illegal states unrepresentable (a discriminated prop union so you can't pass `loading` and `error` both true). Sensible defaults so the common case needs no props. Forward the native element's props/ref (`...rest`, `ref`) so consumers can add `aria-*`, `onClick`, `className`. Keep it **controlled/uncontrolled** consistently (if you accept `value`, accept `onChange`; support `defaultValue` for uncontrolled). Name props by intent, and don't leak internal implementation. Document each prop and provide accessible defaults (a `Button` renders a real `<button>`).

BAD: `<Button isPrimary isLarge isDisabled isLoading hasIcon iconName="..." />` — boolean soup where `isPrimary` + `isSecondary` can both be true, and no way to pass `aria-label`. GOOD: `<Button variant="primary" size="lg" disabled loading {...rest}><Icon/>Save</Button>` — enum variant, composition for the icon, native props forwarded.

```
COMPONENT API REVIEW
════════════════════
□ Small orthogonal props (variant enum over conflicting booleans)
□ Composition (children/slots) over prop-configured inner layout
□ Illegal states unrepresentable (discriminated prop unions)
□ Sensible defaults (common case = zero props)
□ Native props/ref forwarded (...rest, ref) for a11y/events/className
□ Controlled/uncontrolled consistent (value+onChange / defaultValue)
□ Props named by intent; accessible defaults
```

Skip when: a one-off component used in exactly one place — API rigor is overkill.

Gotchas: boolean soup allows conflicting states and grows unbounded — use enums + composition. Not forwarding `...rest`/`ref` blocks consumers from adding a11y attributes and handlers. Mixing controlled and uncontrolled patterns confuses consumers.
