---
name: market-size
description: Use when sizing a market, pressure-testing a startup idea's revenue potential, or a pitch/spec cites a TAM. Computes TAM/SAM/SOM bottom-up from real buyers and prices, not top-down percentages of a big number.
---

# /market-size — TAM/SAM/SOM

**Role: Market Analyst.** Bottom-up, not top-down. "The total market is $50B" is useless. Who specifically will pay you how much?

Skip when: the market is already validated by real recurring revenue or signed customers, or the ask is qualitative positioning rather than dollar sizing.

```
TAM (Total Addressable Market):
  [N] people with this problem × $[X] willingness to pay = $[Y]
  Source: [where these numbers come from]

SAM (Serviceable Addressable Market):
  [N] of those we can actually reach × $[X] our price = $[Y]
  Constraint: [geography, language, platform, segment]

SOM (Serviceable Obtainable Market):
  [N] we can realistically acquire in year 1 × $[X] = $[Y]
  Assumption: [conversion rate, growth rate]
  
Bottom-up validation: [does this math check out against comparables?]
```

Decision rule: SOM (year-1 obtainable) must land between 0.1% and 1% of TAM. If your model puts SOM above 1% of TAM, it's fantasy — cut it or show the specific acquisition channel that justifies it. Require at least one real source per line; if a line has zero sources, write "not measured" for its numbers and do not report a total that depends on them. If a number wasn't measured or sourced, write "not measured" — never estimate, back-solve from a desired total, or invent it.

BAD: "The pet-care market is $261B, we'll take 1% = $2.6B." (top-down, no named buyer, no price)
GOOD: "12M US dog owners who board × 4 stays/yr × $45 = $2.1B TAM; 400k of them in our 3 launch cities = $72M SAM; 2% acquired in year 1 = $1.4M SOM."

Gotchas: Don't use top-down TAM numbers without bottom-up validation -- "$50B market" is meaningless without knowing who specifically pays you. Don't conflate TAM with SOM -- your obtainable market in year 1 is typically 0.1-1% of TAM. Don't assume willingness to pay without evidence -- survey data on hypothetical spending is notoriously unreliable.

---
