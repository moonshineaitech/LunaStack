---
name: procurement
description: Use when evaluating software vendors, SaaS tools, or service providers.
---

# /procurement — Vendor Evaluation

Use when evaluating software vendors, SaaS tools, or service providers.

**Persona: Procurement Specialist.** You evaluate vendors on total cost of ownership, not sticker price.

Evaluation: does it solve the actual problem (not features, outcomes)? Total cost (license + implementation + training + maintenance + switching cost). Vendor health (funding, team size, customer count, support SLA). Security (SOC 2, data handling, breach history). Integration (API quality, existing integrations, data export). Contract terms (annual commitment, price increases, exit clause). Reference checks (talk to 2-3 actual customers, not case studies).

---


---

# 🗺️ FLOW MAPS — How Protocols Connect

Protocols aren't isolated. They chain. These maps show the standard flows.

### Full Feature Lifecycle
```
/interview-me ─→ /inquiry ─→ /thesis ─→ /scope ─→ /premortem
                                                        │
                    ┌───────────────────────────────────┘
                    ▼
              /architect ─→ /data-model ─→ /api-contract
                    │
                    ▼
                /spec ─→ /plan ─→ /tdd ─→ /build
                                            │
                    ┌───────────────────────┘
                    ▼
               /verify ─→ pass? ─→ /ship ─→ /deploy-check ─→ /postlaunch
                  │          │
                  │         fail
                  │          │
                  │       /debug ─→ fix ─→ /verify (retry)
                  │
                  ▼
           /retro ─→ /learn ─→ /compound ─→ (next session starts smarter)
```

### Quick Ship (feature is clear, <2 hours)
```
/spec ─→ /plan ─→ /tdd ─→ /build ─→ /verify ─→ /ship
```

### Emergency Fix (<30 minutes)
```
/debug (reproduce→isolate→root-cause) ─→ /tdd (regression test) ─→ /ship
```

### Discovery Only (no code)
```
/inquiry ─→ /landscape ─→ /thesis ─→ /premortem ─→ /brief
```

### Design Sprint
```
/inquiry ─→ /persona ─→ /design-variants (3 options) ─→ /friction ─→ /implement-design
```

### Architecture Review
```
/architect ─→ /threat-model ─→ /cost ─→ /tradeoff ─→ /rfc
```

### Hiring Pipeline
```
/hiring (spec) ─→ /recruiter (source) ─→ /interview-me (design questions) ─→ /decision (evaluate)
```

### Go-To-Market
```
/market-size ─→ /persona ─→ /cmo (strategy) ─→ /copywriter (messaging) ─→ /ab-test (validate)
```

### Post-Incident
```
/incident (timeline + root cause) ─→ /learn (extract) ─→ /compound (feed back) ─→ /guard (add new pattern)
```

### End of Day
```
/snapshot ─→ /handoff ─→ /learn ─→ /compound
```

---

# 📋 WORKED EXAMPLES — Protocols Producing Real Output

### Example: /premortem on "AI-powered resume builder"

```
PREMORTEM: AI Resume Builder
════════════════════════════

It's 6 months from now. The product failed. Here's why:

TECHNICAL FAILURES
  1. AI generates hallucinated work experience that users don't catch
     Likelihood: HIGH | Impact: CATASTROPHIC (legal liability)
     Early warning: User reports of inaccurate content in first 2 weeks
     Prevention: Mandatory human review step. AI highlights generated vs user-provided content with visual distinction.

  2. PDF export breaks across ATS (Applicant Tracking Systems)
     Likelihood: HIGH | Impact: HIGH (resumes get rejected silently)
     Early warning: Low callback rates reported by users
     Prevention: Test against top 10 ATS systems before launch. Simple formatting > fancy design.

PRODUCT FAILURES
  1. Users don't trust AI with their career — they use it once and go back to Google Docs
     Likelihood: HIGH | Impact: FATAL
     Early warning: D7 retention < 10%
     Prevention: Start with AI-assisted editing (suggestions), not AI-generated (full drafts). Build trust incrementally.

  2. LinkedIn import makes the whole thing feel like a commodity
     Likelihood: MEDIUM | Impact: HIGH
     Early warning: 80% of users just import + export with zero edits
     Prevention: The value must be BEYOND formatting. Tailoring to specific job descriptions is the wedge.

EXECUTION FAILURES
  1. Building for "everyone" means building for no one
     Likelihood: HIGH | Impact: HIGH
     Early warning: No clear user segment dominates signups
     Prevention: Pick ONE persona (new grad? career switcher? executive?) and nail it.

TOP 3 RISKS (by likelihood × impact)
  #1 Users don't trust AI with their career → start with assistance, not generation
  #2 ATS compatibility → test before launch, not after
  #3 No clear target user → pick a segment and commit

KILL CRITERIA
  Stop if: <5% D7 retention after 500 signups
  Stop if: >20% of AI content flagged as inaccurate by users
  Stop if: No segment shows >15% paid conversion after 2 months
```

### Example: /verify output on a PR

```
VERIFICATION BOARD
══════════════════
Files: 6 | Lines changed: +142 / -31

[CRITICAL] Security — SQL injection in search endpoint
  File: src/search/handler.ts:34
  Issue: User query interpolated into raw SQL via template literal
  Fix: Use parameterized query: db.query('SELECT * FROM items WHERE name ILIKE $1', [`%${query}%`])
  Confidence: 99%

[HIGH] Performance — N+1 in order listing
  File: src/orders/list.ts:22
  Issue: Loop fetches customer for each order individually (50 orders = 50 queries)
  Fix: Eager load with .findMany({ include: { customer: true } }) or batch query
  Confidence: 95%

[MEDIUM] Structure — Error swallowed silently
  File: src/payments/charge.ts:67
  Issue: catch block logs error but returns success response to client
  Fix: Return 500 with user-friendly message. Log with correlation ID for debugging.
  Confidence: 88%

[MEDIUM] Accessibility — Form inputs missing labels
  File: src/components/SearchForm.tsx:12
  Issue: <input> has placeholder but no <label> — screen readers can't identify the field
  Fix: Add <label htmlFor="search">Search items</label> (can be visually hidden if needed)
  Confidence: 92%

[LOW] Style — Inconsistent error handling pattern
  File: src/orders/create.ts vs src/orders/update.ts
  Issue: create.ts uses try/catch, update.ts uses .catch() — inconsistent within same module
  Fix: Standardize on try/catch (matches rest of codebase)
  Confidence: 80%

VERDICT: ❌ BLOCKED
  Blocking: 1 critical (SQL injection), 1 high (N+1)
  Fix these two, then re-run /verify.
  Board confidence: 91%
```

### Example: /cfo on a SaaS pricing model

```
UNIT ECONOMICS: ProjectTracker SaaS
════════════════════════════════════

CAC (Customer Acquisition Cost): $127
  Channels: Google Ads ($89 avg), content/SEO ($45 avg), referral ($23 avg)
  Blended: $127 based on current channel mix (40/40/20)

LTV (Lifetime Value): $864
  ARPU: $29/mo (Pro plan average)
  Gross margin: 82% (hosting + support costs)
  Avg lifespan: 36 months (2.8% monthly churn)
  LTV = $29 × 0.82 × 36 = $856

LTV:CAC Ratio: 6.7:1 ✅ (target: >3:1)
Payback Period: 5.3 months ✅ (target: <12)

BURN ANALYSIS
  Monthly burn: $47K (team: $38K, infra: $5K, tools: $4K)
  Current MRR: $31K (1,069 customers)
  Runway: 14 months at current burn (assuming $200K in bank)
  Breakeven: $57K MRR (need ~970 more customers at $29 avg)

PRICING RECOMMENDATION
  Current: $19/mo Starter, $29/mo Pro, $79/mo Team
  Issue: 71% of revenue from Pro. Starter barely covers cost-to-serve ($4.20/user).
  Recommendation:
    - Raise Starter to $24 (or make it a 14-day trial → Pro)
    - Add annual billing at 17% discount ($290/yr Pro) — improves cash + reduces churn
    - Team plan needs usage limits, not just seat count, to capture enterprise value
```

### Example: /brand framework

```
BRAND FRAMEWORK: Ridgeline (project management for construction)
═══════════════════════════════════════════════════════════════

Purpose:     Construction teams shouldn't need a CS degree to manage a project.
Audience:    General contractors running 3-10 active residential projects.
Position:    We are the project management tool for builders who hate software.
Personality: Straightforward, rugged, reliable. NOT: corporate, trendy, complicated.
Voice:       Talk like a foreman, not a consultant. Short sentences. No jargon.
Promise:     You'll know the status of every job without opening a laptop.
Proof:       Mobile-first daily logs. Photo-based progress tracking. One-tap updates.
Enemy:       Not Procore (they serve enterprise). The enemy is the whiteboard-and-text-messages workflow that loses information.
```

---

# 🔗 CROSS-REFERENCES — Related Protocols

When you finish one protocol, these are the natural next steps:

| After running... | Consider next... | Why |
|---|---|---|
| /inquiry | /thesis, /landscape, /premortem | Crystallize, research, or stress-test |
| /premortem | /scope (contract), /spike | Reduce top risks before committing |
| /spec | /plan, /data-model, /api-contract | Decompose, or design key interfaces |
| /plan | /tdd + /build, or /batch (parallel) | Execute the plan |
| /build | /verify, /qa | Prove quality before shipping |
| /verify (blocked) | /debug (for critical), then /verify again | Fix blocking issues |
| /verify (approved) | /ship | Release |
| /ship | /deploy-check, /postlaunch | Verify deployment health |
| /incident | /learn, /compound, /guard | Feed back into the system |
| /retro | /learn → /compound | Close the learning loop |
| /design-variants | /friction, /a11y | Test the chosen design |
| /architect | /threat-model, /cost, /tradeoff | Stress-test the design |
| /hiring | /recruiter, /interview-me | Source and design interview |
| /cmo | /copywriter, /ab-test | Create and test messaging |
| /cfo | /cost, /investor | Financial projections |
| /landscape | /compete, /premortem | Assess competitive risk |

---

# ⚠️ UNIVERSAL ANTI-PATTERNS — What Goes Wrong Across All Protocols

These mistakes appear in every discipline. They're built into LunaStack's Gotchas sections, but collected here for reference.

**1. Skipping discovery.** The #1 failure. Building before understanding. /inquiry exists because most failed projects solved the wrong problem, not because they solved it poorly.

**2. Premature specificity.** Designing the database before understanding the user. Writing code before writing a spec. Optimizing before profiling. Every protocol has a prerequisite — respect the order.

**3. Vague acceptance criteria.** "It should work correctly" is not a criterion. If you can't write a test for it, you can't verify it. /spec forces Given/When/Then for this reason.

**4. Single-reviewer syndrome.** One perspective misses what six catch. /verify runs parallel agents because the bugs you ship are the ones your ONE reviewer has a blind spot for.

**5. Context window abuse.** Stuffing everything into one session until quality degrades. /fresh, /snapshot, /handoff, /subagent-pattern, and /context-budget all exist because context is finite and precious.

**6. No learning loop.** Doing the same work, making the same mistakes, session after session. /retro → /learn → /compound is the flywheel that makes LunaStack better than a prompt library.

**7. Heroics over systems.** Relying on one person to remember the right thing instead of encoding it in protocols. If a practice depends on someone remembering, it will fail when they're busy.

**8. Treating AI output as final.** Claude is a collaborator, not an oracle. Every output needs human judgment. /verify catches technical issues. /second-opinion catches strategic ones. Your brain catches everything else.

**9. Building for everyone.** Every /inquiry, /persona, and /scope protocol pushes for specificity because products built for "everyone" serve no one well.

**10. Ignoring what went wrong.** /incident and /retro exist because the most expensive mistake is the one you make twice. The compound loop turns failures into institutional knowledge.

---


---

# 🔥 LATEST PATTERNS — From Boris Cherny (Creator, March 2026) + Production Teams
