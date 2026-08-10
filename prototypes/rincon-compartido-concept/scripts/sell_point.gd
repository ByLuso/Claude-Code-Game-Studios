extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.has_method("set_can_sell"):
		body.set_can_sell(true)

func _on_body_exited(body: Node) -> void:
	if body.has_method("set_can_sell"):
		body.set_can_sell(false)

func _draw() -> void:
	draw_rect(Rect2(-40, -40, 80, 80), Color(0.2, 0.4, 0.8, 0.7))
	draw_string(ThemeDB.fallback_font, Vector2(-38, -48), "Punto de Venta")
