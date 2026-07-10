# Game-Dev Skills

The game-development domain has two halves:

**General gamedev craft** — engine-agnostic foundations (`game-loop-architecture`,
`ecs-architecture`, `multiplayer-netcode`, `game-balancing-methodology`,
`procedural-generation`, `game-telemetry-analytics`, `game-ai-behavior-trees`,
`level-design-principles`, `game-audio-design`, `shader-programming`) plus
engine-specific architecture (`unity-architecture`, `unreal-architecture`,
`godot-architecture`).

**Health × games safety** — skills for building **health and medical content into
games**, written for projects like **LunaCelsus** (a game integrating medical
themes) and any serious/health-adjacent game. They bridge two LunaStack
strengths: the personal-health domain's safety-by-construction discipline
(`wiki/skills/health/`) and shipping-quality product craft.

## The premise

Games teach — whether you design for it or not. A game that shows CPR teaches CPR
(correctly or dangerously), a game that gamifies eating teaches eating habits
(sustainably or harmfully), and a game that depicts a mental-health crisis either
hands players a resource (988) or leaves them alone with it. These skills make the
teaching deliberate and the failure modes designed-out.

## The three health×games skills

- **`health-game-content-review`** — audit pass for any game shipping medical/health
  content: accuracy of depicted procedures, dangerous-imitability screening,
  crisis-resource inclusion, stigma checks, and the "entertainment, not medical
  advice" boundary.
- **`health-education-game-design`** — designing games that *intend* to teach health
  behaviors: learning objectives sourced from real guidance, mechanics that reward
  accuracy, and the anti-dark-pattern rules (no shame streaks, no disordered-eating
  mechanics dressed as fitness).
- **`medical-simulation-mechanics`** — building simulation mechanics (triage, vitals,
  first-aid sequences) that are directionally faithful without pretending to certify:
  the fidelity-vs-fun ladder and the "bridge out" pattern pointing players at real
  training.

## The contract these skills enforce

1. **In-game medical content is entertainment/education, never medical advice** —
   and says so where players will see it.
2. **Nothing dangerously imitable ships** — depicted procedures are either accurate
   enough to be safe or abstracted enough to be un-followable; never a wrong
   procedure rendered credibly.
3. **Crisis-adjacent content carries real resources** — self-harm, overdose, or
   crisis depictions surface real-world help (**988**, local equivalents) the way
   responsible studios and broadcasters do.
4. **Health mechanics are audited for the habits they train** — streaks, meters, and
   scores get reviewed as behavioral interventions, because that's what they are.

## Using the health domain as game content

The 80+ skills in `wiki/skills/health/` are structured, safety-gated,
plain-language explanations of real health actions — which makes them strong source
material for in-game codices, tutorial text, and NPC dialogue in a medical game.
If you adapt them: keep the disclaimers and escalation paths intact (they're the
load-bearing part), and run the result through `health-game-content-review`.
