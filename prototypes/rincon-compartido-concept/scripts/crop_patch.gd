extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

enum GrowthState { EMPTY, GROWING, READY }

@export var grow_time: float = 6.0
@export var harvest_yield: int = 3

var growth_state: GrowthState = GrowthState.EMPTY
var growth_progress: float = 0.0
var blighted: bool = false
var warning_active: bool = false
var _pulse_time: float = 0.0

func _ready() -> void:
	ThreatManager.register_crop_patch(self)
	ThreatManager.state_changed.connect(_on_threat_state_changed)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()

func _on_threat_state_changed(state_name: String) -> void:
	warning_active = (state_name == "WARNING")
	queue_redraw()

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
	if blighted:
		draw_rect(base_rect, Color(0.55, 0.4, 0.15))
		draw_string(ThemeDB.fallback_font, Vector2(-38, -48), "PLAGA - replanta")
	else:
		draw_rect(base_rect, Color(0.36, 0.26, 0.16))
		match growth_state:
			GrowthState.EMPTY:
				draw_string(ThemeDB.fallback_font, Vector2(-40, -48), "Tierra vacía (acción = plantar)")
			GrowthState.GROWING:
				var size := lerp(10.0, 70.0, growth_progress)
				var half := size / 2.0
				var green := Color(0.4, 0.75, 0.2).lerp(Color(0.9, 0.8, 0.1), growth_progress * 0.3)
				draw_rect(Rect2(-half, -half, size, size), green)
				draw_string(ThemeDB.fallback_font, Vector2(-38, -48), "Creciendo %d%%" % int(growth_progress * 100))
			GrowthState.READY:
				draw_rect(Rect2(-35, -35, 70, 70), Color(0.95, 0.85, 0.15))
				draw_string(ThemeDB.fallback_font, Vector2(-38, -48), "¡LISTO! (acción = cosechar)")

	if warning_active:
		var pulse := 0.5 + 0.5 * sin(_pulse_time * 6.0)
		var warn_color := Color(1.0, 0.15, 0.15, 0.5 + 0.5 * pulse)
		draw_rect(Rect2(-48, -48, 96, 96), warn_color, false, 4.0)
		draw_string(ThemeDB.fallback_font, Vector2(-10, -60), "⚠")
