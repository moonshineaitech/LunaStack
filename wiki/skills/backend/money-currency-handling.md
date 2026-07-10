---
name: money-currency-handling
description: Use when code stores, computes, or displays money — prices, invoices, balances, refunds, or multi-currency reports. Produces a money representation policy (integer minor units + currency), per-operation rounding rules, and an allocation strategy for splits that must sum exactly.
---

# /money-currency-handling — Money Is an Integer With a Passport

Use to make monetary code exact: right representation, right rounding, honest multi-currency math.

**Persona: Financial Correctness Engineer.** Defines how amounts are typed, rounded, allocated, and reported; audits arithmetic paths for float leakage. Does NOT design payment-provider integration or tax rules — this is the arithmetic layer they all sit on.

Money is a pair — **(amount in integer minor units, ISO 4217 currency code)** — and the two travel together through every function signature, table, and API payload. Never IEEE-754 floats: `0.1 + 0.2` already fails, and the errors compound silently through interest and tax math. Integer cents (`BIGINT` + `currency CHAR(3)`, or `NUMERIC(19,4)` where fractional intermediates must persist) beats decimal-everywhere for hot paths; either way the type system should make `usd_amount + eur_amount` a compile/runtime error, not a number. Minor-unit **exponent is per-currency**: USD has 2 decimals, JPY has 0, BHD/KWD have 3 — hardcoding `/100` corrupts yen and dinar alike; pull exponents from ISO 4217 data (javamoney/Moneta, Python `moneyed`/`babel`, `dinero.js` v2, Rust `rusty-money`). Rounding is a **per-operation policy, not a global default**: half-up commonly for customer-facing prices and tax lines (many jurisdictions mandate it per line), **banker's rounding (half-even)** for high-volume aggregation where half-up bias accumulates real money, and round as late as possible — keep 4+ decimal intermediates, round once at the boundary. Splitting an amount uses **largest-remainder allocation** (Fowler's `allocate`): distribute the floor, then hand leftover cents to the largest remainders, so a $100.00 three-way split is 33.34/33.33/33.33 and *always sums to the original* — never `total/n` rounded per share. Multi-currency reporting is honest only when each conversion records **rate + source + timestamp** and the report states its policy (e.g., "converted at daily close ECB rate"); summing converted amounts without frozen rates makes yesterday's revenue change today. Rule: **Every arithmetic result in a money path must be exactly representable and every split must sum to its source — if you can't prove both, the code rounds per-item and leaks cents.**

BAD: "Store price as FLOAT and format with toFixed(2) at display" (a 19.99 * 3 cart shows 59.97 but stores 59.969999…, and reconciliation drifts one cent per thousand rows). GOOD: "Store `amount_minor BIGINT + currency`, compute in integers, allocate splits by largest remainder, round tax half-up per line."

```
MONEY POLICY
════════════
Representation: [integer minor units + ISO 4217 · lib: X]
Exponents: [from ISO data, not /100] · Mixed-currency ops: [type error]
Rounding: [op → mode: tax=half-up/line · aggregation=half-even · when: last]
Allocation: [largest-remainder · invariant: parts sum to whole]
FX: [rate+source+timestamp stored per conversion · report policy stated]
```

Skip when: money appears only as display-through from a provider (Stripe amounts echoed to UI, no arithmetic) — keep the provider's integer minor units untouched and skip the framework.

Gotchas: parsing user input via float on the way to integers (`int(19.99*100)` → 1998 in several languages — parse the string as decimal); percentage discounts applied per-line then summed vs applied to total — pick one, document it, or refunds won't match; storing "USD" implicitly and bolting currency on later (every historic row becomes a guess); JSON numbers silently becoming doubles in transit — serialize money amounts as strings or integer minor units, never decimal literals.
