# Skill Wiki — Build Roadmap

The build plan for the verified skill library. Each skill is generated in a
**draft → adversarial-verify → structural-validate** wave; only skills that pass
verification are committed. Check a box when its wave lands and passes.

**Status:** Wave 1 generating. Legend: `[x]` verified & committed · `[~]` in current wave · `[ ]` planned.

---

## Wave 1 — Infra / Backend / Data / AI / Security gaps (40) `[~]`
Cloud: kubernetes-operations, terraform-iac, serverless-architecture, edge-computing, multi-region-failover, cloud-cost-optimization.
Backend: graphql-api-design, grpc-services, event-sourcing, cqrs-pattern, saga-distributed-transactions, idempotency-design, webhook-reliability, api-gateway-design, rate-limiter-design.
Data: vector-database-design, data-pipeline-design, data-quality-checks, redis-caching-patterns, database-sharding, read-replica-strategy, time-series-data.
AI: rag-architecture, mcp-server-build, prompt-engineering, embedding-strategy, model-evaluation, fine-tuning-strategy, agent-memory-design, llm-cost-optimization.
Ops: distributed-tracing, log-aggregation, slo-design, alerting-strategy, oncall-runbook.
Security: dast-testing, smart-contract-audit, zero-trust-architecture, oauth-implementation.
Frontend: websocket-realtime.

## Wave 2 — Language experts (39) `[x]` DONE
python, typescript, go, rust, java, csharp, ruby, php, swift, kotlin, cpp, scala, elixir, haskell, sql, bash-scripting, lua, dart, r-lang, julia, clojure, erlang, ocaml, zig, solidity, powershell, objective-c, fsharp, nim, crystal, groovy, perl, cobol-modernization, fortran-scientific, ada-safety, assembly, wasm, regex-mastery, jq-processing, yaml-config.

## Wave 3 — Frameworks & libraries (40) `[ ]`
react, nextjs, vue, svelte, sveltekit, angular, solidjs, remix, astro, nuxt, qwik, htmx, express, fastapi, django, flask, rails, laravel, spring-boot, dotnet-core, gin, nestjs, phoenix, actix, tailwind, shadcn-ui, react-native, flutter, swiftui, jetpack-compose, electron, tauri, three-js, d3-visualization, pytorch, tensorflow, langchain, langgraph, prisma-orm, drizzle-orm.

## Wave 4 — Testing & QA (35) `[ ]`
playwright, cypress, jest, vitest, pytest, junit5, selenium, webdriverio, k6-load-test, locust, contract-testing, mutation-testing, property-based-testing, snapshot-testing, visual-regression, accessibility-testing, fuzz-testing, integration-testing, e2e-strategy, test-data-management, flaky-test-triage, test-pyramid, coverage-strategy, api-mocking, browser-automation, appium-mobile, performance-testing, chaos-testing, smoke-testing, regression-suite, bdd-cucumber, tdd-discipline, test-doubles, ci-test-parallelism, golden-testing.

## Wave 5 — Cloud platforms & DevOps (35) `[ ]`
aws-architecture, gcp-architecture, azure-architecture, cloudflare-workers, vercel-deploy, netlify-functions, docker-optimization, kubernetes-security, helm-charts, argocd-gitops, github-actions, gitlab-ci, jenkins-pipeline, ansible-config, pulumi-iac, service-mesh-istio, nginx-config, envoy-proxy, cdn-strategy, dns-management, load-balancing, autoscaling-design, blue-green-deploy, canary-analysis, secrets-management, vault-config, container-registry, image-scanning, cost-anomaly-detection, finops-practice, disaster-recovery, backup-strategy, infra-drift-detection, terragrunt, crossplane.

## Wave 6 — Data engineering & analytics (35) `[ ]`
airflow-orchestration, dbt-transforms, spark-processing, kafka-streaming, flink-streaming, snowflake-modeling, bigquery-optimization, clickhouse-olap, duckdb-analytics, postgres-tuning, mysql-tuning, mongodb-modeling, cassandra-modeling, elasticsearch-tuning, data-warehouse-design, lakehouse-architecture, cdc-replication, data-catalog, data-lineage, data-contracts, schema-evolution, partitioning-strategy, materialized-views, olap-cube-design, feature-store, reverse-etl, data-observability, great-expectations, data-mesh, streaming-joins, exactly-once-semantics, columnar-storage, parquet-optimization, iceberg-tables, data-governance.

## Wave 7 — AI/ML engineering (35) `[ ]`
transformer-finetuning, lora-adapters, quantization, distillation, rlhf-pipeline, dpo-alignment, eval-harness-design, prompt-caching, structured-output, function-calling, tool-use-design, multi-agent-orchestration, agent-eval, guardrails-design, hallucination-mitigation, semantic-caching, hybrid-search, reranking, chunking-strategy, context-window-management, streaming-responses, batch-inference, gpu-optimization, model-serving-vllm, onnx-export, tensorrt, feature-engineering, hyperparameter-search, experiment-tracking, model-registry, ab-test-ml, drift-detection-ml, shadow-deployment, embeddings-viz, vector-index-tuning.

## Wave 8 — Frontend & design (30) `[ ]`
web-performance-audit, core-web-vitals, bundle-optimization, code-splitting, ssr-hydration, island-architecture, state-management, form-validation, animation-performance, css-architecture, responsive-images, font-loading, pwa-offline, web-accessibility-audit, design-token-system, component-api-design, storybook-driven, micro-frontends, i18n-localization, dark-mode-theming, focus-management, keyboard-nav, aria-patterns, color-contrast, motion-reduced, skeleton-loading, optimistic-ui, infinite-scroll, virtualized-lists, drag-drop-ux.

## Wave 9 — Product, growth & ops (30) `[ ]`
roadmap-prioritization, okr-design, north-star-metric, activation-funnel, onboarding-optimization, pricing-strategy, paywall-design, referral-loop, viral-coefficient, cohort-analysis, ltv-modeling, cac-payback, experiment-design, feature-flagging-rollout, dogfooding-process, user-research-synthesis, jobs-to-be-done, positioning-strategy, gtm-launch, sales-enablement, churn-prediction, nps-program, support-deflection, community-building, developer-relations, api-docs-quality, changelog-discipline, status-page-comms, postmortem-culture, capacity-planning.

## Wave 10+ — Domain-specialized (30+) `[ ]`
fintech-compliance, payments-pci, healthcare-hipaa, blockchain-defi, game-netcode, embedded-firmware, iot-fleet, geospatial-gis, robotics-ros, voice-agent-design, ar-vr-spatial, e-commerce-checkout, marketplace-dynamics, saas-multitenancy, cms-headless, seo-technical-audit, email-deliverability, video-streaming, real-time-collaboration, crdt-sync, p2p-networking, webrtc-media, browser-extension, cli-tool-design, sdk-design, plugin-architecture, licensing-strategy, open-source-governance, accessibility-compliance, privacy-engineering.

---

## Totals

| Wave | Domain | Skills | Status |
|---|---|---:|---|
| 1 | Infra/backend/data/AI/security gaps | 40 | generating |
| 2 | Languages | 39 | DONE ✓ |
| 3 | Frameworks | 40 | planned |
| 4 | Testing & QA | 35 | planned |
| 5 | Cloud & DevOps | 35 | planned |
| 6 | Data engineering | 35 | planned |
| 7 | AI/ML engineering | 35 | planned |
| 8 | Frontend & design | 30 | planned |
| 9 | Product/growth/ops | 30 | planned |
| 10+ | Domain-specialized | 30+ | planned |
| | **Planned total** | **~350** | |

Each wave is verified before commit. Re-run a wave's generator (see the workflow
scripts under the session's `workflows/scripts/`) to extend or refresh a domain.
Beyond ~350, the next tier is per-vendor/version depth (e.g. `react-19`,
`next-15-app-router`) drawn from the registries in [../registries.md](../registries.md).
