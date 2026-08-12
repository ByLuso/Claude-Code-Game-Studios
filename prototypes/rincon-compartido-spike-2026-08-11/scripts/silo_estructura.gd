extends Node2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Estructura fisica del Silo -- design/gdd/farm-economy-system.md 3.7 exige
# presencia visual obligatoria (no cosmetica opcional). Un toque vende todo
# el contenido del silo compartido de una vez (ver silo.gd para la nota de
# por que no se modela la canalizacion de venta real de 1-2s).

const ANCHO: float = 50.0
const ALTO_SEGMENTO: float = 14.0

func _ready() -> void:
	add_to_group("interactuables")
	Silo.valor_cambio.connect(_on_cambio)
	Silo.tier_comprado.connect(_on_cambio)
	queue_redraw()

func _on_cambio(_x) -> void:
	queue_redraw()

func accion_disponible() -> String:
	if Silo.valor_actual <= 0:
		return ""
	return "Vender silo (+$%d)" % Silo.valor_actual

func ejecutar_accion() -> bool:
	if Silo.valor_actual <= 0:
		return false
	var vendido: int = Silo.vender_todo()
	Economia.ganar(vendido)
	return true

func _draw() -> void:
	# Base + un segmento visible por tier comprado (0 a 3 en este spike).
	var segmentos: int = 1 + Silo.tiers_comprados
	for i in range(segmentos):
		var y_top: float = -float(i) * ALTO_SEGMENTO
		draw_rect(Rect2(-ANCHO * 0.5, y_top - ALTO_SEGMENTO, ANCHO, ALTO_SEGMENTO), Color(0.55, 0.45, 0.3))
		draw_rect(Rect2(-ANCHO * 0.5, y_top - ALTO_SEGMENTO, ANCHO, ALTO_SEGMENTO), Color(0.3, 0.24, 0.15), false, 1.5)

	var capacidad: int = Silo.capacidad()
	var frac: float = 0.0 if capacidad <= 0 else float(Silo.valor_actual) / float(capacidad)
	var alto_total: float = float(segmentos) * ALTO_SEGMENTO
	draw_rect(Rect2(-ANCHO * 0.5 + 4, -alto_total * frac, ANCHO - 8, alto_total * frac), Color(0.9, 0.75, 0.3, 0.8))

	draw_string(ThemeDB.fallback_font, Vector2(-30, -alto_total - 12), "Silo")
	draw_string(ThemeDB.fallback_font, Vector2(-34, 24), "$%d / $%d" % [Silo.valor_actual, capacidad])
	if Silo.valor_actual >= capacidad:
		var parpadeo: float = 0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0)
		draw_rect(Rect2(-ANCHO * 0.5, -alto_total, ANCHO, alto_total), Color(1.0, 0.2, 0.15, parpadeo * 0.35))
