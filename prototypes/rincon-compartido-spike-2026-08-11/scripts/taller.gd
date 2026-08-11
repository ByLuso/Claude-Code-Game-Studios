extends Node2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Compra de maquinas -- design/gdd/farm-economy-system.md 3.6. Simplificado:
# sin menu real, un toque compra la siguiente maquina disponible en orden
# (Sembradora primero, luego Cosechadora). No pausa el juego (ya es cierto
# por construccion -- no hay pausa en ningun punto de este spike).

func _ready() -> void:
	add_to_group("interactuables")
	queue_redraw()

func accion_disponible() -> String:
	if not Maquinas.tiene_sembradora:
		return "Comprar Sembradora ($%d)" % Maquinas.COSTE_SEMBRADORA
	if not Maquinas.tiene_cosechadora:
		return "Comprar Cosechadora ($%d)" % Maquinas.COSTE_COSECHADORA
	return ""

func ejecutar_accion() -> bool:
	if not Maquinas.tiene_sembradora:
		if not Economia.gastar(Maquinas.COSTE_SEMBRADORA):
			return false
		Maquinas.tiene_sembradora = true
		Maquinas.maquina_comprada.emit("Sembradora")
		queue_redraw()
		return true
	if not Maquinas.tiene_cosechadora:
		if not Economia.gastar(Maquinas.COSTE_COSECHADORA):
			return false
		Maquinas.tiene_cosechadora = true
		Maquinas.maquina_comprada.emit("Cosechadora")
		queue_redraw()
		return true
	return false

func _draw() -> void:
	draw_rect(Rect2(-35, -35, 70, 70), Color(0.5, 0.5, 0.55))
	draw_string(ThemeDB.fallback_font, Vector2(-25, -45), "Taller")
	if Maquinas.tiene_sembradora:
		draw_rect(Rect2(-55, 15, 20, 20), Color(0.7, 0.55, 0.2))
		draw_string(ThemeDB.fallback_font, Vector2(-60, 45), "Sembradora")
	if Maquinas.tiene_cosechadora:
		draw_rect(Rect2(35, 15, 20, 20), Color(0.55, 0.3, 0.2))
		draw_string(ThemeDB.fallback_font, Vector2(25, 45), "Cosechadora")
