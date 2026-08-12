extends Node2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Compra de maquinas e infraestructura -- design/gdd/farm-economy-system.md
# 3.6/3.7. Simplificado: sin menu real, un toque compra el siguiente item
# disponible en orden (Sembradora, Cosechadora, luego tiers de Silo 1-3 una
# vez desbloqueados por ventas acumuladas). No pausa el juego (ya es cierto
# por construccion -- no hay pausa en ningun punto de este spike).

func _ready() -> void:
	add_to_group("interactuables")
	Silo.tier_comprado.connect(func(_t): queue_redraw())
	Silo.valor_cambio.connect(func(_v): queue_redraw())
	queue_redraw()

func accion_disponible() -> String:
	if not Maquinas.tiene_sembradora:
		return "Comprar Sembradora ($%d)" % Maquinas.COSTE_SEMBRADORA
	if not Maquinas.tiene_cosechadora:
		return "Comprar Cosechadora ($%d)" % Maquinas.COSTE_COSECHADORA
	if Silo.tier_disponible():
		return "Ampliar Silo tier %d ($%d)" % [Silo.tiers_comprados + 1, Silo.siguiente_coste_tier()]
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
	if Silo.tier_disponible():
		return Silo.comprar_tier()
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
