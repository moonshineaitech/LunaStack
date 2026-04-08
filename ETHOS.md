# Ethos

LunaStack exists because AI coding assistants are powerful and undisciplined.

They generate code without tests. Ship without review. Repeat mistakes across sessions. Ignore context limits until quality collapses. The problem isn't intelligence — it's methodology.

This project imposes methodology. Not by limiting what AI can do, but by structuring how it thinks.

## Beliefs

**Evidence over intuition.** Every architectural decision carries documented rationale. Every optimization is benchmark-proven. Every deployment is verified. Gut feelings are hypotheses — test them before acting on them.

**Systems over heroes.** A methodology that depends on one person remembering to do the right thing will fail. LunaStack encodes good practices into protocols that activate automatically. The system catches what individuals miss.

**Compounding over accumulating.** Most codebases get harder to work on over time. LunaStack reverses this by extracting learnings from every session and feeding them forward. Each feature makes the next feature easier, not harder.

**Verification over trust.** One reviewer has one perspective. LunaStack runs six. Cross-model verification catches blind spots that homogeneous reasoning structurally cannot. Trust is earned by passing gates, not assumed by default.

**Craft over output.** Lines of code are not a metric of progress. Shipping is not a metric of quality. The metric is: did we build the right thing, correctly, and can we prove it? Speed is a consequence of good methodology, not a goal that justifies skipping it.

## Non-Beliefs

**"Move fast and break things."** Moving fast is good. Breaking things is expensive. LunaStack helps you move fast without breaking things by catching problems before they ship.

**"AI will replace developers."** AI is a tool, not a replacement. LunaStack makes developers more effective by handling the mechanical parts of methodology — checklists, memory, verification — so developers can focus on the creative parts: design, architecture, and judgment.

**"More code is more progress."** The best code is code you don't have to write. The second best is code that's well-tested, well-documented, and easy to delete.

## Design Principles

**Plain text.** Every protocol is a Markdown file. No compilation, no runtime, no magic. You can read every instruction the AI receives. You can modify any protocol with a text editor.

**Progressive disclosure.** Protocols load their metadata (~100 tokens) during discovery. Full instructions load only when activated (<5K tokens). Heavy operations run in subagents. Context is currency — spend it wisely.

**Escape hatches.** Every protocol includes when NOT to use it. Every gate can be overridden (except test failures). Every override is logged. The methodology serves the developer, not the other way around.

**Self-improvement.** The system evolves through use. /compound feeds learnings back into agent instructions. /evolve creates new protocols from observed patterns. The longer you use LunaStack, the more it knows about your project.
