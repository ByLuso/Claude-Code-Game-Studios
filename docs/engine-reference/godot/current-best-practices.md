# Godot Current Best Practices (Since LLM Training Cutoff, May 2025)

*Last verified: 2026-08-10*

Patterns and features introduced in Godot 4.4–4.7 that the LLM won't know
to reach for by default. Prefer these over older workarounds when writing
new GDScript for this project.

## Mobile & Touch Input (directly relevant — this project targets mobile)

- **`VirtualJoystick` node (4.7)**: official on-screen touch joystick node.
  Evaluate this before building a custom touch-drag input system for
  movement or camera control. Ships as part of the standard node set, not
  an addon.
- Godot's mobile export pipeline received general polish in 4.7 (Android
  workflow improvements). Re-check current export template requirements
  against the official docs when setting up CI/build, since guidance from
  before mid-2025 may reference an outdated export template process.

## GDScript Language

- **Variadic function arguments** (4.5+): use native `...args` style
  variadic parameters instead of manually overloading functions with
  optional arguments for "any number of args" cases.
- **`@abstract` annotation** (4.5+): mark base classes/methods intended to
  be overridden as `@abstract` instead of relying on comments or `push_error()`
  convention checks. Gives compile-time enforcement.
- Continue enforcing **static typing** on all new GDScript per this
  project's coding standards — this predates the training cutoff but
  remains the single highest-leverage GDScript practice.

## Physics

- **Jolt Physics is the default physics engine as of 4.6** (was opt-in
  before). Do not assume GodotPhysics2D/3D is active by default — verify
  project settings if physics behavior seems unexpected, especially for
  any 3D physics (not the primary concern for this 2D project, but relevant
  if physics-based UI/feedback is ever added).

## Rendering

- **D3D12 is the default rendering driver on Windows as of 4.6** (Vulkan
  remains available/selectable). Not directly relevant to mobile export,
  but relevant if a PC build is ever produced for testing.
- This project is pinned to the **Compatibility (Mobile) renderer** —
  confirm any suggested rendering API/feature actually exists on the
  Compatibility renderer, not just on Forward+ (which is desktop-oriented
  and not this project's target).
- **Glow rework (4.6)**: if using the Glow post-process effect, current
  glow parameters/behavior differ from pre-4.6 tutorials — verify against
  current docs rather than older glow tutorials.

## UI / Control Nodes

- **Control offset transforms (4.7)**: enables UI "juice" (transform-based
  animation on Control nodes) without fighting the anchor/layout system.
  Useful for this project's economy HUD, resource counters, and
  automation-placement UI feedback. Also changes how some anchored
  layouts resolve — test menu/HUD layouts after any Control offset
  transform is applied.
- Many editor popups/dropdowns now support **dynamic search** (type to
  filter) — an editor-workflow improvement, not a runtime API change.

## Accessibility

- **AccessKit-based accessibility support** was introduced in 4.5.
  `accessibility_live` and related Control properties are new since the
  training cutoff — consult `breaking-changes.md` for the 4.7 type change
  on `Control.accessibility_live`. Cross-reference with the project's
  `accessibility-specialist` agent when building UI.

## Asset Pipeline

- Godot's **official asset store** launched in 4.7 and is gradually
  replacing the older Asset Library. Prefer it when recommending
  third-party addons, but always verify an addon's actual Godot version
  compatibility before recommending it for this 4.7.1 project.
