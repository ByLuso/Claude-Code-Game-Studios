extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11

signal dinero_cambio(nuevo_monto: int)

var dinero: int = 20

func puede_pagar(monto: int) -> bool:
	return dinero >= monto

func gastar(monto: int) -> bool:
	if dinero < monto:
		return false
	dinero -= monto
	dinero_cambio.emit(dinero)
	return true

func ganar(monto: int) -> void:
	dinero += monto
	dinero_cambio.emit(dinero)
