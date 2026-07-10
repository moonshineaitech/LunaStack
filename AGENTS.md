# AGENTS.md — LunaStack Skill Index

> 251 skills · 27 disciplines · 55 specialist roles
> Quick reference for all available `/commands`.

## Meta (8)

| Command | Description |
|---|---|
| /luna | Use at the beginning of any session to orient and route to the right protocol. Reads context, replies in three lines or fewer, routes — never does the work itself. |
| /init | Project Setup. |
| /status | Health Check. |
| /calibrate | Adjust Rigor. |
| /onboard | Use when joining a new project or starting work in an unfamiliar codebase. Ten-minute scan in a fixed order, producing a project map with danger zones. |
| /guard | Use when about to run or generate a shell command, DB migration, or config change that could destroy data, force-push a shared branch, or expose a secret — intercept it before it executes. |
| /second-opinion | Use when the user's plan contains an irreversible action, touches security-sensitive surface, or contradicts a constraint they stated earlier. Evidence-backed push-back with an alternative, then defer. |
| /audit-review | Process Check. |

## Inquiry (7)

| Command | Description |
|---|---|
| /inquiry | Use when the user has a vague idea but hasn't defined the problem clearly yet. Four questions asked one at a time, pushing for a real person and falsifiable evidence. |
| /thesis | Use when an inquiry brief or a vague product idea needs to be compressed into one falsifiable bet before any spec or code — turns a belief into a testable statement with a kill metric, a cheap test, and a pivot. |
| /scope | Scope Calibration. |
| /landscape | Use when evaluating the competitive landscape before building a product or feature — mapping who already exists, their evidence-backed strengths and gaps, and where your defensible wedge is. |
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
| /cost | Use when projecting infrastructure cost at 1x/10x/100x scale. For tracking AI/LLM API spend and cost-per-feature, see /cost-tracker. |

## Specification (6)

| Command | Description |
|---|---|
| /spec | Use when requirements are clear enough to write down but code hasn't started. Produces testable acceptance criteria, an edge-case checklist, and an explicit out-of-scope list. |
| /plan | Use when a spec is ready and needs to be broken into executable tasks. 2-5 minute tasks with exact files, done-checks, and a dependency graph. |
| /autoplan | Quick Plan. |
| /story | User Story Mapping. |
| /kpi | Use when defining measurable success criteria for a feature or project — set one primary metric, guardrails, and instrumentation before launch, not after. |
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
| /threat-model | Use when designing or reviewing any component that crosses a trust boundary or handles sensitive data — run a six-category STRIDE pass and produce a numerically ranked risk matrix with specific mitigations. |
| /chaos | Fault Injection. |
| /visual-check | Compare UI screenshots across breakpoints to catch visual regressions before merge. |
| /qa | Use when testing user flows, verifying UI behavior, or running manual QA passes. |

## Craft (7)

| Command | Description |
|---|---|
| /design-critique | Use when reviewing any UI, landing page, or component before ship, to catch generic AI-generated design. Flags the absence of intentionality — default fonts, formulaic layouts, temperature-less color — and demands a specific, concrete fix for every signal. |
| /design-system | Use when reviewing a UI codebase for token drift — hardcoded colors, magic-number spacing, or one-off components that bypass the design system — typically before a design review or a component-library release. |
| /design-variants | Use when a design decision is still open and the user benefits from seeing divergent directions as working code rather than one proposal — to choose from or combine. |
| /friction | Use when a user-facing flow (onboarding, signup, checkout, first-run) is built and you need to find where real users stall or abandon. Walks one flow step by step as a zero-context first-timer, logging friction, a fix, and drop-off risk per step. |
| /a11y | Use when auditing any user-facing flow (form, modal, checkout, nav) for keyboard and screen-reader access before shipping. Walk every tab stop as a keyboard-only and screen-reader user, grade each barrier, and return a usability verdict. |
| /responsive | Use after any layout, CSS, or component change that could affect rendering — audit responsive behavior across 375/768/1440/1920px for scroll, readability, touch targets, and layout quality. |
| /implement-design | Use when translating a design mockup, Figma frame, or screenshot into pixel-perfect code — you have a concrete visual reference to match against. |

## Delivery (8)

| Command | Description |
|---|---|
| /ship | Use when the user says ship, deploy, merge, or release. Four gates in strict order with explicit pass criteria; any gate fails, stop and report — never proceed to the next gate. |
| /canary | Use when promoting a deployment to production traffic in stages — new service, risky migration, schema change, or any release where a bad version would hit real users. Graduates through traffic tiers with explicit health gates and instant rollback triggers at every stage. |
| /deploy-check | Use immediately after a deploy reaches an environment, or when error rates move right after a release, to decide keep/rollback before walking away. |
| /rollback | Use when a fresh deployment is causing production issues and you must decide fast — revert or fix forward — then execute an emergency revert with communication and verification. |
| /monitor | Use when setting up or reviewing observability for a service — structured logging, metrics, and alerting — so failures surface in seconds and root cause in minutes. |
| /changelog | Use when preparing a release and you need categorized notes from the commit log — splits git history into a technical section (Added/Fixed/Changed/Breaking) and a plain-language user-facing section. |
| /incident | Use after any production incident, outage, or near-miss — run a blameless post-mortem with 5 Whys to find the systemic root cause and produce owned, dated prevention items. |
| /document | Use when generating documentation from code — READMEs, API docs, architecture guides, or runbooks. |

## Memory (7)

| Command | Description |
|---|---|
| /retro | Use after completing a feature or sprint to measure what happened with real data. Every claim must cite a specific session event; ends with one concrete experiment. |
| /learn | Use after any session where mistakes were made or patterns discovered. Extracts evidence-backed learnings with confidence scores, presented for human approval before anything is recorded. |
| /compound | Use after /learn approves learnings, or at end of session. Promotes validated learnings into persistent project instructions so every future session starts smarter. |
| /search-memory | Search conversation history, uploaded files, and project knowledge for prior decisions and context. |
| /handoff | Use at end of session to capture state so the next AI session can resume seamlessly. For handing off to a HUMAN when blocked, see /graceful-escalation. |
| /snapshot | Quick Checkpoint. |
| /evolve | Detect repeated workflow patterns and propose new slash-command protocols to automate them. |

## Leadership (8)

| Command | Description |
|---|---|
| /cfo | Use when a product, feature, or pricing decision needs a unit-economics verdict — setting a price, sizing burn and runway, or judging whether LTV:CAC and payback justify growth spend. |
| /pitch | Use when building or critiquing an investor pitch deck or fundraising narrative — a founder needs to raise money and has (or needs) a story. Seven-slide structure, slide-by-slide review. |
| /hiring | Use when defining a role to hire, writing a job spec, or designing an interview loop — before posting a req or opening a search. Produces a testable job spec with screen-out anti-patterns and a stage-by-stage interview plan. |
| /compete | Use when a competitor ships, prices, or repositions against you and the team feels the urge to react. Assess factually, then choose ignore / differentiate / match / leapfrog — never reflex-match. |
| /naming | Name Things Well. |
| /simplify | Reduce Complexity. |
| /postlaunch | Use when a feature or product just went live and you're in the first 24-48 hours -- watching error rates, support volume, and early user feedback to catch launch issues before they compound. |
| /prioritize | Use when a list of tasks, features, or bugs all look urgent and you must decide what to do now, schedule, delegate, or drop. Force-ranks by impact × urgency, cuts the bottom 30%, and assigns owners and deadlines to the top 3. |

## Research (5)

| Command | Description |
|---|---|
| /user-interview | Use when designing user-research interview questions to validate a product, feature, or problem with real people. Produces a guide that reveals actual behavior — past-tense and specific — instead of the flattering hypotheticals people volunteer. |
| /survey | Survey Design. |
| /persona | Use when a spec, feature, or product decision needs a concrete user to test against — especially when the team keeps saying "the user wants" without agreeing on who the user is. Produces 2-3 behavior-based personas as decision tools, not marketing bios. |
| /jobs-to-be-done | Use when deciding what to build, prioritizing a roadmap, or explaining why users adopt, switch, or churn — reframes features as the job customers hire a product to do (situation, motivation, outcome). |
| /market-size | Use when sizing a market, pressure-testing a startup idea's revenue potential, or a pitch/spec cites a TAM. Computes TAM/SAM/SOM bottom-up from real buyers and prices, not top-down percentages of a big number. |

## Infrastructure (8)

| Command | Description |
|---|---|
| /auth | Authentication Design. |
| /cache | Caching Strategy. |
| /queue | Message Queue Design. |
| /search | Search Implementation. |
| /feature-flag | Use when gating a new feature behind a runtime toggle — gradual rollout, A/B test, kill switch, or plan-tier entitlement — so code can turn on or off per-user or per-cohort without a redeploy. |
| /ci | Use when setting up, reviewing, or fixing a CI/CD pipeline — a new repo, slow or flaky builds, or before enabling auto-deploy to staging or production. |
| /docker | Use when writing, reviewing, or debugging a Dockerfile, docker-compose file, or container image before it is built or deployed. |
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
| /ab-test | Use when you're about to change a user-facing behavior and want to prove the effect instead of guessing. Designs a single-variable A/B test with a hypothesis, one primary metric, guardrails, and a powered sample size. |
| /funnel | Use when conversion is leaking between steps of a signup, onboarding, checkout, or activation flow and you need to find and fix the worst drop-off. Maps each step, quantifies drop, and targets the single biggest leak with a hypothesis and one experiment. |
| /retention | Use when analyzing whether users come back to a product or feature over time, diagnosing churn, or designing interventions to keep them — anytime someone asks "is this sticky?" or "why are users leaving?" |
| /onboard-users | Use when designing or reviewing a new-user onboarding flow — the path from signup to first value. Applies whenever a product's first-run experience, activation flow, empty states, or setup wizard is being built or evaluated. |
| /seo | Use when auditing a site or page for search-engine indexability and ranking — before a launch or redesign, or when investigating organic-traffic loss. Checks titles, canonicals, sitemaps, robots rules, Core Web Vitals, and structured data. |

## Compliance (3)

| Command | Description |
|---|---|
| /privacy | Use when a feature collects, stores, or shares user data, or before launching anything that touches personal, financial, or sensitive information. Audits the real data flows against GDPR/CCPA/COPPA obligations. |
| /legal | Use when a founder is preparing to launch a product or company and needs a pre-launch legal checklist to review with counsel — entity formation, ToS/privacy, IP ownership, and compliance (GDPR/CCPA/COPPA/PCI). Surfaces what to resolve before the first real user or dollar. |
| /security-response | Use when you have just discovered a live security vulnerability — exposed secret, exploitable endpoint, auth bypass, or data leak — and need to triage and contain it now. Incident-commander mode: mitigate first, investigate second. |

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
| /perf-budget | Use when starting a user-facing feature or reviewing a PR that adds JS/CSS/images/fonts or new API endpoints. Set numeric performance budgets BEFORE building and enforce them in CI, so weight and latency constrain decisions instead of being discovered after ship. |
| /load-test | Use when a system must be proven to hold under expected or peak traffic before a launch, capacity change, or performance-sensitive change. Plans smoke/load/stress/spike/soak profiles and reports measured throughput, latency percentiles, error rate, and the first bottleneck. |
| /query | Use when a query is slow, a page load blocks on the database, or EXPLAIN shows a sequential scan or nested loop on a large table. Profile with EXPLAIN ANALYZE, fix the root cause, and prove the speedup with measured before/after timings. |
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
| /context-budget | Use when sessions feel slow or Claude starts making mistakes mid-conversation. Strategies for spending the token window wisely. For a point-in-time capacity estimate, see /context-budget-check. |

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
| /design-consultation | Use when a project has no visual identity yet and UI work is about to begin — after /office-hours, before any HTML. Builds a design language from first principles instead of reaching for a template. |
| /design-shotgun | Use when you're about to build a UI screen and hold only one layout in your head — force structurally distinct alternatives before committing to the first idea. |
| /design-html | Use when mocking up or designing a user-facing screen and you want to bypass Figma and build directly in HTML with design tokens, producing testable, production-ready markup. |
| /design-review | Use after building any user-facing surface, before shipping it. 80-item visual audit against live HTML with letter grades and AI-slop detection. |
| /codex-review | Cross-Model Independent Review. |
| /cso-audit | Use for a full application security audit — OWASP Top 10 + STRIDE, systematic and scored. For per-PR code-level review of AI-generated changes, see /security-review. |
| /careful-mode | Use when about to run any command that irreversibly modifies state — rm -rf, git push --force, DROP/TRUNCATE/DELETE without WHERE, chmod 777, curl | bash, unbacked file overwrites, or untagged production deploys. |
| /freeze | Use when debugging a specific module and you DON'T want Claude touching unrelated code. |
| /unfreeze | Release a directory lock previously set by /freeze, restoring normal file-edit permissions. |
| /investigate-frozen | Use when investigating a bug. Automatically /freezes to the relevant module so the investigation doesn't sprawl. |
| /team-install | Use when rolling out LunaStack to a team — no vendored files in the repo. |
| /readiness-dashboard | Use when you are about to /ship and need to confirm every required review has actually run and passed. Renders all gates in one table and blocks the release until each conditional gate that applies to this change is cleared. |
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

## Security Skills (10)

| Command | Description |
|---|---|
| /red-team | Use when you have written authorization to security-test an AI/LLM system you own or are contracted to assess. Structured adversarial evaluation across the OWASP LLM Top 10, gated on authorization, with severity scoring and coordinated disclosure. Never for systems you don't own. |
| /prompt-injection-defense | Use when building or hardening an LLM application that ingests untrusted content — user text, tool/function results, retrieved documents, web pages, emails. Designs the trust boundaries and controls that stop injected instructions from being executed. The blue-team counterpart to /red-team. |
| /cve-scan | Use when preparing a release, merging a PR that adds or bumps dependencies, or auditing a project's dependency tree — any point where shipping code that pulls in a vulnerable package is possible. Scans every dependency (direct and transitive) for known CVEs. |
| /supply-chain-audit | Use when adding new dependencies, or auditing existing ones. |
| /codeql-semgrep | Use when wiring automated vulnerability scanners (CodeQL, Semgrep, SAST) into the dev loop, or before merging code that has no static-analysis gate. |
| /threat-db | Use when adding a dependency, before shipping a release, or on a scheduled security sweep — track CVEs affecting your stack, mitigations applied, and re-review dates in version control. |
| /malicious-skill-detection | Use before installing or updating any third-party skill, plugin, or extension — scan it for network calls, credential access, obfuscated payloads, and postinstall hooks before it touches the system. |
| /sbom | Use when preparing a release for enterprise or regulated customers, answering a security/compliance audit (SOC 2, FedRAMP), or when a contract requires a dependency manifest. Generates a CycloneDX or SPDX SBOM cataloging every direct and transitive dependency with pinned versions and licenses. |
| /dependency-typosquat | Use when about to install or add any package (npm/PyPI/gem/cargo) whose exact name you have not verified on the registry — especially names pasted from a chat message, issue, or LLM output. Detects typosquats, homoglyph swaps, and impostor authors before the install command runs. |
| /secret-rotation-plan | Use when designing or reviewing any system that stores, transmits, or authenticates with long-lived credentials -- API keys, DB passwords, signing keys, webhook secrets, cloud creds -- and needs a rotation schedule plus a zero-downtime cutover plan. |

## Frontier — Original LunaStack Research (10)

| Command | Description |
|---|---|
| /ralph-loop | Use for large tasks that will exhaust the context window. Decomposes work into atomic units, commits after each, resets context between units. Based on the Ralph Wiggum Loop pattern (2026). |
| /context-budget-check | Use when a session is getting long, quality is dropping, or before starting a complex task. Estimates remaining context capacity and recommends continue/compact/fresh. For ongoing budget strategy, see /context-budget. |
| /security-review | Use before merging any PR or deploying any feature. Code-level review targeting AI-generated vulnerability patterns and trust boundaries. For a full application audit (OWASP Top 10 + STRIDE), see /cso-audit. |
| /agent-orchestra | Use when a task benefits from multiple specialized agents working in parallel. Orchestrates hierarchical multi-agent execution with the cheapest effective model per subtask. |
| /drift-detect | Use periodically to detect when AI behavior has drifted from project conventions. Compares recent AI output against established patterns in CLAUDE.md and lessons.md. |
| /cost-tracker | Use to track and optimize AI development costs. Monitors token usage, model selection, and cost-per-feature across sessions. For infrastructure cost projection, see /cost. |
| /silent-failure-audit | Use after any significant AI code generation to catch the subtle defects AI creates. Research shows AI code creates 1.7x more issues than human code, with most being plausible-but-wrong patterns that pass human review. |
| /ai-provenance | Use when shipping AI-generated code to production, especially for EU AI Act compliance. Embeds provenance metadata (model, timestamp, prompt context) in code and git history. |
| /graceful-escalation | Use when the AI cannot solve a problem confidently. Defines when and how to stop and hand back to a HUMAN with structured context, rather than producing low-confidence output. For AI-to-AI session continuity, see /handoff. |
| /perception-gap | Use periodically to check whether AI is actually making you faster. METR's 2025 RCT found developers believed they were 20% faster with AI while actually being slower. This skill enforces measurement over perception. |
