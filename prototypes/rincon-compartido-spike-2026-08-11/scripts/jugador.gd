extends CharacterBody2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Implements the round-5 decision: single contextual action button, targets
# the nearest ELIGIBLE entity (not a fixed priority) -- design/gdd/amenazas.md
# UI Requirements, "Regla de seleccion".

@export var speed: float = 220.0

const RANGO_ACCION: float = 90.0

var _prev_action_pressed: bool = false
var parcela_objetivo: Node = null

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		dir.x += 1
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		dir.x -= 1
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		dir.y += 1
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		dir.y -= 1
	velocity = dir.normalized() * speed
	move_and_slide()

	parcela_objetivo = _buscar_parcela_mas_cercana()
	queue_redraw()

	var pressed := Input.is_physical_key_pressed(KEY_SPACE)
	if pressed and not _prev_action_pressed and parcela_objetivo:
		parcela_objetivo.ejecutar_accion()
	_prev_action_pressed = pressed

func _buscar_parcela_mas_cercana() -> Node:
	var candidatas := get_tree().get_nodes_in_group("parcelas")
	var mas_cercana: Node = null
	var mejor_dist: float = RANGO_ACCION
	for p in candidatas:
		if p.accion_disponible() == "":
			continue
		var d: float = global_position.distance_to(p.global_position)
		if d < mejor_dist:
			mejor_dist = d
			mas_cercana = p
	return mas_cercana

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14, Color(0.9, 0.7, 0.1))
	if parcela_objetivo:
		var hacia: Vector2 = (parcela_objetivo.global_position - global_position)
		var etiqueta: String = parcela_objetivo.accion_disponible()
		draw_string(ThemeDB.fallback_font, Vector2(-40, -22), "[ESPACIO] %s" % etiqueta)
		draw_line(Vector2.ZERO, hacia.limit_length(30.0), Color(1, 1, 1, 0.6), 2.0)
