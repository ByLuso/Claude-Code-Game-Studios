extends Node2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Estructura simple para poder probar la distincion Severo/Reducido de Core
# Rule 6 -- omitida en la primera version de este spike. Sin costo/compra en
# este prototipo (ya existe desde el inicio); en el diseno real es una
# estructura comprable (ver farm-economy-system.md 3.7).

const RADIO: float = 130.0

func _ready() -> void:
	add_to_group("refugio")
	queue_redraw()

func protege(punto: Vector2) -> bool:
	return global_position.distance_to(punto) <= RADIO

func _draw() -> void:
	draw_arc(Vector2.ZERO, RADIO, 0.0, TAU, 48, Color(0.6, 0.85, 0.75, 0.5), 3.0)
	draw_string(ThemeDB.fallback_font, Vector2(-30, -RADIO - 10), "Refugio")
