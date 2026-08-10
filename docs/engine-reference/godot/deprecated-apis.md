# Godot Deprecated / Renamed APIs (Post-4.3 → 4.7.1)

*Last verified: 2026-08-10*

"Don't use X → Use Y" reference. Check this before suggesting any of the
left-hand-column APIs in generated GDScript.

| Don't Use (old / removed) | Use Instead | Since | Notes |
|---|---|---|---|
| `AudioEffectSpectrumAnalyzer.tap_back_pos` | (property removed — rework audio spectrum visualizer code without it) | 4.7 | Property was removed entirely, not renamed |
| `RichTextLabel` `width_in_percent` / `height_in_percent` params on `add_image()`/`update_image()` | `width_unit` / `height_unit` (float) | 4.7 | Type changed from implicit percent flag to float unit |
| `RichTextLabel.ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` | `UPDATE_WIDTH_UNIT` | 4.7 | Enum constant renamed |
| Hardcoded keyboard/mouse device IDs | Re-derive device IDs at runtime — numbering scheme changed | 4.7 | Do not assume device ID 0/1 stability across versions |
| `Object.is_class(String)` | `Object.is_class(StringName)` | 4.7 | Parameter type changed; passing a plain String still auto-converts in GDScript but prefer StringName explicitly |
| OBB expansion files (Android) | Standard AAB/APK asset packaging | 4.7 | OBB support removed |
| Opt-in Jolt Physics enable flag | Jolt is default; explicitly select GodotPhysics2D/3D if the old physics engine is required | 4.6 | Default engine changed, old default is now the non-default option |
| Old EditorSceneFormatImporter top-level import flag constants | `EditorSceneFormatImporter.ImportFlags.*` | 4.7 | Constants moved into nested enum |

## GDScript language features to prefer going forward (not deprecations, but post-cutoff additions)

| Old pattern | Prefer since | Why |
|---|---|---|
| Fixed-arity helper functions/overload workarounds | Variadic function arguments | 4.5 | Native variadic args reduce boilerplate |
| Duck-typed "abstract" base classes (convention only) | `@abstract` annotation | 4.5 | Enforces the contract at compile time instead of by convention |
| Custom on-screen touch controls built from scratch | `VirtualJoystick` node | 4.7 | Official, tested mobile touch input — evaluate before building custom joystick UI for this project |

## Verification protocol

Before generating GDScript that calls an unfamiliar or infrequently-used
engine API:
1. Check this file and `breaking-changes.md` first.
2. If the API isn't listed and you're uncertain it exists in 4.7.1, use
   WebSearch against `docs.godotengine.org` before writing the call.
