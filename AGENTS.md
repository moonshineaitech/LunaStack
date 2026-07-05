# AGENTS.md — LunaStack Skill Index

> 249 skills · 27 disciplines · 55 specialist roles
> Quick reference for all available `/commands`.

## Meta (8)

| Command | Description |
|---|---|
| /luna | Use at the beginning of any session to orient and route to the right protocol. Reads context, replies in three lines or fewer, routes — never does the work itself. |
| /init | Project Setup. |
| /status | Health Check. |
| /calibrate | Adjust Rigor. |
| /onboard | Use when joining a new project or starting work in an unfamiliar codebase. Ten-minute scan in a fixed order, producing a project map with danger zones. |
| /guard | Intercept dangerous commands, destructive operations, and leaked secrets before they execute. |
| /second-opinion | Use when the user's plan contains an irreversible action, touches security-sensitive surface, or contradicts a constraint they stated earlier. Evidence-backed push-back with an alternative, then defer. |
| /audit-review | Process Check. |

## Inquiry (7)

| Command | Description |
|---|---|
| /inquiry | Use when the user has a vague idea but hasn't defined the problem clearly yet. Four questions asked one at a time, pushing for a real person and falsifiable evidence. |
| /thesis | Product Thesis. |
| /scope | Scope Calibration. |
| /landscape | Competitive Research. |
| /premortem | Use before committing to a plan or project. Assume it already failed, explain why — with category quotas so product and execution failures get equal airtime with technical ones. |
| /spike | Timeboxed Investigation. |
| /brief | Stakeholder Summary. |

## Architecture (8)

| Command | Description |
|---|---|
| /architect | System Design. |
| /data-model | Schema Design. |
| /api-contract | API Design. |
| /contract | Behavioral Contracts. |
| /tradeoff | Decision Matrix. |
| /dependency | Package Evaluation. |
| /debt-audit | Scan a codebase for tech debt, quantify severity and cost, and produce a prioritized remediation plan. |
| /cost | Infrastructure cost projection at 1x/10x/100x scale. For AI/LLM API spend, see /cost-tracker. |

## Specification (6)

| Command | Description |
|---|---|
| /spec | Use when requirements are clear enough to write down but code hasn't started. Produces testable acceptance criteria, an edge-case checklist, and an explicit out-of-scope list. |
| /plan | Use when a spec is ready and needs to be broken into executable tasks. 2-5 minute tasks with exact files, done-checks, and a dependency graph. |
| /autoplan | Quick Plan. |
| /story | User Story Mapping. |
| /kpi | Success Metrics. |
| /estimate | Three-Point Estimation. |

## Construction (12)

| Command | Description |
|---|---|
| /tdd | Use when writing any new behavior or fixing any bug. Red-green-refactor with a strict definition of a valid RED; one behavior per cycle. |
| /build | Implementation. |
| /batch | Parallel Execution. |
| /pair | Pair Programming. |
| /debug | Use when a bug resists the first fix attempt, or before touching code whose failure you don't yet understand. Reproduce, isolate by binary search, fix the root cause, prove it with a regression test. |
| /explain | Deep Code Explanation. |
| /trace | Request Tracing. |
| /dig | Code Archaeology. |
| /refactor | Safe Restructuring. |
| /optimize | Apply a rigorous benchmark-measure-change-measure cycle to improve performance with statistical confidence. |
| /migrate | Safe Migration. |
| /test | Diff-Aware Test Generation. |

## Verification (5)

| Command | Description |
|---|---|
| /verify | Use before merging or shipping any non-trivial change. Multi-angle review board over the diff and its blast radius, with an explicit blocking verdict. |
| /threat-model | Run a STRIDE threat analysis on system components crossing trust boundaries and produce a prioritized risk matrix. |
| /chaos | Fault Injection. |
| /visual-check | Compare UI screenshots across breakpoints to catch visual regressions before merge. |
| /qa | Use when testing user flows, verifying UI behavior, or running manual QA passes. |

## Craft (7)

| Command | Description |
|---|---|
| /design-critique | Anti-AI-Slop Detector. |
| /design-system | Token Audit. |
| /design-variants | Generate three meaningfully different design directions as working code so the user can choose or combine. |
| /friction | UX Friction Log. |
| /a11y | Accessibility Flow Test. |
| /responsive | Audit responsive behavior across four breakpoints, checking scroll, readability, touch targets, and layout quality. |
| /implement-design | Use when translating a design mockup into pixel-perfect code. |

## Delivery (8)

| Command | Description |
|---|---|
| /ship | Use when the user says ship, deploy, merge, or release. Four gates in strict order with explicit pass criteria; any gate fails, stop and report — never proceed to the next gate. |
| /canary | Staged Rollout. |
| /deploy-check | Post-Deployment Verification. |
| /rollback | Make a rapid rollback-vs-fix-forward decision and execute an emergency revert with communication and verification. |
| /monitor | Design a complete observability stack — structured logging, metrics, and alerting — for a service or system. |
| /changelog | Generate structured release notes from commit history, split into technical and user-facing sections. |
| /incident | Run a blameless post-mortem using 5 Whys to find systemic root causes and produce actionable prevention items. |
| /document | Use when generating documentation from code — READMEs, API docs, architecture guides, or runbooks. |

## Memory (7)

| Command | Description |
|---|---|
| /retro | Use after completing a feature or sprint to measure what happened with real data. Every claim must cite a specific session event; ends with one concrete experiment. |
| /learn | Use after any session where mistakes were made or patterns discovered. Extracts evidence-backed learnings with confidence scores, presented for human approval before anything is recorded. |
| /compound | Use after /learn approves learnings, or at end of session. Promotes validated learnings into persistent project instructions so every future session starts smarter. |
| /search-memory | Search conversation history, uploaded files, and project knowledge for prior decisions and context. |
| /handoff | Capture session state so the next AI session resumes seamlessly. For handing off to a human, see /graceful-escalation. |
| /snapshot | Quick Checkpoint. |
| /evolve | Detect repeated workflow patterns and propose new slash-command protocols to automate them. |

## Leadership (8)

| Command | Description |
|---|---|
| /cfo | Financial Analysis. |
| /pitch | Investor Pitch Structure. |
| /hiring | Hiring Plan. |
| /compete | Competitive Response. |
| /naming | Name Things Well. |
| /simplify | Reduce Complexity. |
| /postlaunch | After Shipping. |
| /prioritize | Ruthless Prioritization. |

## Research (5)

| Command | Description |
|---|---|
| /user-interview | User Research Questions. |
| /survey | Survey Design. |
| /persona | User Persona. |
| /jobs-to-be-done | JTBD Analysis. |
| /market-size | TAM/SAM/SOM. |

## Infrastructure (8)

| Command | Description |
|---|---|
| /auth | Authentication Design. |
| /cache | Caching Strategy. |
| /queue | Message Queue Design. |
| /search | Search Implementation. |
| /feature-flag | Feature Flags. |
| /ci | CI/CD Pipeline. |
| /docker | Containerization. |
| /payments | Payment Integration. |

## Content (4)

| Command | Description |
|---|---|
| /write | Writing Assistant. |
| /email | Email/Message Drafting. |
| /error-message | Write Good Error Messages. |
| /docs-as-code | Technical Writing. |

## Growth (5)

| Command | Description |
|---|---|
| /ab-test | Experiment Design. |
| /funnel | Funnel Analysis. |
| /retention | Retention Analysis. |
| /onboard-users | User Onboarding Design. |
| /seo | Technical SEO Audit. |

## Compliance (3)

| Command | Description |
|---|---|
| /privacy | Data Privacy Checklist. |
| /legal | Legal Checklist for Launch. |
| /security-response | When You Find a Vulnerability. |

## Decisions (4)

| Command | Description |
|---|---|
| /decision | Decision Framework. |
| /rfc | Request for Comments. |
| /negotiate | Negotiation Prep. |
| /delegate | Delegation Brief. |

## Performance (4)

| Command | Description |
|---|---|
| /perf-budget | Performance Budget. |
| /load-test | Load Testing. |
| /query | Database Query Optimization. |
| /reflexion | Use when output quality seems off, or after complex generation that might have errors. |

## Best Practices (11)

| Command | Description |
|---|---|
| /interview-me | Use when starting any feature larger than a quick fix. The AI interviews YOU — 5-9 hard questions, one at a time — then writes the spec. From Anthropic's official best practices. |
| /fresh | Use when context is degraded, or when starting a new task, or when you've corrected Claude twice on the same issue. |
| /two-sessions | Spec Session + Execution Session. |
| /parallel-compare | Use when there are 2-3 viable approaches and you're not sure which is best. Run parallel implementations on separate branches, then compare. |
| /claude-md-audit | Audit Your CLAUDE.md. |
| /subagent-pattern | Use when a task involves research, review, or exploration that would clutter the main context. Ad-hoc delegation to keep context clean. See also /subagent-driven for full plan execution. |
| /redo | Use when Claude's implementation is mediocre and incremental fixes aren't improving it — scrap and rebuild using lessons learned. |
| /grill | Adversarially review your own changes — find weak points, question assumptions, and block merge until satisfied. |
| /flywheel | Use when you want to systematically improve your AI-assisted development process. |
| /hooks-over-md | Use when you need 100% compliance on a rule, not 80%. |
| /context-budget | Strategies for spending the token window wisely. For a point-in-time capacity estimate, see /context-budget-check. |

## Workflows (5)

| Command | Description |
|---|---|
| /plan-mode | Use at the start of any complex task, or when you want Claude to think before acting. |
| /worktree | Use when you have 2+ independent tasks that can run simultaneously. Sets up parallel git worktrees. See also /worktree-aware for safety checks when already in worktrees. |
| /test-time-compute | Use when quality matters more than speed, or when one session keeps producing bugs. |
| /delegate-patterns | Use when deciding how much autonomy to give Claude for a task. |
| /monorepo-advantage | Use when structuring a new project, or when context fragmentation is causing problems. |

## Specialist Roles (51)

| Command | Description |
|---|---|
| /frontend-lead | Use when making frontend architecture decisions, evaluating frameworks, or reviewing component structure. |
| /backend-lead | Use when designing APIs, service architecture, or evaluating backend patterns. |
| /dba | Use when dealing with database performance, schema design, migrations, or data integrity issues. |
| /sre | Use when designing for reliability, defining SLAs, or setting up monitoring and incident response. |
| /mobile-lead | Use when building or reviewing mobile applications (iOS, Android, React Native, Flutter). |
| /ml-engineer | Use when building ML pipelines, evaluating models, or integrating AI features into products. |
| /devrel | Use when writing developer documentation, designing APIs for external consumers, or building developer experience. |
| /data-engineer | Use when designing ETL/ELT pipelines, data warehouses, or analytics infrastructure. |
| /qa-lead | Use when designing a test strategy, improving test coverage, or debugging test reliability. |
| /platform-lead | Use when building internal developer platforms, CI/CD, or developer tooling. |
| /ceo | Use when evaluating strategy, making company-level decisions, or thinking about vision and direction. |
| /coo | Use when optimizing processes, scaling operations, or fixing organizational bottlenecks. |
| /cmo | Use when developing marketing strategy, evaluating channels, or planning campaigns. |
| /vp-sales | Use when designing sales processes, evaluating go-to-market strategy, or building sales playbooks. |
| /bd | Use when evaluating partnerships, distribution deals, or strategic alliances. |
| /investor | Use when preparing for fundraising, evaluating term sheets, or thinking about what investors care about. |
| /pm-lead | Use when defining product strategy, prioritizing roadmaps, or aligning teams on product direction. |
| /account-mgr | Use when designing customer retention strategies, upsell frameworks, or handling at-risk accounts. |
| /copywriter | Use when writing landing pages, ads, emails, or any copy that needs to persuade. |
| /brand | Use when defining brand positioning, voice, or visual identity direction. |
| /content-strategist | Use when planning content marketing, editorial calendars, or content operations. |
| /ux-writer | Use when writing interface copy, onboarding flows, tooltips, empty states, or notifications. |
| /creative-director | Use when evaluating design work, giving creative feedback, or setting aesthetic direction. |
| /data-analyst | Use when exploring data, building dashboards, or answering business questions with data. |
| /data-scientist | Use when building models, running statistical tests, or designing experiments. |
| /bi-analyst | Use when designing dashboards, defining metrics, or building reporting systems. |
| /recruiter | Use when sourcing candidates, designing interview loops, or improving hiring funnels. |
| /hr-lead | Use when designing HR processes, handling org design, or thinking about culture and retention. |
| /coach | Use when thinking through leadership challenges, difficult conversations, or personal development. |
| /facilitator | Use when planning workshops, offsites, retrospectives, or any group decision-making session. |
| /l-and-d | Use when designing training programs, onboarding curricula, or skill development paths. |
| /paid-ads | Use when designing ad campaigns, optimizing spend, or evaluating ad performance across any paid channel. |
| /social-media | Use when planning social content, evaluating platform strategy, or building community. |
| /email-marketing | Use when designing email campaigns, automations, or improving email performance. |
| /pr | Use when planning press outreach, writing press releases, or managing communications crises. |
| /growth-hacker | Use when designing viral loops, referral programs, or growth experiments. |
| /support-lead | Use when designing support processes, evaluating support quality, or reducing ticket volume. |
| /cs-lead | Use when designing customer success programs, health scoring, or reducing churn. |
| /community-mgr | Use when building developer communities, managing forums, or designing community programs. |
| /ip-lawyer | Use when evaluating IP strategy, patent questions, licensing, or trademark issues. |
| /employment-lawyer | Use when designing employment agreements, contractor relationships, or HR policies. |
| /compliance-officer | Use when evaluating regulatory requirements, designing compliance programs, or preparing for audits. |
| /saas-advisor | Use when building or evaluating a SaaS business model. |
| /marketplace-advisor | Use when building or evaluating a two-sided marketplace. |
| /fintech-advisor | Use when building products that touch money, banking, or financial data. |
| /ecommerce-advisor | Use when building or optimizing an online store. |
| /healthcare-advisor | Use when building products that handle health data or serve healthcare providers. |
| /ai-product | Use when building AI-powered features or evaluating how to integrate AI into an existing product. |
| /scrum-master | Use when running sprints, stand-ups, retrospectives, or improving team velocity. |
| /ops-manager | Use when streamlining processes, managing vendor relationships, or scaling operations. |
| /procurement | Use when evaluating software vendors, SaaS tools, or service providers. |

## Latest (Boris Cherny) (9)

| Command | Description |
|---|---|
| /self-improve | Use after ANY correction to the AI's output, or when the AI makes a mistake. Converts the correction into one positive, reusable rule with a placement decision. |
| /babysit | Use when you have PRs in review, CI pipelines to watch, or recurring tasks to automate. |
| /verify-loop | Give Claude Verification Infrastructure (2-3x quality). |
| /plan-execute | Plan Mode → Auto-Accept (Boris's Core Pattern). |
| /lessons-md | Maintain a Living Lessons File. |
| /lsp | Use at project setup, or when you notice Claude missing obvious type errors. |
| /outcome | Use when defining what to build, to shift from "what code to write" to "what outcome to achieve." |
| /parallel-sessions | Use when you have multiple independent tasks, or when throughput matters more than depth. |
| /bmad | BMAD Framework for Substantial Projects. |

## Superpowers Pipeline (12)

| Command | Description |
|---|---|
| /1pct-rule | Use at the start of EVERY task, before any action including clarifying questions. |
| /no-placeholders | Use after writing any implementation plan, before execution. Scans for TBDs, ellipses, and unresolved choices; placeholders in acceptance criteria block, and each becomes a concrete question back to the user. |
| /subagent-driven | Use when executing a multi-task plan. Main agent spawns subagents for each task, then reviews their work in two stages. See also /subagent-pattern for ad-hoc research delegation. |
| /skill-priority | Use when there's a conflict between different instruction sources. |
| /tool-mapping | Use when running protocols across different harnesses (Claude Code, Codex, Gemini, Copilot, Cursor). |
| /find-duplicates | Use when refactoring, or when codebase feels bloated. |
| /verify-completion | Use BEFORE claiming any task is complete. Every acceptance criterion needs a VERIFIED row with the command run and its output — no evidence, not done. |
| /yagni-enforce | You Aren't Gonna Need It. |
| /evidence-over-claims | Use whenever Claude is about to claim something works. |
| /linear-pipeline | The Superpowers Linear Pipeline. |
| /skill-test-loop | Use when writing or improving any LunaStack protocol. |
| /visual-companion | Visual Brainstorm Mode. |

## GStack Team (16)

| Command | Description |
|---|---|
| /office-hours | Use at the START of every project, before /spec or any code. YC-partner interrogation of the stated request; ends within 6 exchanges in a verdict — build, reshape, or don't build. |
| /design-consultation | Build Design System From Scratch. |
| /design-shotgun | Use when you need to escape the first-idea trap on a UI design. |
| /design-html | HTML-First Design Pipeline. |
| /design-review | Use after building any user-facing surface, before shipping it. 80-item visual audit against live HTML with letter grades and AI-slop detection. |
| /codex-review | Cross-Model Independent Review. |
| /cso-audit | Full application security audit — OWASP Top 10 + STRIDE. For per-PR review of AI-generated changes, see /security-review. |
| /careful-mode | Warn Before Destructive. |
| /freeze | Use when debugging a specific module and you DON'T want Claude touching unrelated code. |
| /unfreeze | Release a directory lock previously set by /freeze, restoring normal file-edit permissions. |
| /investigate-frozen | Use when investigating a bug. Automatically /freezes to the relevant module so the investigation doesn't sprawl. |
| /team-install | Use when rolling out LunaStack to a team — no vendored files in the repo. |
| /readiness-dashboard | Review Status Dashboard. |
| /test-plan-handoff | Eng Review → QA Pipeline. |
| /global-retro | Retrospective Across All AI Tools. |
| /devex-review | Developer Experience Audit. |

## OpenClaw Patterns (10)

| Command | Description |
|---|---|
| /skill-security-audit | Use BEFORE installing any third-party skill or protocol from a community registry. |
| /sandbox-design | Use when designing or installing skills that need filesystem, network, or shell access. |
| /memory-isolation | Use when a multi-project Claude setup risks cross-contamination. |
| /skill-review-system | Use when accepting community contributions to a LunaStack-style framework. |
| /multi-llm-routing | Use when working across multiple AI models (Claude, GPT, Gemini, local). |
| /persistent-memory | Use when designing multi-session AI workflows where context should survive across days/weeks. |
| /messaging-interface | Use when designing AI agent operations through messaging platforms (Signal, Telegram, Discord, WhatsApp, Slack). |
| /vibe-coding-warnings | Use when the temptation arises to "vibe code" — accept AI output without reading it. |
| /local-model-fallback | Use when designing systems that should work offline or with privacy constraints. |
| /platform-skills-architecture | Use when authoring skills to maximize their power and progressive disclosure. |

## Multi-Host (8)

| Command | Description |
|---|---|
| /platform-detect | Use at session start to know what platform you're running on, what tools are available, and what limitations exist. |
| /tool-translate | Use when porting a protocol from one platform to another. |
| /session-bootstrap | Initialize Session Context. |
| /worktree-aware | Use when running parallel sessions across multiple worktrees. Safety checks to prevent cross-worktree mistakes. See also /worktree for initial setup. |
| /sandbox-fallback | Use when running in restricted environments (CI, sandboxed containers, etc.). |
| /env-detection | Use at session start to understand what's available. |
| /universal-skill | Use when authoring a new protocol that should work on all platforms. |
| /host-config | Use when LunaStack needs to behave differently on different platforms. |

## Security Skills (8)

| Command | Description |
|---|---|
| /cve-scan | Scan for Known Vulnerabilities. |
| /supply-chain-audit | Use when adding new dependencies, or auditing existing ones. |
| /codeql-semgrep | Static Analysis Integration. |
| /threat-db | CVE-Mapped Vulnerability Database. |
| /malicious-skill-detection | Detect Malicious Skills/Plugins. |
| /sbom | Software Bill of Materials. |
| /dependency-typosquat | Detect Typosquat Attacks. |
| /secret-rotation-plan | Use when designing systems that handle credentials. |

## Frontier — Original LunaStack Research (10)

| Command | Description |
|---|---|
| /ralph-loop | Use for large tasks that will exhaust the context window. Decomposes work into atomic units, commits after each, resets context between units. Based on the Ralph Wiggum Loop pattern (2026). |
| /context-budget-check | Use when a session is getting long, quality is dropping, or before starting a complex task. Estimates remaining context capacity and recommends continue/compact/fresh. For ongoing budget strategy, see /context-budget. |
| /security-review | Use before merging any PR or deploying any feature. Code-level review targeting AI-generated vulnerability patterns and trust boundaries. For a full application audit (OWASP Top 10 + STRIDE), see /cso-audit. |
| /agent-orchestra | Use when a task benefits from multiple specialized agents working in parallel. Hierarchical multi-agent orchestration. |
| /drift-detect | Use periodically to detect when AI behavior has drifted from project conventions. |
| /cost-tracker | Track and optimize AI development spend — tokens, model tiers, cost-per-feature. For infra cost, see /cost. |
| /silent-failure-audit | Use after any significant AI code generation to catch the subtle defects AI creates. Research shows AI code creates 1.7x more issues than human code, with most being plausible-but-wrong patterns that pass human review. |
| /ai-provenance | Use when shipping AI-generated code to production. EU AI Act compliance and provenance tracking. |
| /graceful-escalation | Use when the AI cannot solve a problem confidently. Defines when and how to stop and hand back to a HUMAN with structured context, rather than producing low-confidence output. For AI-to-AI session continuity, see /handoff. |
| /perception-gap | Use periodically to check whether AI is actually making you faster. Combats the measured speed illusion. |
