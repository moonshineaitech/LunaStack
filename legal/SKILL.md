---
name: legal
description: Use when a founder is preparing to launch a product or company and needs a pre-launch legal checklist to review with counsel — entity formation, ToS/privacy, IP ownership, and compliance (GDPR/CCPA/COPPA/PCI). Surfaces what to resolve before the first real user or dollar.
---

# /legal — Legal Checklist for Launch

**Role: Startup Legal Advisor.** Not legal advice — a checklist of things to discuss with your actual lawyer.

Skip when: it's an internal-only tool, a throwaway prototype with no external users, or a pre-incorporation experiment collecting no real user data — come back before the first real user or the first dollar.

```
PRE-LAUNCH LEGAL CHECKLIST
═══════════════════════════
BUSINESS
  □ Business entity formed (LLC, C-Corp, etc.)
  □ Operating agreement / bylaws signed
  □ EIN / tax registration
  □ Business bank account separate from personal
  □ Co-founder agreement (equity, vesting, roles, IP assignment)

PRODUCT
  □ Terms of Service drafted
  □ Privacy Policy drafted (matches actual data practices)
  □ Cookie policy (if serving EU users)
  □ Acceptable use policy (if user-generated content)
  □ DMCA takedown process (if hosting user content)
  □ Refund/cancellation policy
  □ Accessibility statement

IP
  □ Domain registered (you own it, not a contractor)
  □ Trademark search for product name
  □ All code is either: written by employees/founders, licensed open source, or covered by contractor IP assignment agreements
  □ No copied code without proper licensing

COMPLIANCE
  □ GDPR (if EU users) — DPA, data export, right to delete
  □ CCPA (if CA users) — "Do not sell" option
  □ SOC 2 (if enterprise customers) — begin process early
  □ PCI DSS (if handling payment data)
  □ COPPA (if users under 13)
```

Decision rule: launch is BLOCKED if any of these three is unchecked — business entity formed, IP assignment signed by every person who touched the code, and a privacy policy that matches real data practices. Compliance has no safe-harbor headcount: 1 EU user triggers GDPR, 1 California user triggers CCPA, 1 user under 13 triggers COPPA — count jurisdictions, not volume.

BAD: shipping a privacy policy lifted from a competitor that states "we use no third-party analytics" while your build runs Google Analytics and Mixpanel. GOOD: a privacy policy that enumerates every SDK and processor actually in the build — analytics, crash reporting, payments, ad networks — each traced back to a real data map.

Gotchas: Don't treat this checklist as legal advice -- it's a conversation starter for your actual lawyer. Don't launch with a privacy policy that doesn't match your actual data practices -- regulators check. Don't skip the co-founder agreement -- 50% of startup failures involve founder disputes, and verbal agreements don't hold up.
