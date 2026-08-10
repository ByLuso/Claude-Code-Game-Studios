extends CharacterBody2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

@export var player_id: int = 1
@export var speed: float = 220.0
@export var color: Color = Color.WHITE

var nearby_crop: Node = null
var can_sell: bool = false
var _prev_action_pressed: bool = false

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

	var pressed := Input.is_physical_key_pressed(_key_action)
	if pressed and not _prev_action_pressed:
		_do_action()
	_prev_action_pressed = pressed

func _do_action() -> void:
	if nearby_crop:
		var harvested: int = nearby_crop.harvest()
		if harvested > 0:
			Economy.add_to_silo(harvested, player_id)
			return
		if nearby_crop.plant():
			return
		return
	elif can_sell:
		Economy.sell_silo()
	elif ThreatManager.state == ThreatManager.State.WARNING:
		ThreatManager.try_protect(player_id)
	elif ThreatManager.state == ThreatManager.State.ACTIVE:
		ThreatManager.try_repair(player_id)

func set_can_harvest(value: bool, patch: Node) -> void:
	nearby_crop = patch if value else null

func set_can_sell(value: bool) -> void:
	can_sell = value

func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, color)
	draw_string(ThemeDB.fallback_font, Vector2(-18, -22), "J%d" % player_id)
