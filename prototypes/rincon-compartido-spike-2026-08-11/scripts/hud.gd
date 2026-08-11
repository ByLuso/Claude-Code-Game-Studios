extends CanvasLayer
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11

@onready var dinero_label: Label = $Dinero
@onready var ayuda_label: Label = $Ayuda

func _ready() -> void:
	Economia.dinero_cambio.connect(_on_dinero_cambio)
	_on_dinero_cambio(Economia.dinero)
	ayuda_label.text = "WASD/flechas mover, ESPACIO accion contextual. T = forzar amenaza (debug)."

func _on_dinero_cambio(nuevo_monto: int) -> void:
	dinero_label.text = "Pozo compartido: $%d" % nuevo_monto
