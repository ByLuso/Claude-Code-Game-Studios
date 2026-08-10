# Godot Breaking Changes (Post-4.3 → 4.7.1)

*Last verified: 2026-08-10*

This file covers API-level breaking changes across the versions the LLM's
training data does NOT reliably cover (4.4 through 4.7). Always check here
before assuming a 4.3-era API still behaves the same way.

## 4.6 → 4.7

Canonical source: [Upgrading from Godot 4.6 to 4.7](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html)

### Core
- `Object.is_class()` — parameter type changed from `String` to `StringName`.
- `ZIPPacker.start_file()` — gained optional `permissions` and `modified_time` parameters.
- `OptimizedTranslation.generate()` — return type changed from `void` to `bool`.

### 2D & 3D Particles
- `CPUParticles2D/3D.request_particles_process()` — gained optional `process_time_residual` parameter.
- `GPUParticles2D/3D.request_particles_process()` — gained optional `process_time_residual` parameter.
- Particle angular velocity corrections changed — particles using rotation will look subtly different than in 4.6.

### GUI / Control Nodes
- `Control.accessibility_live` — type changed to `AccessibilityServer.AccessibilityLiveMode`.
- `RichTextLabel.ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` — renamed to `UPDATE_WIDTH_UNIT`.
- `RichTextLabel.add_image()` / `update_image()` — width/height now `float`; `width_in_percent`/`height_in_percent` renamed to `width_unit`/`height_unit` with a type change.
- **Control offset transforms** changed how some anchored layouts resolve — retest menus and HUD layouts first (directly relevant to this project's economy/HUD panels).

### Text & Rendering
- `Font.find_variation()` — gained optional `palette_index` and `custom_colors` parameters.
- `Image.save_exr()` / `save_exr_to_buffer()` — gained optional color/linear value parameters.
- `RenderingServer.particles_request_process_time()` — `time` parameter renamed to `process_time`; gained `process_time_residual`.
- HDR/SDR output and clearcoat rendering fixes — retest if using HDR output or clearcoat materials.

### Animation
- `Animation.length` — type metadata changed from `float` to `double`.
- `AnimationNodeBlendSpace1D/2D.add_blend_point()` — gained optional `name` parameter.
- BlendSpace internals changed — projects reading BlendSpace internals directly need to retest blend behavior.

### Physics
- `PhysicsServer2D.body_set_shape_as_one_way_collision()` — gained optional `direction` parameter.
- `PhysicsServer2DExtension._body_set_shape_as_one_way_collision()` — gained a **required** `direction` parameter (breaking for any custom physics extension).

### Audio & XR
- `AudioEffectSpectrumAnalyzer.tap_back_pos` — property **removed**. Audio spectrum visualizer code using this property will break.
- `OpenXRExtensionWrapper._on_register_metadata()` — gained a **required** `interaction_profile_metadata` parameter.
- `OpenXRSpatialAnchorCapability.create_new_anchor()` — gained optional `next` parameter.

### Input
- Keyboard and mouse **device ID numbering scheme changed** — any code that hardcoded device IDs breaks.

### Shaders
- Shader preprocessor restrictions tightened — some macro patterns that compiled in 4.6 no longer compile in 4.7.

### Platform
- **OBB Android support removed.** Not relevant if this project targets standard Android export (APK/AAB), but flag if OBB expansion files were ever considered.

### Editor
- `EditorSceneFormatImporter` — multiple constants moved into the `ImportFlags` enum (`IMPORT_ANIMATION`, `IMPORT_SCENE`, etc.).
- `EditorVCSInterface._commit()` — gained a **required** `amend` parameter.

## 4.5 → 4.6

Canonical source: [Upgrading from Godot 4.5 to 4.6](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html)

- Jolt Physics became the **default** physics engine (was opt-in in 4.4/4.5).
- Glow rework — glow-related rendering settings and visuals changed; re-tune glow parameters if used.
- D3D12 became the default rendering driver on Windows (Vulkan still available).
- Inverse Kinematics (IK) nodes restored after being reworked — verify any Skeleton IK usage against current API.

## 4.4 → 4.5

Canonical source: [Upgrading from Godot 4.4 to 4.5](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.5.html)

- Accessibility support (AccessKit) introduced — new accessibility-related Control properties.
- Variadic function arguments added to GDScript.
- `@abstract` annotation introduced for abstract classes/methods.
- Shader baker introduced (ahead-of-time shader compilation) — affects shader load/compile workflow.
- SMAA anti-aliasing option added.

## Pre-4.4 (within LLM training data, ~up to 4.3)

Not covered here — the LLM's training data (cutoff May 2025) should be reasonably
reliable for 4.3-era and earlier APIs. If in doubt, verify with WebSearch anyway.
