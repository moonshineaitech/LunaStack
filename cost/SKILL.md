---
name: cost
description: Infrastructure Cost Projection.
---

# /cost — Infrastructure Cost Projection

```
                Current     10x users    100x users
Compute:        $X          $X           $X
Database:       $X          $X           $X
Storage:        $X          $X           $X
Network:        $X          $X           $X
Third-party:    $X          $X           $X
Total:          $X/mo       $X/mo        $X/mo
Per user:       $X          $X           $X

Scaling type: [Linear / Sublinear (good) / Superlinear (danger)]
Top optimization: [what to change, est. savings]
```

Gotchas: Don't assume linear scaling -- most cloud costs scale superlinearly without optimization at 10-100x. Don't forget third-party API costs in projections -- they often dominate at scale. Don't project costs without per-user metrics -- total cost is meaningless without knowing cost-to-serve per unit.

---
