# Godot Engine — Version Reference

| Field | Value |
|-------|-------|
| **Engine Version** | Godot 4.7.1 |
| **Release Date** | July 2026 (4.7.1 patch: August 2026) |
| **Project Pinned** | 2026-08-10 |
| **Last Docs Verified** | 2026-08-10 |
| **LLM Knowledge Cutoff** | May 2025 |
| **Risk Level** | HIGH — version is well beyond LLM training data |

## Knowledge Gap Warning

The LLM's training data likely covers Godot up to ~4.3. Versions 4.4, 4.5,
4.6, and 4.7 introduced significant changes that the model does NOT know about.
Always cross-reference this directory before suggesting Godot API calls.

## Post-Cutoff Version Timeline

| Version | Release | Risk Level | Key Theme |
|---------|---------|------------|-----------|
| 4.4 | ~Mid 2025 | MEDIUM | Jolt physics option, FileAccess return types, shader texture type changes |
| 4.5 | ~Late 2025 | HIGH | Accessibility (AccessKit), variadic args, @abstract, shader baker, SMAA |
| 4.6 | Jan 2026 | HIGH | Jolt default, glow rework, D3D12 default on Windows, IK restored |
| 4.7 | Jul 2026 | HIGH | Official VirtualJoystick node (mobile), AreaLight3D, Control offset transforms/UI juice, dynamic search in popups/dropdowns, official asset store |

## Project-Relevant Notes (Rincón Compartido — 2D mobile co-op tycoon)

- **VirtualJoystick** (new in 4.7): official mobile touch input node — evaluate for
  on-screen movement/interaction controls before building a custom touch input system.
- **Control offset transforms** (new in 4.7): useful for UI juice on economy/HUD panels,
  but changes how some anchored layouts resolve — retest any menu/HUD layout carefully.
- Rendering method pinned in `technical-preferences.md` is **Compatibility (Mobile
  renderer)** — verify any suggested rendering API against Compatibility-renderer
  support, not Forward+ (which is 4.6+ default on desktop, not mobile-first).

See `breaking-changes.md` and `deprecated-apis.md` in this directory for the
version-by-version API-level detail, and `current-best-practices.md` for
patterns introduced since the LLM's training cutoff.

## Verified Sources

- Official docs: https://docs.godotengine.org/en/stable/
- 4.6→4.7 migration: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html
- 4.5→4.6 migration: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html
- 4.4→4.5 migration: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.5.html
- Changelog: https://github.com/godotengine/godot/blob/master/CHANGELOG.md
- Release notes: https://godotengine.org/releases/4.7/
- Godot 4.7 feature overview: https://godotlearning.com/blog/godot-4-7-whats-new
