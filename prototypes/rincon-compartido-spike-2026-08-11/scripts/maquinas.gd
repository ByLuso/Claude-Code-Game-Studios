extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Datos de design/gdd/farm-economy-system.md 3.6. Sembradora simplificada
# deliberadamente: el spike no modela el gesto de mantener-para-plantar (esta
# marcado Provisional/posiblemente roto en el GDD real, pendiente del spike
# de UX tactil) asi que "reduce 0.4s a 0.15s" no tiene equivalente aqui. En
# su lugar, Sembradora auto-replanta el mismo cultivo apenas una parcela
# vuelve a Vacia -- mismo espiritu (reduce friccion de plantar), mecanismo
# distinto, documentado como divergencia, no como el mismo efecto.

signal maquina_comprada(nombre: String)

var tiene_sembradora: bool = false
var tiene_cosechadora: bool = false

const COSTE_SEMBRADORA: int = 200
const COSTE_COSECHADORA: int = 350
const RETRASO_COSECHADORA_FRACCION: float = 0.25
