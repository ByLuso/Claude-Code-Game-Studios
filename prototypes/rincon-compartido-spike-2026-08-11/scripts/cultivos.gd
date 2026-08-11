extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Datos de los 3 cultivos, tomados de design/gdd/farm-economy-system.md 3.2 y
# design/registry/entities.yaml. Umbrales de desbloqueo ESCALADOS ABAJO del
# valor real (100 unidades de trigo tardaria demasiado en un spike corto) --
# se nota explicitamente aqui, no es un valor de diseno real.

const DATA := {
	"Trigo": {
		"seed_cost": 2, "grow_time": 6.0, "units": 3, "price": 5,
		"reaction_window": 6.0, "unlock_at": 0,
		"color": Color(0.65, 0.5, 0.25),
	},
	"Maíz": {
		"seed_cost": 5, "grow_time": 12.0, "units": 5, "price": 8,
		"reaction_window": 6.0, "unlock_at": 15,  # real: 100 unidades de trigo
		"color": Color(0.95, 0.65, 0.15),
	},
	"Fresa": {
		"seed_cost": 8, "grow_time": 4.0, "units": 2, "price": 12,
		"reaction_window": 4.0, "unlock_at": 30,  # real: comprar la 4a parcela
		"color": Color(0.85, 0.2, 0.2),
	},
}

const ORDEN := ["Trigo", "Maíz", "Fresa"]

var unidades_vendidas_total: int = 0
var cultivo_seleccionado: String = "Trigo"
var fresa_en_vuelo: bool = false

func esta_desbloqueado(nombre: String) -> bool:
	return unidades_vendidas_total >= DATA[nombre]["unlock_at"]

func registrar_venta(unidades: int) -> void:
	unidades_vendidas_total += unidades

func ciclar_seleccion() -> void:
	var idx := ORDEN.find(cultivo_seleccionado)
	for i in range(1, ORDEN.size() + 1):
		var candidato: String = ORDEN[(idx + i) % ORDEN.size()]
		if esta_desbloqueado(candidato):
			cultivo_seleccionado = candidato
			return
