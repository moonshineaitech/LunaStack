import { useState, useEffect } from "react";

const C = { bg:"#08090d", s1:"#0e1018", s2:"#151722", b:"#1e2133", h:"#232740", sil:"#9ca3bf", moon:"#c8cfe0", w:"#e8ecf4", a:"#d4a24e", ad:"#a07832" };

const D = [
  { n:"Meta", i:"◑", s:["/luna — session start + intelligent routing","/init — project bootstrap","/status — health dashboard","/calibrate — solo/team/enterprise rigor","/onboard — codebase orientation in 10 min","/guard — destructive command safety net","/second-opinion — evidence-based pushback","/audit-review — process pattern analysis"]},
  { n:"Inquiry", i:"◍", s:["/inquiry — 4-question problem discovery","/thesis — falsifiable product thesis","/scope — expand / hold / contract / pivot","/landscape — competitive gap analysis","/premortem — imagine failure, work backward","/spike — timeboxed investigation","/brief — executive summary ≤300 words"]},
  { n:"Architecture", i:"△", s:["/architect — system design + ADRs","/data-model — schema + indexes + migration","/api-contract — REST/GraphQL + OpenAPI","/contract — behavioral interface contracts","/tradeoff — weighted decision matrix","/dependency — package eval before install","/debt-audit — quantified tech debt","/cost — infra cost at 1x/10x/100x"]},
  { n:"Specification", i:"▭", s:["/spec — acceptance criteria + edge cases","/plan — 2-5 min tasks + dependency graph","/autoplan — description → plan in one command","/story — user story mapping + RICE priority","/kpi — success metrics + instrumentation","/estimate — three-point with risk factors"]},
  { n:"Construction", i:"⬡", s:["/tdd — red→green→refactor enforced","/build — task-by-task implementation","/batch — parallel worktree execution","/pair — navigator / driver / rubber duck","/debug — reproduce → isolate → root-cause → verify","/explain — 3-level deep: conceptual → mechanical → subtle","/trace — end-to-end request tracing with timing","/dig — git archaeology before changing code","/refactor — behavioral preservation proof","/optimize — benchmark-driven, keep or revert","/migrate — phased + rollback + integrity checks","/test — diff-aware test generation","/reflexion — self-correction loop"]},
  { n:"Verification", i:"◇", s:["/verify — 6 parallel review agents + verdict","/threat-model — STRIDE per trust boundary","/chaos — fault injection testing","/visual-check — screenshot regression × 4 viewports","/qa — browser-based flow testing"]},
  { n:"Craft", i:"◎", s:["/design-critique — anti-AI-slop detector","/design-system — token audit + drift report","/design-variants — 3 distinct directions to compare","/friction — UX friction log as first-time user","/a11y — keyboard + screen reader walkthrough","/responsive — viewport verification","/implement-design — pixel-precision from design"]},
  { n:"Delivery", i:"▸", s:["/ship — 4-gate: test→review→security→approve","/canary — staged rollout with rollback triggers","/deploy-check — post-deploy health verification","/rollback — decide-in-5-minutes framework","/monitor — logs + RED/USE metrics + alerting","/changelog — release notes (technical + user)","/incident — blameless post-mortem + 5-whys","/document — README, API docs, runbooks"]},
  { n:"Memory", i:"∞", s:["/retro — quantified retrospective + trends","/learn — extract patterns with confidence","/compound — auto-update system from learnings","/search-memory — query past context","/handoff — session state for resume","/snapshot — 30-sec checkpoint, 4 lines","/evolve — auto-generate protocols from patterns"]},
  { n:"Leadership", i:"★", s:["/cfo — unit economics + pricing + burn","/pitch — 7-slide investor structure","/hiring — job spec + interview plan","/compete — ignore/differentiate/match/leapfrog","/naming — 5 options evaluated for clarity","/simplify — what can we remove?","/postlaunch — first 48h monitoring","/prioritize — 2×2 matrix, cut bottom 30%"]},
  { n:"Research", i:"🔬", s:["/user-interview — behavioral questions only","/survey — statistically rigorous design","/persona — decision-tool user profiles","/jobs-to-be-done — functional+emotional+social","/market-size — bottom-up TAM/SAM/SOM"]},
  { n:"Infrastructure", i:"🔧", s:["/auth — authentication + security checklist","/cache — 4-layer caching + invalidation","/queue — message queue reliability design","/search — search implementation by scale","/feature-flag — lifecycle + targeting + cleanup","/ci — pipeline <10 min: lint→test→build→deploy","/docker — Dockerfile review checklist","/payments — idempotency + webhooks + PCI"]},
  { n:"Content", i:"📝", s:["/write — cut filler, active voice, lead with conclusion","/email — 5-sentence max, purpose→ask→context→next","/error-message — what happened + why + what to do","/docs-as-code — tutorial/how-to/reference/explanation"]},
  { n:"Growth", i:"📊", s:["/ab-test — hypothesis + sample size + run to completion","/funnel — step-by-step conversion + biggest drop","/retention — cohort D1/D7/D30 + churn analysis","/onboard-users — time-to-value + activation metric","/seo — technical audit: meta, CWV, structure"]},
  { n:"Compliance", i:"🔐", s:["/privacy — data inventory + GDPR/CCPA checklist","/legal — pre-launch: entity, ToS, IP, compliance","/security-response — vulnerability triage + immediate actions"]},
  { n:"Decisions", i:"🧠", s:["/decision — options + criteria + one-way/two-way door","/rfc — request for comments for team decisions","/negotiate — BATNA + ZOPA + walk-away prep","/delegate — context transfer: task, authority, done-when"]},
  { n:"Performance", i:"⚡", s:["/perf-budget — FCP/LCP/CLS/INP + JS/CSS budgets","/load-test — smoke/load/stress/spike/soak profiles","/query — EXPLAIN ANALYZE → index → measure"]},
  { n:"Best Practices", i:"🎯", s:["/interview-me — Claude interviews YOU before building","/fresh — start clean sessions per task","/two-sessions — spec session + execution session","/parallel-compare — parallel branches, compare approaches","/claude-md-audit — keep CLAUDE.md <200 lines","/subagent-pattern — delegate research to subagents","/redo — scrap and rebuild with full knowledge","/grill — challenge-driven: prove it works","/flywheel — bugs → improved rules → better agent","/hooks-over-md — 100% enforcement via hooks","/context-budget — manage your 200K token window"]},
  { n:"Workflows", i:"🧰", s:["/plan-mode — read-only exploration first","/worktree — parallel git worktrees","/test-time-compute — multiple contexts for quality","/delegate-patterns — fully delegate vs guide closely","/monorepo-advantage — one repo = full AI context"]},
  { n:"Latest (Boris)", i:"🔥", s:["/self-improve — self-improvement loop after every correction","/babysit — automated PR shepherding via /loop","/verify-loop — give Claude verification infra (2-3x quality)","/plan-execute — plan mode then auto-accept","/lessons-md — maintain a living lessons file","/lsp — install LSP plugins (highest-impact)","/outcome — outcome engineering (o16g manifesto)","/parallel-sessions — multi-session setup","/bmad — BMAD framework for substantial projects"]},
  { n:"Superpowers Pipeline", i:"🌀", s:["/1pct-rule — invoke skill if even 1% chance it applies","/no-placeholders — zero tolerance plan validation","/subagent-driven — subagent-driven development","/skill-priority — instruction priority order","/tool-mapping — cross-platform tool translation","/find-duplicates — semantic code duplication detection","/verify-completion — verification before done","/yagni-enforce — you aren't gonna need it","/evidence-over-claims — show, don't tell","/linear-pipeline — the superpowers linear pipeline","/skill-test-loop — TDD for skills","/visual-companion — visual brainstorm mode"]},
  { n:"GStack Team", i:"🏗️", s:["/office-hours — YC partner office hours","/design-consultation — build design system from scratch","/design-shotgun — multiple HTML variants","/design-html — HTML-first design pipeline","/design-review — 80-item visual audit","/codex-review — cross-model independent review","/cso-audit — CSO security audit (OWASP + STRIDE)","/careful-mode — warn before destructive","/freeze — lock edits to one directory","/unfreeze — release directory lock","/investigate-frozen — debug with auto-freeze","/team-install — auto-updating team setup","/readiness-dashboard — review status dashboard","/test-plan-handoff — eng review to QA pipeline","/global-retro — retrospective across all AI tools","/devex-review — developer experience audit"]},
  { n:"OpenClaw Patterns", i:"🔬", s:["/skill-security-audit — vet community skills before installing","/sandbox-design — permission whitelists for skills","/memory-isolation — per-project memory boundaries","/skill-review-system — community skill vetting","/multi-llm-routing — use the right model for the job","/persistent-memory — cross-session memory architecture","/messaging-interface — chat-driven agent operation","/vibe-coding-warnings — when NOT to ship unread code","/local-model-fallback — graceful local model use","/platform-skills-architecture — skills as folders, not files"]},
  { n:"Multi-Host", i:"🌐", s:["/platform-detect — identify the current host","/tool-translate — translate tool names across platforms","/session-bootstrap — initialize session context","/worktree-aware — work safely in git worktrees","/sandbox-fallback — detect and adapt to sandbox limitations","/env-detection — detect all environment capabilities","/universal-skill — write skills that work everywhere","/host-config — per-platform configuration"]},
  { n:"Security Skills", i:"🛡️", s:["/cve-scan — scan for known vulnerabilities","/supply-chain-audit — verify dependency integrity","/codeql-semgrep — static analysis integration","/threat-db — CVE-mapped vulnerability database","/malicious-skill-detection — detect malicious skills/plugins","/sbom — software bill of materials","/dependency-typosquat — detect typosquat attacks","/secret-rotation-plan — credential rotation strategy"]},
  { n:"Specialist Roles", i:"🎭", s:["Engineering: /frontend-lead /backend-lead /dba /sre /mobile-lead /ml-engineer /devrel /data-engineer /qa-lead /platform-lead","Business: /ceo /coo /cmo /vp-sales /bd /investor /pm-lead /account-mgr","Creative: /copywriter /brand /content-strategist /ux-writer /creative-director","Data: /data-analyst /data-scientist /bi-analyst","People: /recruiter /hr-lead /coach /facilitator /l-and-d","Marketing: /paid-ads /social-media /email-marketing /pr /growth-hacker","Customer: /support-lead /cs-lead /community-mgr","Legal: /ip-lawyer /employment-lawyer /compliance-officer","Domain: /saas-advisor /marketplace-advisor /fintech-advisor /ecommerce-advisor /healthcare-advisor /ai-product","Operations: /scrum-master /ops-manager /procurement"]},
];
const total = D.reduce((a,d)=>a+d.s.length,0);

export default function App(){
  const [open,setOpen]=useState(null);
  const [v,setV]=useState(false);
  useEffect(()=>{setTimeout(()=>setV(true),80)},[]);
  return(
  <div style={{fontFamily:"'DM Sans',system-ui,sans-serif",background:C.bg,color:C.sil,minHeight:"100vh",overflow:"auto"}}>
  <style>{`
    @import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=DM+Sans:wght@300;400;500;600&family=IBM+Plex+Mono:wght@400;500&display=swap');
    *{box-sizing:border-box;margin:0;padding:0}
    ::selection{background:${C.a};color:${C.bg}}
    .row:hover{background:${C.h}!important}
    ::-webkit-scrollbar{width:4px}
    ::-webkit-scrollbar-thumb{background:${C.b};border-radius:2px}
  `}</style>

  <header style={{maxWidth:720,margin:"0 auto",padding:"56px 24px 0",opacity:v?1:0,transform:v?"none":"translateY(16px)",transition:"all 0.7s ease"}}>
    <div style={{display:"flex",alignItems:"center",gap:10,marginBottom:36}}>
      <div style={{width:30,height:30,borderRadius:"50%",border:`1.5px solid ${C.a}`,display:"flex",alignItems:"center",justifyContent:"center"}}>
        <span style={{fontFamily:"'Cormorant Garamond',serif",fontSize:15,color:C.a,fontStyle:"italic"}}>◑</span>
      </div>
      <span style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:10,letterSpacing:3,textTransform:"uppercase",color:C.sil}}>LunaStack</span>
      <span style={{marginLeft:"auto",fontFamily:"'IBM Plex Mono',monospace",fontSize:9,color:C.ad,border:`1px solid ${C.b}`,padding:"3px 10px",borderRadius:12}}>works in claude.ai</span>
    </div>
    <h1 style={{fontFamily:"'Cormorant Garamond',serif",fontSize:"clamp(34px,5.5vw,54px)",fontWeight:400,lineHeight:1.1,letterSpacing:-1,color:C.w}}>
      AI development that <em style={{color:C.a,fontWeight:500}}>compounds</em>
    </h1>
    <div style={{width:36,height:1.5,background:C.a,margin:"20px 0"}}/>
    <p style={{fontSize:13,lineHeight:1.7,color:C.sil,maxWidth:440}}>
      239 protocols. 55 specialist roles. 26 disciplines. Every session feeds the next. One Markdown file.
    </p>
  </header>

  <div style={{maxWidth:720,margin:"0 auto",padding:"32px 24px 0",opacity:v?1:0,transition:"opacity 0.7s ease 0.2s"}}>
    <div style={{display:"grid",gridTemplateColumns:"repeat(4,1fr)",borderTop:`1px solid ${C.b}`,borderBottom:`1px solid ${C.b}`}}>
      {[{v:"239",l:"Protocols"},{v:"26",l:"Disciplines"},{v:"55",l:"Roles"},{v:"197KB",l:"Package"}].map((s,i)=>(
        <div key={i} style={{padding:"16px 0",textAlign:"center",borderRight:i<3?`1px solid ${C.b}`:"none"}}>
          <div style={{fontFamily:"'Cormorant Garamond',serif",fontSize:26,fontWeight:600,color:C.w}}>{s.v}</div>
          <div style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:8,letterSpacing:2,textTransform:"uppercase",color:C.ad,marginTop:3}}>{s.l}</div>
        </div>
      ))}
    </div>
  </div>

  <section style={{maxWidth:720,margin:"0 auto",padding:"40px 24px 0"}}>
    <div style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:9,letterSpacing:3,textTransform:"uppercase",color:C.a,marginBottom:16}}>All 26 Disciplines</div>
    <div style={{display:"flex",flexDirection:"column",gap:1}}>
      {D.map((d,i)=>{
        const isOpen=open===i;
        return(<div key={i}>
          <div className="row" onClick={()=>setOpen(isOpen?null:i)} style={{
            display:"grid",gridTemplateColumns:"28px 1fr auto 20px",alignItems:"center",
            padding:"10px 12px",background:isOpen?C.h:C.s1,border:`1px solid ${isOpen?C.ad+"55":C.b}`,
            borderRadius:3,gap:8,cursor:"pointer",transition:"all 0.15s"
          }}>
            <span style={{fontSize:15,color:isOpen?C.a:C.sil,textAlign:"center"}}>{d.i}</span>
            <div>
              <span style={{fontSize:13,fontWeight:500,color:C.w}}>{d.n}</span>
              <span style={{fontSize:11,color:C.sil,marginLeft:6}}>{d.s.length}</span>
            </div>
            <span/>
            <span style={{fontSize:12,color:C.sil,transform:isOpen?"rotate(45deg)":"none",transition:"transform 0.2s"}}>+</span>
          </div>
          {isOpen&&<div style={{background:C.s2,border:`1px solid ${C.b}`,borderTop:"none",borderRadius:"0 0 3px 3px",padding:"2px 0"}}>
            {d.s.map((item,j)=>{
              const dash=item.indexOf(" — ");
              const cmd=dash>-1?item.slice(0,dash):item;
              const desc=dash>-1?item.slice(dash+3):"";
              return(<div key={j} style={{display:"grid",gridTemplateColumns:desc?"110px 1fr":"1fr",padding:"7px 14px",gap:8,borderBottom:j<d.s.length-1?`1px solid ${C.b}22`:"none",alignItems:"baseline"}}>
                <code style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:11,fontWeight:500,color:C.a}}>{cmd}</code>
                {desc&&<span style={{fontSize:11,color:C.sil,lineHeight:1.4}}>{desc}</span>}
              </div>);
            })}
          </div>}
        </div>);
      })}
    </div>
  </section>

  <section style={{maxWidth:720,margin:"0 auto",padding:"40px 24px 56px"}}>
    <div style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:9,letterSpacing:3,textTransform:"uppercase",color:C.a,marginBottom:14}}>Use It</div>
    <p style={{fontSize:13,color:C.moon,lineHeight:1.6,marginBottom:14,maxWidth:460}}>
      <strong style={{color:C.w}}>Easiest:</strong> Download LunaStack.md → Claude Project → type /inquiry
    </p>
    <div style={{background:C.s1,border:`1px solid ${C.b}`,borderRadius:4,padding:"14px 16px",fontFamily:"'IBM Plex Mono',monospace",fontSize:11,lineHeight:2,color:C.moon}}>
      <span style={{color:C.ad+"88"}}>  # Claude Code</span><br/>
      <span style={{color:C.ad}}>$</span> git clone https://github.com/moonshineaitech/LunaStack ~/lunastack<br/>
      <span style={{color:C.ad}}>$</span> cd ~/lunastack && ./setup.sh --global<br/>
      <span style={{color:C.ad}}>$</span> claude <span style={{color:C.moon}}>"/luna"</span>
    </div>
    <div style={{width:36,height:1.5,background:C.a,margin:"36px 0 14px"}}/>
    <p style={{fontFamily:"'Cormorant Garamond',serif",fontSize:17,fontStyle:"italic",color:C.w,lineHeight:1.5}}>
      Software development is a discipline. Treat it like one.
    </p>
    <div style={{fontFamily:"'IBM Plex Mono',monospace",fontSize:8,color:C.b,letterSpacing:3,marginTop:18}}>LUNASTACK · MIT · 2026</div>
  </section>
  </div>);
}
