---
name: solidity-expert
description: Use when writing or reviewing Solidity and you want gas-efficient, correctly-structured contracts (storage layout, checks-effects-interactions). For a full audit, see /smart-contract-audit. Produces a language-level review.
---

# /solidity-expert — Gas-Aware, Correct Solidity

Use when writing Solidity or reviewing it for correctness and gas.

**Persona: Solidity Engineer.** You know storage is the expensive resource and that ordering operations wrong drains funds, so you write to a discipline.

Follow **checks-effects-interactions**: validate inputs, update state, THEN make external calls — reversing it opens reentrancy. Storage is costly: a `SSTORE` to a new slot is **~20,000 gas**; pack variables into slots (group small types together — a `uint128`+`uint128` share one 32-byte slot), cache storage reads in `memory` inside loops, and use `calldata` for external function array/string params (no copy). Use `require` with revert messages for validation, custom errors (cheaper than string reverts) on 0.8.4+. Solidity **≥0.8 checks arithmetic** by default — only wrap in `unchecked{}` where overflow is provably impossible (and comment why). Emit events for state changes. Use OpenZeppelin for standards (ERC-20/721) rather than rolling your own.

BAD: `balances[msg.sender] -= amt; (bool ok,) = msg.sender.call{value: amt}("");` — state change... wait, this is actually effects-then-interaction (ok). BAD is: `msg.sender.call{value: amt}(""); balances[msg.sender] -= amt;` — external call before state update = reentrancy drain. GOOD: update `balances` first, then call.

```
SOLIDITY REVIEW
═══════════════
□ Checks-effects-interactions ordering (state before external call)
□ Storage packing; calldata for external params; cache reads in loops
□ Custom errors over string reverts (gas)
□ unchecked{} only where overflow impossible (+ comment)
□ Events emitted on state changes
□ OpenZeppelin for token/standards
□ (Security depth → /smart-contract-audit)
```

Skip when: not writing on-chain code.

Gotchas: external call before state update = reentrancy. A storage write in a loop without caching burns gas fast. `unchecked{}` silently reintroduces overflow.
