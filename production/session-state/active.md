# Session State

## Current Task
Concept prototype for "Rincón Compartido" — validating the shared-economy /
threat-response co-op loop.

## Progress Checklist
- [x] Game concept written (`design/gdd/game-concept.md`)
- [x] Engine configured (Godot 4.7.1, GDScript — `/setup-engine`)
- [x] Prototype scope defined and confirmed with user
- [x] Prototype implemented (`prototypes/rincon-compartido-concept/`)
- [x] Playtest debrief completed
- [x] REPORT.md written (`prototypes/rincon-compartido-concept/REPORT.md`)
- [x] PROCEED/PIVOT/KILL verdict recorded — **PROCEED** (with note: add
      content breadth — shop/plots/upgrades — sooner than "full vision")

## Key Decisions
- Prototype path: **Engine** (Godot), not Paper — user wants an interactive movable
  world, not a rules-only test.
- Falsifiable hypothesis: "If two players share one account and must decide
  together in real time how to invest between growth and threat protection,
  they will feel the interdependence as engaging — we'll know if, after a
  threat event, both players actively negotiate the response instead of one
  ignoring the other."
- Riskiest assumption being tested: shared-economy interdependence is fun, not
  frustrating (not harvesting feel, not real networking).
- Co-op mode for this prototype: **local hotseat / split-screen on one device**
  (two control schemes, one machine) — NOT real wifi networking. A local
  prototype can't validate networked feel anyway (per prototype methodology),
  so real local-wifi networking is deferred to a later technical spike.

## Prototype Scope (confirmed)
**In scope**: player movement in a small world, harvesting 1 resource type
(crops), shared economy (single money pool), 1 threat event (plague reduces
crop yield over time, preventable/repairable by spending money), 2-player
local hotseat co-op.

**Explicitly cut**: conveyor belts / hireable workers (automation), multiple
resource types, real wifi networking, menus/art polish/audio.

## Files Being Worked On
- `prototypes/rincon-compartido-concept/` (to be created)

## Open Questions
- Real local-wifi networking feasibility — deferred to a future technical
  spike, not this prototype.

## Current Phase
Concept prototype cycle complete (PROCEED). Next recommended: `/design-review
design/gdd/game-concept.md`, `/gate-check`, `/map-systems`, then
`/design-system [mechanic]` — using the prevent/repair pattern and the
early-content-breadth lesson from REPORT.md.
