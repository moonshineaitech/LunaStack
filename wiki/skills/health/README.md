# Personal Health Skills — read this first

A library of agentic skills for **personal health management** — logging,
organizing, understanding, and preparing — designed to run on **your own data,
privately and locally**. They help you be a more informed, organized participant
in your own care.

## What these are — and are NOT

**These skills are educational and organizational support. They are NOT:**

- **NOT a diagnosis.** They never tell you what disease/condition you have. They
  don't estimate the probability you have something. An AI cannot examine you,
  order tests, or replace a clinician's judgment.
- **NOT medical advice or treatment.** They don't prescribe, dose, or tell you to
  start/stop a medication. Those are decisions for a licensed professional who
  knows your full history.
- **NOT deterministic.** They surface patterns, questions, and general education —
  they don't output verdicts. When information is uncertain, they say so.

**They ARE:** a symptom journal that spots patterns to show your doctor; a
medication tracker; a plain-language explainer of what a lab test measures; a
doctor-visit preparer; a vitals log with trend awareness; evidence-based wellness
guidance; and a coordinator for the logistics of care — all so you walk into an
appointment prepared, not so you skip it.

This library now spans 100 skills across the whole personal-health journey —
grouped roughly as:

- **Tracking & understanding:** symptom-journal, vitals-tracking, lab-result-explainer,
  medication-tracker, pain-tracking, menstrual-cycle-tracking, wearable-metrics-literacy.
- **Visits & records:** doctor-visit-prep, telehealth-visit-prep, pediatric-visit-prep,
  medical-records-organizer, second-opinion-prep, new-diagnosis-navigation,
  family-health-history, emergency-info-card.
- **Managing care:** chronic-condition-support, caregiver-coordination,
  medication-interaction-awareness (pharmacist-deferred), surgery-prep-recovery,
  allergy-management, immunization-record, advance-directive-organizer.
- **Prevention & wellness:** preventive-care-schedule, sleep-optimization,
  nutrition-tracking, exercise-programming, hydration-tracking, health-goal-setting,
  dental-health-habits, vision-eye-care, skin-health-awareness, fall-prevention,
  travel-health-prep, smoking-cessation-support.
- **Support & safety:** symptom-triage-education, first-aid-guidance,
  mental-health-support (988-first), stress-management-techniques,
  health-data-privacy, health-insurance-navigator, prescription-cost-navigator.
- **Clinical action & transitions:** hospital-discharge-plan,
  medication-reconciliation, specialist-referral-navigation, lab-test-prep,
  imaging-exam-prep, procedure-bowel-prep-support, informed-consent-understanding,
  clinical-trial-navigation, wound-care-tracking, self-injection-support,
  physical-therapy-adherence, cpap-therapy-adherence, home-bp-monitoring,
  asthma-action-plan-support, glucose-monitoring-support, anticoagulation-support.
- **Home diagnostics & acute home care:** home-test-kit-literacy,
  home-pulse-oximeter-use, fever-home-care, cold-flu-home-care,
  gi-illness-home-care, migraine-headache-journal, digestive-symptom-journal,
  antibiotic-stewardship, medication-safe-storage-disposal.
- **Life stages:** prenatal-visit-prep, postpartum-recovery-support,
  newborn-care-basics, pediatric-visit-prep, teen-to-adult-care-transition,
  menstrual-cycle-tracking, menopause-symptom-tracking, memory-concern-journal,
  hearing-health-protection, concussion-recovery-support.
- **Emergency readiness:** emergency-info-card, cpr-aed-education,
  naloxone-overdose-response, disaster-medical-preparedness.

See `INDEX.md` (generated) for the current full list. For building this content
into games (e.g. LunaCelsus), see `wiki/skills/gamedev/`.

## The safety contract (every skill enforces it)

Every skill in this directory carries, by construction (checked by
`tests/validate_health_skills.sh`):

1. **A non-diagnostic disclaimer** — "educational, not diagnosis; consult a
   licensed professional."
2. **An emergency-escalation path** — explicit red flags that trigger
   *"stop and call your local emergency number (911 in the US) now."* For
   mental-health skills, the crisis line (988 in the US) is first-class.
3. **A defer-to-professional cue** — it names when to hand off to a clinician,
   pharmacist, or emergency care, and does so readily.
4. **No diagnostic assertions** — forbidden phrasings ("you have X", "this is
   definitely cancer") fail the safety gate.

## Universal red flags — call emergency services now

Regardless of skill, treat these as emergencies (call 911 / your local number):
chest pain or pressure; difficulty breathing; **stroke signs — FAST**: Face
drooping, Arm weakness, Speech difficulty, Time to call; severe/uncontrolled
bleeding; sudden severe headache; confusion or loss of consciousness; a severe
allergic reaction (swelling, trouble breathing); thoughts of harming yourself or
others (call/text **988** in the US, or your local crisis line).

## Privacy

These are designed to work on your own logged data, locally — your health
information is among the most sensitive there is. See `health-data-privacy` for
protecting it. Do not paste identifiable health data into services you don't
trust.
