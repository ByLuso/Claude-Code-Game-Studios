extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Datos de design/gdd/farm-economy-system.md 3.7/4.4. Simplificado
# deliberadamente: la "canalizacion de venta" real es un gesto de mantener
# 1-2s cancelable (formula 4.4) -- este spike no modela gestos de mantener
# (misma razon que Sembradora en maquinas.gd, ver esa nota), asi que vender
# aqui es un toque simple e instantaneo en la estructura del Silo. Tambien se
# corta el tier 4+ de costo-duplicado-infinito: la propia ronda 3 del GDD lo
# recalifica como "sink de prestigio, no decision real" (paga 40x mas por la
# misma capacidad hacia el tier 6), asi que no aporta nada probar esa cola en
# un spike -- se cubre solo hasta tier 3 (capacidad completa "de decision
# real": $150 base + $600 = $750, canalizacion en su piso de 1s aunque esta
# ultima no se modele).

signal valor_cambio(nuevo_valor: int)
signal tier_comprado(tier: int)

const CAPACIDAD_BASE: int = 150
const CAPACIDAD_POR_TIER: int = 200
const COSTES_TIER: Array[int] = [80, 200, 400]
const UMBRAL_DESBLOQUEO_VENTAS: int = 500

var valor_actual: int = 0
var tiers_comprados: int = 0
var ventas_totales_dinero: int = 0

func capacidad() -> int:
	return CAPACIDAD_BASE + CAPACIDAD_POR_TIER * tiers_comprados

func puede_agregar(valor: int) -> bool:
	return valor_actual + valor <= capacidad()

func agregar(valor: int) -> void:
	valor_actual += valor
	valor_cambio.emit(valor_actual)

func vender_todo() -> int:
	var vendido: int = valor_actual
	valor_actual = 0
	ventas_totales_dinero += vendido
	valor_cambio.emit(valor_actual)
	return vendido

func esta_desbloqueada_compra() -> bool:
	return ventas_totales_dinero >= UMBRAL_DESBLOQUEO_VENTAS

func tier_disponible() -> bool:
	return esta_desbloqueada_compra() and tiers_comprados < COSTES_TIER.size()

func siguiente_coste_tier() -> int:
	return COSTES_TIER[tiers_comprados]

func comprar_tier() -> bool:
	if not tier_disponible():
		return false
	if not Economia.gastar(siguiente_coste_tier()):
		return false
	tiers_comprados += 1
	tier_comprado.emit(tiers_comprados)
	return true
