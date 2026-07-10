# Skills Catalog — 140 categories, indexed July 2026

A cross-reference of the AI-skill ecosystem. Each category lists **notable/official
skills** that exist in the wild (from the registries in [registries.md](registries.md))
and the **LunaStack** skill that covers the same ground. "Top" = officially published
by the named vendor or featured across the major awesome-lists; where a precise
popularity rank isn't publicly verifiable we name notable entries rather than invent a
number. `LS:` = the LunaStack equivalent (or `—` = a gap LunaStack doesn't yet cover).

---

## A · Software Engineering — Core

1. **Code Review** — addyosmani/code-review-and-quality, rohitg00/Code-Reviewer agent, CodeRabbit, Qodo, PR-Agent. `LS: /verify, /codex-review`
2. **Debugging & Error Recovery** — addyosmani/debugging-and-error-recovery, Error-Detective agent. `LS: /debug`
3. **Refactoring** — Refactoring-Specialist agent, Legacy-Modernizer. `LS: /refactor`
4. **Code Simplification** — addyosmani/code-simplification. `LS: /simplify, /yagni-enforce`
5. **Unit Testing** — testmu/JUnit5, Pytest, Jest, Vitest, NUnit, xUnit, PHPUnit. `LS: /test, /tdd`
6. **Test-Driven Development** — addyosmani/test-driven-development, rohitg00/TDD-Mastery. `LS: /tdd`
7. **E2E / Browser Testing** — testmu/Playwright, Cypress, Selenium, WebdriverIO, TestCafe; addyosmani/browser-testing-with-devtools. `LS: /qa, /visual-check`
8. **API Testing** — testmu/API-testing, Reqnroll, SpecFlow. `LS: /api-contract`
9. **Test Automation Frameworks** — TestMu's 50+ (Appium, Cucumber, Robot Framework, Detox, Espresso, XCUITest…). `LS: /qa-lead`
10. **Performance Optimization** — addyosmani/performance-optimization, cloudflare/web-perf, Performance-Engineer agent. `LS: /optimize, /perf-budget, /load-test`
11. **Version Control / Git Workflow** — addyosmani/git-workflow-and-versioning, Git-Workflow-Manager agent. `LS: /dig`
12. **CI/CD & Automation** — addyosmani/ci-cd-and-automation, rohitg00/CI-CD-Pipelines. `LS: /ci`
13. **Code Documentation & ADRs** — addyosmani/documentation-and-adrs, Documentation-Engineer agent. `LS: /document, /docs-as-code`
14. **Observability & Instrumentation** — addyosmani/observability-and-instrumentation, Sentry skills, Langfuse/LangSmith. `LS: /monitor`
15. **Legacy Modernization / Migration** — addyosmani/deprecation-and-migration, Legacy-Modernizer agent. `LS: /migrate`

## B · Frontend & Mobile

16. **Frontend Design/Engineering** — addyosmani/frontend-ui-engineering, anthropics/frontend-design, google-labs/react-components. `LS: /implement-design, /frontend-lead`
17. **React** — rohitg00/React-Patterns, callstack/react-native, Frontend-Architect agent. `LS: /frontend-lead`
18. **Next.js** — vercel-labs/next-best-practices, next-cache-components, next-upgrade. `LS: —`
19. **Angular** — angular/angular-developer, angular-new-app. `LS: —`
20. **Vue / Svelte** — rohitg00 Vue & Svelte language agents. `LS: —`
21. **React Native** — callstack/react-native-best-practices, upgrading-react-native. `LS: /mobile-lead`
22. **Expo / Mobile Native** — expo/building-native-ui, expo-deployment, expo-ui-swift-ui, expo-ui-jetpack-compose (11). `LS: /mobile-lead`
23. **Flutter** — testmu/Flutter, Flutter language agent. `LS: /mobile-lead`
24. **shadcn/ui & Component Libraries** — google-labs-code/shadcn-ui, design-md. `LS: /design-system`
25. **Design Systems** — anthropics/theme-factory, figma-create-design-system-rules. `LS: /design-system`
26. **Accessibility (WCAG)** — rohitg00/Accessibility-WCAG, Accessibility-Specialist agent. `LS: /a11y, /responsive`
27. **Tailwind / Styling** — expo-tailwind-setup, community Tailwind skills. `LS: —`
28. **Web Performance / Core Web Vitals** — cloudflare/web-perf, addyosmani/performance-optimization. `LS: /perf-budget`
29. **WebSocket / Realtime** — rohitg00/WebSocket-Realtime, WebSocket-Engineer agent. `LS: /queue`
30. **Electron / Desktop** — Electron-Developer agent. `LS: —`

## C · Backend & APIs

31. **Backend Architecture** — Backend-Developer, Microservices-Architect agents. `LS: /backend-lead, /architect`
32. **API Design** — addyosmani/api-and-interface-design, rohitg00/API-Design-Patterns, API-Designer agent. `LS: /api-contract, /contract`
33. **GraphQL** — rohitg00/GraphQL-Design, GraphQL-Architect agent. `LS: —`
34. **Microservices** — rohitg00/Microservices-Design, Microservices-Architect agent. `LS: /architect`
35. **Event-Driven Architecture** — Event-Driven-Architect agent. `LS: /queue`
36. **Authentication** — better-auth/create-auth, providers, twoFactor, organization (7); rohitg00/Authentication-Patterns. `LS: /auth`
37. **Webhooks** — seb1n/Webhook-Setup, Stripe webhook skills. `LS: /payments`
38. **Payments** — stripe/stripe-best-practices, upgrade-stripe. `LS: /payments`
39. **Monorepo Architecture** — Monorepo-Architect, Monorepo-Tooling agents. `LS: /monorepo-advantage`
40. **API Gateway** — API-Gateway-Engineer agent. `LS: —`
41. **Rate Limiting / Reliability** — reliability patterns across backend agents. `LS: /backend-lead`
42. **Background Jobs / Queues** — hugging-face-jobs, queue patterns. `LS: /queue`

## D · Cloud, DevOps & Infrastructure

43. **Cloud Architecture** — microsoft/cloud-solution-architect, Cloud-Architect agent, rohitg00/AWS-Cloud-Patterns. `LS: /cost`
44. **Serverless** — cloudflare/workers-best-practices, wrangler, durable-objects, sandbox-sdk. `LS: —`
45. **Edge Functions** — netlify/netlify-edge-functions, functions, blobs. `LS: —`
46. **Vercel / Next Deploy** — vercel-labs/next-* , netlify-deploy. `LS: —`
47. **Docker** — rohitg00/Docker-Best-Practices, seb1n/Docker-Compose-Setup. `LS: /docker`
48. **Kubernetes** — rohitg00/Kubernetes-Operations, Kubernetes-Specialist agent, seb1n/Kubernetes-Deployment. `LS: —`
49. **Infrastructure as Code** — hashicorp Terraform skills (11), Terraform-Engineer agent. `LS: —`
50. **Platform Engineering** — Platform-Engineer agent. `LS: /platform-lead`
51. **SRE / Reliability** — SRE-Engineer agent. `LS: /sre`
52. **Incident Response** — Incident-Responder agent. `LS: /incident`
53. **Cloud Cost Optimization** — aws-cost-saver plugin (173 checks), neon egress-optimizer. `LS: /cost, /cost-tracker`
54. **Cloud Monitoring** — seb1n/Cloud-Monitoring, Sentry, Datadog-style skills. `LS: /monitor`
55. **Network Engineering** — Network-Engineer agent. `LS: —`
56. **Deployment / Release** — addyosmani/shipping-and-launch, Deployment-Engineer agent. `LS: /ship, /canary, /deploy-check, /rollback`

## E · Data & Databases

57. **Database Schema Design** — seb1n/Database-Schema-Design, sanity/content-modeling, Database-Admin agent. `LS: /data-model`
58. **Database Migration** — seb1n/Database-Migration, netlify-db. `LS: /migrate`
59. **Query Optimization** — supabase/postgres-best-practices, Database-Optimizer agent. `LS: /query`
60. **PostgreSQL** — neondatabase/neon-postgres, supabase/postgres-best-practices. `LS: /dba`
61. **OLAP / ClickHouse** — clickhouse/clickhouse-best-practices, architecture-advisor, chdb-sql (6). `LS: —`
62. **Redis / Caching** — rohitg00/Redis-Patterns. `LS: /cache`
63. **Vector Databases** — Vector-DB-Engineer agent; Chroma, Weaviate, Qdrant, Milvus, Pinecone. `LS: —`
64. **Data Engineering** — tinybirdco/tinybird-best-practices + SDK guidelines (4), ETL-Specialist agent. `LS: /data-engineer`
65. **Data Analysis** — seb1n/Data-Analysis, Julius AI, PandasAI, Data-Scientist agent. `LS: /data-analyst, /data-scientist`
66. **Data Cleaning** — seb1n/Data-Cleaning, Exploratory-Data-Analysis. `LS: —`
67. **Data Visualization** — seb1n/Data-Visualization, Data-Visualization agent. `LS: /bi-analyst`
68. **SQL Generation** — seb1n/SQL-Query-Generation, chdb-sql. `LS: /query`

## F · AI / ML / Agents

69. **Model Training** — seb1n/Model-Training, hugging-face-model-trainer, vision-trainer, fal-train. `LS: /ml-engineer`
70. **Model Deployment / MLOps** — seb1n/Model-Deployment, MLOps-Engineer agent. `LS: /ml-engineer`
71. **Hyperparameter Tuning** — seb1n/Hyperparameter-Tuning. `LS: —`
72. **Data Labeling** — seb1n/Data-Labeling. `LS: —`
73. **NLP** — NLP-Engineer agent, transformers.js. `LS: —`
74. **Computer Vision** — Computer-Vision agent, hugging-face-vision-trainer, fal-vision. `LS: —`
75. **HuggingFace / Transformers** — huggingface skills (13): hf-cli, datasets, evaluation, tool-builder, gradio. `LS: —`
76. **LLM API Integration** — google-gemini/gemini-api-dev, vertex-ai, openai skills, venice.ai (18). `LS: /claude-api-adjacent, /multi-llm-routing`
77. **Prompt Engineering** — rohitg00/Prompt-Engineering, Prompt-Engineer agent, google-labs/enhance-prompt. `LS: (LunaStack is a prompt system) /skill-priority`
78. **Context Engineering** — addyosmani/context-engineering, claude-mem plugin, Context-Manager agent. `LS: /context-budget, /context-budget-check, /ralph-loop`
79. **RAG / Retrieval** — RAGFlow, Mem0, Pathway; seb1n/Context-Retrieval, Context-Ranking. `LS: /persistent-memory, /search-memory`
80. **MCP Server Building** — anthropics/mcp-builder, microsoft/mcp-builder, MCP-Developer agent. `LS: /platform-skills-architecture`
81. **Agent Frameworks** — LangGraph, CrewAI, VoltAgent, cloudflare/agents-sdk, google ADK, Pydantic AI. `LS: /subagent-driven, /subagent-pattern`
82. **Multi-Agent Orchestration** — AutoGen, MetaGPT, OpenAI Agents SDK; Multi-Agent-Coordinator agent. `LS: /agent-orchestra`
83. **Image Generation** — fal-generate, fal-image-edit, replicate, google-labs; FLUX/Imagen/Midjourney. `LS: —`
84. **Audio / Speech / Music** — fal-audio, venice audio, ElevenLabs, Suno; Deepgram/AssemblyAI. `LS: —`
85. **Video Generation** — fal-video-edit, fal-lip-sync, remotion-dev/remotion; Veo/Kling/Sora/Runway. `LS: —`

## G · Security

86. **Security Audit** — addyosmani/security-and-hardening, Security-Auditor agent, trailofbits skills. `LS: /cso-audit, /security-review`
87. **SAST (Static Analysis)** — trailofbits/static-analysis, semgrep-rule-creator, variant-analysis. `LS: /codeql-semgrep`
88. **DAST (Dynamic Analysis)** — seb1n/Dynamic-Application-Security-Testing, burpsuite-project-parser. `LS: —`
89. **Dependency / Supply-Chain Scanning** — seb1n/Dependency-Scanning, Snyk Code, firebase-apk-scanner. `LS: /cve-scan, /supply-chain-audit, /sbom, /dependency-typosquat`
90. **Threat Modeling** — seb1n/Threat-Modeling, STRIDE skills. `LS: /threat-model`
91. **Penetration Testing** — PentestGPT, CAI, Penetration-Tester agent. `LS: /red-team`
92. **Smart Contract Security** — trailofbits/building-secure-contracts, constant-time-analysis, differential-review. `LS: —`
93. **Secret Management / Rotation** — secret-scanning skills. `LS: /secret-rotation-plan`
94. **AI Red-Teaming** — OWASP LLM Top 10 skills, Lakera. `LS: /red-team`
95. **Prompt Injection Defense** — Rebuff, LLM Guard, NeMo Guardrails. `LS: /prompt-injection-defense`
96. **AI Guardrails** — Guardrails AI, NeMo Guardrails, Lakera Guard, LLM Guard. `LS: /guard, /vibe-coding-warnings`

## H · Design & Creative

97. **Figma / Design Implementation** — figma/implement-design, generate-design, code-connect (7). `LS: /implement-design`
98. **Logo & Brand Design** — seb1n/Logo-Design, anthropics/brand-guidelines. `LS: /brand, /creative-director`
99. **Wireframing / User Flows** — seb1n/Wireframing, User-Flow-Mapping. `LS: /friction, /design-variants`
100. **Algorithmic / Generative Art** — anthropics/algorithmic-art, canvas-design. `LS: —`
101. **Video Editing / Motion** — remotion-dev/remotion, google-labs/remotion. `LS: —`
102. **3D / Modeling** — fal-3d, Meshy, Tripo AI. `LS: —`
103. **Document Generation** — anthropics/docx, pptx, xlsx, pdf; openai document skills. `LS: /document`
104. **Canvas / Web Artifacts** — anthropics/web-artifacts-builder, canvas-design. `LS: —`

## I · Product & Business

105. **Requirements / Interview** — addyosmani/interview-me, idea-refine. `LS: /interview-me, /inquiry, /office-hours`
106. **Spec-Driven Development** — addyosmani/spec-driven-development, source-driven-development. `LS: /spec, /no-placeholders`
107. **Planning / Task Breakdown** — addyosmani/planning-and-task-breakdown. `LS: /plan, /autoplan`
108. **Product Management** — Product-Manager agent, UX-Researcher. `LS: /pm-lead`
109. **Financial Modeling** — seb1n/Financial-Modeling, Financial-Report-Generation. `LS: /cfo`
110. **Legal / Contract Review** — seb1n/Contract-Review, License-Analysis, Legal-Advisor agent. `LS: /legal, /ip-lawyer, /employment-lawyer`
111. **Compliance & Governance** — Credo AI, IBM watsonx.governance, EU AI Act / NIST AI RMF skills, Compliance-Auditor agent. `LS: /compliance-officer, /ai-provenance`
112. **Privacy Policy / ToS** — seb1n/Privacy-Policy-Drafting, Terms-of-Service-Generation. `LS: /privacy`
113. **Technical Writing** — seb1n/Technical-Writing, Technical-Writer agent, sanity/seo-aeo. `LS: /write, /docs-as-code`

## J · Marketing, Sales & Customer Success

114. **SEO / AEO** — seb1n/SEO-Optimization, sanity/seo-aeo-best-practices, corey-haines/ai-seo. `LS: /seo`
115. **Content Strategy** — seb1n/Content-Strategy, Content-Strategist agent, sanity/content-experimentation. `LS: /content-strategist`
116. **Keyword Research** — seb1n/Keyword-Research. `LS: /seo`
117. **A/B Testing & Analytics** — corey-haines/a-b-testing, analytics; seb1n/Analytics-Reporting. `LS: /ab-test, /funnel`
118. **Social Media & Ad Creative** — seb1n/Social-Media-Posting, corey-haines/ad-creative. `LS: /social-media, /paid-ads`
119. **Lead Scoring / CRM Enrichment** — seb1n/Lead-Scoring, CRM-Data-Enrichment; Clay, Apollo.io. `LS: /account-mgr`
120. **Proposal / Battlecard Generation** — seb1n/Proposal-Generation, Competitive-Battlecard-Creation. `LS: /compete`
121. **Churn / Retention** — seb1n/Churn-Analysis, corey-haines/churn-prevention. `LS: /retention`
122. **Customer Support / Ticket Triage** — seb1n/Ticket-Triage, Intercom Fin, Zendesk AI, Customer-Success agent. `LS: /support-lead, /cs-lead`
123. **Knowledge Base** — seb1n/Knowledge-Base-Article-Writing, Onboarding-Playbook-Creation. `LS: /onboard-users`

## K · Productivity & Platform Ops

124. **Task Automation** — n8n, Zapier AI, Make, Activepieces; seb1n/Task-Automation. `LS: /flywheel`
125. **Google Workspace Ops** — googleworkspace CLI (17): gws-gmail, gws-sheets, gws-docs, gws-calendar, gws-slides. `LS: —`
126. **File Organization / Notes** — seb1n/File-Organization, Note-Taking. `LS: /snapshot, /handoff`
127. **Meeting / Scheduling** — seb1n/Meeting-Scheduler, Meeting-Transcription. `LS: /facilitator`
128. **WordPress** — WordPress skills (13): block-development, plugin-development, rest-api, performance, phpstan. `LS: —`
129. **CMS (Sanity)** — sanity-io/sanity-best-practices, content-modeling, seo-aeo (4). `LS: —`
130. **E-Commerce** — E-Commerce-Engineer agent, Shopify skills, typefully. `LS: /ecommerce-advisor`
131. **Research & Competitive Analysis** — Research-Analyst, Competitive-Analyst, Market-Researcher agents; STORM, GPT Researcher. `LS: /landscape, /market-size, /user-interview`

## L · Domain-Specialized

132. **Blockchain / Web3** — Blockchain-Developer agent, trailofbits secure-contracts. `LS: —`
133. **Game Development** — Game-Developer agent. `LS: —`
134. **Embedded / IoT** — Embedded-Systems, IoT-Engineer agents. `LS: —`
135. **Fintech** — Fintech-Engineer agent, Payment-Integration. `LS: /fintech-advisor`
136. **Healthcare Tech** — Healthcare-Engineer agent; Woebot, Wysa (therapy). `LS: /healthcare-advisor`
137. **Geospatial** — Geospatial-Engineer agent. `LS: —`
138. **Robotics** — Robotics-Engineer agent. `LS: —`
139. **Voice Assistants** — Voice-Assistant agent; ElevenLabs, Vapi, LiveKit Agents, Retell AI. `LS: —`
140. **Deep Research / Literature Review** — Claude/Gemini/ChatGPT Deep Research, Perplexity Pro; seb1n/Literature-Review, Deep-Research. `LS: /spike, /market-size`

---

## How LunaStack maps to the ecosystem

Of these 140 categories, LunaStack directly covers **~95** (marked `LS:`). The
consistent gaps are **vendor/framework-specific** skills (Next.js, Terraform,
Kubernetes, HuggingFace, Cloudflare) and **generative-media** (image/video/audio) —
by design: LunaStack is a *methodology* layer (how to think and work), not a
vendor-SDK reference. For framework specifics, install the official vendor skills
from [registries.md](registries.md) *alongside* LunaStack; they compose.

Gaps worth considering for future LunaStack skills: `/kubernetes`, `/terraform`,
`/graphql`, `/rag-design`, `/mcp-build`, `/observability` (distinct from /monitor).
