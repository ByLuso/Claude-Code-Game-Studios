extends CanvasLayer
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11

@onready var dinero_label: Label = $Dinero
@onready var ayuda_label: Label = $Ayuda
@onready var cultivo_label: Label = $Cultivo

func _ready() -> void:
	Economia.dinero_cambio.connect(_on_dinero_cambio)
	_on_dinero_cambio(Economia.dinero)
	ayuda_label.text = "J1: WASD mover, E accion.  J2: flechas mover, ENTER accion.  C = ciclar cultivo (compartido).  T = forzar amenaza (debug). El anillo verde es el Refugio (protege Parcela1). El Taller (gris, abajo) vende Sembradora y Cosechadora."

func _process(_delta: float) -> void:
	var seleccionado: String = Cultivos.cultivo_seleccionado
	var estados: PackedStringArray = []
	for nombre in Cultivos.ORDEN:
		if Cultivos.esta_desbloqueado(nombre):
			estados.append(nombre if nombre != seleccionado else "[%s]" % nombre)
		else:
			var faltan: int = Cultivos.DATA[nombre]["unlock_at"] - Cultivos.unidades_vendidas_total
			estados.append("%s (bloqueado, faltan %d unidades)" % [nombre, faltan])
	var maquinas_txt: String = "Sembradora: %s | Cosechadora: %s" % [
		"comprada" if Maquinas.tiene_sembradora else "no comprada",
		"comprada" if Maquinas.tiene_cosechadora else "no comprada",
	]
	cultivo_label.text = "Cultivo seleccionado: " + " | ".join(estados) + "   —   " + maquinas_txt

func _on_dinero_cambio(nuevo_monto: int) -> void:
	dinero_label.text = "Pozo compartido: $%d" % nuevo_monto
