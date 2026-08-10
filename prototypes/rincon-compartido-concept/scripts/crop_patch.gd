extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

enum GrowthState { EMPTY, GROWING, READY }

const NUM_LOCUSTS: int = 8

@export var grow_time: float = 6.0
@export var harvest_yield: int = 3

var growth_state: GrowthState = GrowthState.EMPTY
var growth_progress: float = 0.0
var blighted: bool = false
var warning_active: bool = false
var _pulse_time: float = 0.0
var _warning_progress: float = 0.0
var _locust_angles: Array[float] = []
var _locust_start_dist: Array[float] = []

func _ready() -> void:
	ThreatManager.register_crop_patch(self)
	ThreatManager.state_changed.connect(_on_threat_state_changed)
	ThreatManager.warning_time_left.connect(_on_warning_time)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()

func _on_threat_state_changed(state_name: String) -> void:
	warning_active = (state_name == "WARNING")
	if warning_active:
		_generate_locust_swarm()
	queue_redraw()

func _on_warning_time(seconds_left: float) -> void:
	_warning_progress = clampf(1.0 - (seconds_left / ThreatManager.WARNING_DURATION), 0.0, 1.0)
	queue_redraw()

func _generate_locust_swarm() -> void:
	_warning_progress = 0.0
	_locust_angles.clear()
	_locust_start_dist.clear()
	for i in range(NUM_LOCUSTS):
		_locust_angles.append(randf() * TAU)
		_locust_start_dist.append(randf_range(160.0, 240.0))

func _on_body_entered(body: Node) -> void:
	if body.has_method("set_can_harvest"):
		body.set_can_harvest(true, self)

func _on_body_exited(body: Node) -> void:
	if body.has_method("set_can_harvest"):
		body.set_can_harvest(false, null)

func set_blighted(value: bool) -> void:
	blighted = value
	if blighted and growth_state != GrowthState.EMPTY:
		growth_state = GrowthState.EMPTY
		growth_progress = 0.0
	queue_redraw()

func plant() -> bool:
	if blighted or growth_state != GrowthState.EMPTY:
		return false
	growth_state = GrowthState.GROWING
	growth_progress = 0.0
	queue_redraw()
	return true

func harvest() -> int:
	if growth_state != GrowthState.READY or blighted:
		return 0
	growth_state = GrowthState.EMPTY
	growth_progress = 0.0
	queue_redraw()
	return harvest_yield

func _process(delta: float) -> void:
	_pulse_time += delta
	if growth_state == GrowthState.GROWING and not blighted:
		growth_progress += delta / grow_time
		if growth_progress >= 1.0:
			growth_progress = 1.0
			growth_state = GrowthState.READY
		queue_redraw()
	if warning_active:
		queue_redraw()

func _draw() -> void:
	var base_rect := Rect2(-40, -40, 80, 80)
	draw_rect(base_rect, Color(0.36, 0.26, 0.16))

	if blighted:
		_draw_broken_plant()
		draw_string(ThemeDB.fallback_font, Vector2(-38, -55), "PLAGA - replanta")
	else:
		match growth_state:
			GrowthState.EMPTY:
				draw_string(ThemeDB.fallback_font, Vector2(-40, -48), "Tierra vacía (acción = plantar)")
			GrowthState.GROWING:
				_draw_plant(growth_progress, false)
				draw_string(ThemeDB.fallback_font, Vector2(-38, -55), "Creciendo %d%%" % int(growth_progress * 100))
			GrowthState.READY:
				_draw_plant(1.0, true)
				draw_string(ThemeDB.fallback_font, Vector2(-38, -55), "¡LISTO! (acción = cosechar)")

	if warning_active:
		_draw_locust_swarm()

func _draw_plant(progress: float, ready: bool) -> void:
	var height: float = lerpf(4.0, 46.0, progress)
	var stem_color: Color = Color(0.3, 0.55, 0.15)
	draw_line(Vector2(0, 20), Vector2(0, 20 - height), stem_color, 4.0)

	if progress > 0.25:
		var leaf_progress: float = clampf((progress - 0.25) / 0.5, 0.0, 1.0)
		var leaf_size: float = lerpf(0.0, 14.0, leaf_progress)
		var leaf_y: float = 20 - height * 0.55
		draw_line(Vector2(0, leaf_y), Vector2(-leaf_size, leaf_y - leaf_size * 0.6), stem_color, 3.0)
		draw_line(Vector2(0, leaf_y), Vector2(leaf_size, leaf_y - leaf_size * 0.6), stem_color, 3.0)

	var bud_color: Color = Color(0.98, 0.85, 0.15) if ready else Color(0.5, 0.8, 0.2)
	var bud_radius: float = lerpf(3.0, 12.0, progress)
	draw_circle(Vector2(0, 20 - height), bud_radius, bud_color)

func _draw_broken_plant() -> void:
	var wilt_color: Color = Color(0.35, 0.28, 0.15)
	draw_line(Vector2(-10, 25), Vector2(8, -5), wilt_color, 4.0)
	draw_line(Vector2(8, -5), Vector2(-4, -20), wilt_color, 3.0)
	draw_circle(Vector2(-4, -20), 5.0, Color(0.4, 0.3, 0.15))
	draw_circle(Vector2(-14, 5), 3.5, Color(0.15, 0.1, 0.05))
	draw_circle(Vector2(12, 10), 3.5, Color(0.15, 0.1, 0.05))

func _draw_locust_swarm() -> void:
	for i in range(_locust_angles.size()):
		var angle: float = _locust_angles[i] + _pulse_time * 1.5
		var dist: float = lerpf(_locust_start_dist[i], 14.0, _warning_progress)
		var wobble: float = sin(_pulse_time * 8.0 + float(i)) * 5.0
		var pos: Vector2 = Vector2(cos(angle), sin(angle)) * (dist + wobble)
		var tri: PackedVector2Array = PackedVector2Array([
			pos + Vector2(-4, 3),
			pos + Vector2(4, 3),
			pos + Vector2(0, -5),
		])
		draw_polygon(tri, PackedColorArray([Color(0.12, 0.1, 0.05)]))
