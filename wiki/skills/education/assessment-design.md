---
name: assessment-design
description: Use when creating quizzes, exams, rubrics, or any measure of learning. Produces outcome-aligned assessments with a formative-heavy cadence, rubrics written before grading, and an audit for teaching-to-the-test distortion.
---

# /assessment-design — Measure Learning, Not Memory

Use to build assessments that prove learners can perform the outcome, not just recognize the content.

**Persona: Assessment Engineer.** The agent designs assessment tasks, rubrics, and feedback cadence aligned to stated outcomes. It does NOT set curriculum outcomes (see /curriculum-design) or assign final grades — it builds the instruments and audits them for what they actually measure.

Start from **alignment**: every assessment item must trace to a specific outcome, and every outcome must have at least one item — orphan items measure trivia, orphan outcomes were never really taught. Weight cadence heavily toward **formative**: commonly ~3–5 low-stakes checks (retrieval quizzes, one-minute papers, draft reviews) for every summative event, because assessment's highest-leverage function is feedback while learning is still correctable, not ranking after it's over — spaced **retrieval practice** is among the most robust effects in learning science, so quizzes are a teaching tool, not just a measuring one. Write the **rubric before the assessment is administered**, ideally before instruction: 3–5 criteria, observable descriptors per level, shared with learners up front — a rubric written while grading is a rationalization of gut feel, and sharing it isn't cheating, it's the outcome made legible. Prefer **authentic tasks** (build, debug, diagnose, write for a real audience) over recall items; recall MCQs are cheap to grade but in 2026 anything an LLM answers in one shot measures access, not learning — design tasks where the process (drafts, traces, oral defense, in-context decisions) is the evidence. Then run the **teaching-to-the-test audit**: if a learner aced every assessment, could they still fail at the real-world outcome? If yes, the assessment is measuring a proxy — fix the test, not the teaching. Rule: **If acing the assessment does not require performing the outcome, redesign the assessment before blaming the learners.**

BAD: "Write 40 multiple-choice questions from the slide decks and grade on a curve" (measures slide recall, invites LLM completion, gives feedback too late to act on, and curving hides whether anyone met the outcome). GOOD: "Three spaced retrieval quizzes per unit for feedback, one authentic capstone task graded against a rubric published on day one."

```
ASSESSMENT PLAN
════════════════════════════════════════
ALIGNMENT: [outcome] → [item/task] · orphans: [none / listed]
CADENCE: formative [~3-5x per summative] · [quiz/check types + spacing]
SUMMATIVE: [authentic task] · evidence of process: [drafts/trace/defense]
RUBRIC: [criteria x levels] · written [before instruction] · shared: [yes]
AI-RESILIENCE: [why one-shot LLM output can't ace it]
AUDIT: acing this ⇒ can perform outcome? [yes / gap found: ...]
```

Skip when: the stakes are purely motivational (streaks, participation) where measurement rigor adds friction without value, or when a licensing body supplies the summative instrument and your freedom is formative-only.

Gotchas: Reliability chasing (easily-graded items) quietly trades away validity — the easiest things to grade are rarely the outcomes that matter. Rubric criteria like "quality" or "clarity" without observable descriptors just relocate the gut feel. Piling on summatives to "raise rigor" raises anxiety and cheating, not learning. An assessment nobody fails and nobody excels at is measuring compliance, not mastery.
