extends CharacterBody2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Implements the round-5 decision: single contextual action button, targets
# the nearest ELIGIBLE entity (not a fixed priority) -- design/gdd/amenazas.md
# UI Requirements, "Regla de seleccion".
#
# Updated: second local player added, matching rincon-compartido-concept's
# co-op pattern -- Pilar 1 (Compartido, no dividido) needs 2 players to
# actually test, and the first version of this spike deliberately cut that.

@export var player_id: int = 1
@export var speed: float = 220.0
@export var color: Color = Color.WHITE

const RANGO_ACCION: float = 90.0

var _prev_action_pressed: bool = false
var parcela_objetivo: Node = null

var _key_up: Key
var _key_down: Key
var _key_left: Key
var _key_right: Key
var _key_action: Key

func _ready() -> void:
	if player_id == 1:
		_key_up = KEY_W
		_key_down = KEY_S
		_key_left = KEY_A
		_key_right = KEY_D
		_key_action = KEY_E
	else:
		_key_up = KEY_UP
		_key_down = KEY_DOWN
		_key_left = KEY_LEFT
		_key_right = KEY_RIGHT
		_key_action = KEY_ENTER
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_physical_key_pressed(_key_right):
		dir.x += 1
	if Input.is_physical_key_pressed(_key_left):
		dir.x -= 1
	if Input.is_physical_key_pressed(_key_down):
		dir.y += 1
	if Input.is_physical_key_pressed(_key_up):
		dir.y -= 1
	velocity = dir.normalized() * speed
	move_and_slide()

	parcela_objetivo = _buscar_parcela_mas_cercana()
	queue_redraw()

	var pressed := Input.is_physical_key_pressed(_key_action)
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
	draw_circle(Vector2.ZERO, 14, color)
	draw_string(ThemeDB.fallback_font, Vector2(-18, -22), "J%d" % player_id)
	if parcela_objetivo:
		var hacia: Vector2 = (parcela_objetivo.global_position - global_position)
		var tecla: String = "E" if player_id == 1 else "ENTER"
		var etiqueta: String = parcela_objetivo.accion_disponible()
		draw_string(ThemeDB.fallback_font, Vector2(-40, -40), "[%s] %s" % [tecla, etiqueta])
		draw_line(Vector2.ZERO, hacia.limit_length(30.0), Color(color, 0.6), 2.0)
