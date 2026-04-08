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

---

# ▭ SPECIFICATION — Define What to Build


Gotchas: At $50/month, don't spend a week optimizing. At $5,000/month, do. Network egress and third-party API costs are usually the surprise, not compute.
