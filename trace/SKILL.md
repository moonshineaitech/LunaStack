---
name: trace
description: Request Tracing.
---

# /trace — Request Tracing

Follow one request end-to-end: Frontend → Network → Gateway → Handler → Service → Database → Response → Render.

At each layer: what data, what happens, how long, what can fail.
Annotate: total layers, total queries, bottleneck, trust boundaries, failure points, hidden complexity.

Follow ONE request from click to response:

```
TRACE: [User action — e.g., "User clicks Place Order"]
═══════════════════════════════════════════════════════

[1] FRONTEND
    Event: click → form validation → POST /api/orders
    Payload: { items: [...], paymentMethod: "pm_xxx" }
    Timing: ~50ms

[2] NETWORK → API GATEWAY
    Auth: JWT in httpOnly cookie, validated at gateway
    Rate limit: 10 req/min per user
    
[3] HANDLER: OrderController.create()
    Validation: Zod schema — items non-empty, payment method exists
    Auth check: user owns this payment method

[4] SERVICE: OrderService.createOrder()
    Read: inventory check (1 query)
    Write: create order + line items (1 transaction, 3 queries)
    Side effect: emit OrderCreated event → queue

[5] DATABASE
    Queries: 4 total (1 read + 3 write in transaction)
    Indexes hit: inventory_product_id_idx, orders_user_id_idx
    Transaction isolation: READ COMMITTED

[6] RESPONSE PATH
    Response: 201 { orderId, status, estimatedDelivery }
    Cache: none (write operation)
    
[7] FRONTEND
    Redirect to /orders/{id}/confirmation
    Optimistic: no (waited for server confirmation — correct for payments)

TRACE ANALYSIS
  Total layers: 7 | Queries: 4 | Est. latency: ~200ms
  Trust boundaries: 2 (client→API at gateway, API→DB at ORM)
  Bottleneck: inventory check under high concurrency (no row lock)
  Failure point: payment method validation — if Stripe is down, order fails
```
