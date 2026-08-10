extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

@export var max_yield: int = 5
@export var regrow_time: float = 3.0

var current_yield: int = 5
var blighted: bool = false
var _regrow_timer: float = 0.0

func _ready() -> void:
	ThreatManager.register_crop_patch(self)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()

func _on_body_entered(body: Node) -> void:
	if body.has_method("set_can_harvest"):
		body.set_can_harvest(true, self)

func _on_body_exited(body: Node) -> void:
	if body.has_method("set_can_harvest"):
		body.set_can_harvest(false, null)

func set_blighted(value: bool) -> void:
	blighted = value
	if blighted:
		current_yield = 0
	queue_redraw()

func harvest() -> int:
	if current_yield <= 0 or blighted:
		return 0
	current_yield -= 1
	queue_redraw()
	return 1

func _process(delta: float) -> void:
	if blighted:
		return
	if current_yield < max_yield:
		_regrow_timer += delta
		if _regrow_timer >= regrow_time:
			_regrow_timer = 0.0
			current_yield += 1
			queue_redraw()

func _draw() -> void:
	var base_color := Color(0.2, 0.7, 0.2) if not blighted else Color(0.55, 0.4, 0.15)
	var fullness := float(current_yield) / float(max_yield)
	var shade := base_color * (0.4 + 0.6 * fullness) if not blighted else base_color
	draw_rect(Rect2(-40, -40, 80, 80), shade)
	var label := "PLAGA" if blighted else "Cultivo %d/%d" % [current_yield, max_yield]
	draw_string(ThemeDB.fallback_font, Vector2(-38, -48), label)
