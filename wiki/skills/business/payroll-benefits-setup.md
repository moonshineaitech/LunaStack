---
name: payroll-benefits-setup
description: Use when setting up payroll and benefits — first W-2 hire, choosing PEO vs payroll provider, adding health coverage, or hiring across states. Produces a provider decision with cost math, a stage-appropriate benefits baseline, a compliance calendar of registrations and filings, and a multi-state exposure map. Broker and counsel review — not legal, tax, or benefits advice.
---

# /payroll-benefits-setup — Payroll Without Penalties

Use to stand up compliant payroll and a stage-appropriate benefits package, with the filings calendar and multi-state registrations mapped before they become penalty letters.

**Persona: People-Ops Infrastructure Lead.** Acts as the operator who selects the payroll stack, defines the benefits baseline, and builds the compliance calendar. Does NOT choose insurance plans or interpret employment law — a licensed benefits broker places coverage and employment counsel confirms state obligations. Not legal, tax, or benefits advice.

The structural decision is **PEO vs payroll provider**. A PEO (Justworks, TriNet, Rippling PEO) is co-employment: you rent their EIN for benefits and payroll tax purposes, getting big-group health rates and offloaded state filings, at roughly ~$100-200/employee/month or a percent of payroll. A payroll provider (Gusto, Rippling, ADP Run) keeps you the employer of record at ~$40-100/employee/month, with a broker placing small-group benefits separately. Decision rule of thumb: under ~10 employees in one state, a payroll provider + broker is usually cheaper and simpler; a distributed 10-50-person team where health premiums are a hiring weapon is the PEO sweet spot; past ~75-100 employees the PEO markup typically exceeds what your own broker can negotiate — plan the exit (exits are cleanest at Jan 1 to avoid split W-2s and benefits-plan-year chaos). Benefits baseline by stage: at 1-5 employees, medical (aim to cover ~70-100% of employee premium; a QSEHRA is the lightweight alternative if group plans don't pencil) plus a 401(k) via Guideline or Human Interest — note many states now mandate a retirement option, and SECURE 2.0 startup credits offset most small-plan admin cost (CPA confirms); dental/vision/life are cheap adders by 10-15. Compliance calendar: state payroll tax and unemployment registration BEFORE the first check in each state, quarterly 941s and state filings (the provider files, you verify), W-2s/1099s by Jan 31, workers' comp from employee #1 in most states, ACA reporting at 50+ FTEs. **Multi-state remote is the silent trap**: one remote hire creates payroll tax nexus, unemployment insurance registration, possibly corporate income/franchise tax nexus, and that state's leave and wage laws — decide deliberately which states you hire in rather than discovering obligations from a penalty notice. Rule: **No employee starts in a new state until that state's payroll registrations exist — retroactive registration means penalties plus interest, and it's the single most common early-payroll failure.**

BAD: "Gusto runs payroll, so we're covered — approve the new hire in Ohio and sort registrations later" (the provider calculates tax but you must register for withholding and unemployment accounts; unregistered states bounce filings and accrue penalties from day one). GOOD: "Before the offer goes out: register OH withholding + SUI, confirm workers' comp rides along, add OH to the compliance calendar — then start date."

```
PAYROLL & BENEFITS SETUP
═════════════════════════
MODEL: [PEO|payroll provider + broker] · provider: [name] · cost: [$X/EE/mo] · revisit at: [N employees]
BENEFITS BASELINE: medical [plan/QSEHRA, X% premium covered] · 401k [provider, match?] · dental/vision/life: [y/n]
STATES: [state → withholding ✓ · SUI ✓ · workers' comp ✓ · registered before first check ✓]
COMPLIANCE CALENDAR: [941s quarterly · state filings · W-2/1099 Jan 31 · ACA at 50 FTE · state retirement mandate]
REVIEWERS: broker: [name] · counsel (multi-state/leave): [name] · CPA (credits/basis): [name]
```

Skip when: contractors-only with no W-2 employees — you need 1099 collection (W-9s, Jan 31 filings) and possibly an EOR for foreign contractors, not a payroll/benefits stack.

Gotchas: hiring wherever great candidates live, then discovering you're registered in 11 states with 11 sets of leave laws — set an allowed-states list. Assuming the PEO handles ALL compliance — wage-and-hour law, exempt/non-exempt classification, and required postings remain yours. Missing that workers' comp is required even for one remote desk worker in most states. Choosing a PEO for the benefits, then finding exit terms and data export are painful — check the off-ramp before signing.
