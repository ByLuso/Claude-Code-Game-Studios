extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Updated: severidad Severo/Reducido anadida (Core Rule 6), ahora que el
# Refugio existe en la escena -- la primera version del spike solo tenia un
# nivel de dano porque no habia estructura de proteccion que probar.

signal estado_cambio
signal severidad_pendiente_cambio(severidad: String)

enum Estado { VACIA, CRECIENDO, LISTA, PRE_ALERTA, AMENAZA_ACTIVA, DANADA, REPARANDO }

const GROW_TIME: float = 6.0
const SEED_COST: int = 2
const HARVEST_UNITS: int = 3
const SELL_PRICE_PER_UNIT: int = 5

const PRE_ALERT_DURATION: float = 0.5
const REACTION_WINDOW: float = 6.0
const PREVENT_COST: int = 15
const REPAIR_COST: int = 10
const REPAIR_DOWNTIME_SEVERO: float = 4.0
const REPAIR_DOWNTIME_REDUCIDO: float = 2.0

var estado: Estado = Estado.VACIA
var severidad_actual: String = "Severo"
var _progreso: float = 0.0
var _timer: float = 0.0
var _pulse_time: float = 0.0

func _ready() -> void:
	add_to_group("parcelas")
	queue_redraw()

func esta_elegible_para_amenaza() -> bool:
	return estado == Estado.CRECIENDO or estado == Estado.LISTA

func iniciar_pre_alerta() -> void:
	if not esta_elegible_para_amenaza():
		return
	estado = Estado.PRE_ALERTA
	_timer = PRE_ALERT_DURATION
	estado_cambio.emit()
	queue_redraw()

func accion_disponible() -> String:
	match estado:
		Estado.VACIA:
			return "Plantar ($%d)" % SEED_COST
		Estado.LISTA:
			return "Cosechar (+$%d)" % (HARVEST_UNITS * SELL_PRICE_PER_UNIT)
		Estado.AMENAZA_ACTIVA:
			return "Prevenir ($%d)" % PREVENT_COST
		Estado.DANADA:
			return "Reparar ($%d)" % REPAIR_COST
		_:
			return ""

func ejecutar_accion() -> bool:
	match estado:
		Estado.VACIA:
			if not Economia.gastar(SEED_COST):
				return false
			estado = Estado.CRECIENDO
			_progreso = 0.0
			estado_cambio.emit()
			queue_redraw()
			return true
		Estado.LISTA:
			Economia.ganar(HARVEST_UNITS * SELL_PRICE_PER_UNIT)
			estado = Estado.VACIA
			estado_cambio.emit()
			queue_redraw()
			return true
		Estado.AMENAZA_ACTIVA:
			if not Economia.gastar(PREVENT_COST):
				return false
			# Prevenir: instantaneo, sin dano, vuelve al estado previo a la amenaza.
			estado = Estado.LISTA if _progreso >= 1.0 else Estado.CRECIENDO
			estado_cambio.emit()
			queue_redraw()
			return true
		Estado.DANADA:
			if not Economia.gastar(REPAIR_COST):
				return false
			estado = Estado.REPARANDO
			_timer = REPAIR_DOWNTIME_SEVERO if severidad_actual == "Severo" else REPAIR_DOWNTIME_REDUCIDO
			estado_cambio.emit()
			queue_redraw()
			return true
		_:
			return false

func _esta_protegida() -> bool:
	for refugio in get_tree().get_nodes_in_group("refugio"):
		if refugio.protege(global_position):
			return true
	return false

func _process(delta: float) -> void:
	_pulse_time += delta
	match estado:
		Estado.CRECIENDO:
			_progreso += delta / GROW_TIME
			if _progreso >= 1.0:
				_progreso = 1.0
				estado = Estado.LISTA
				estado_cambio.emit()
		Estado.PRE_ALERTA:
			_timer -= delta
			if _timer <= 0.0:
				estado = Estado.AMENAZA_ACTIVA
				_timer = REACTION_WINDOW
				severidad_actual = "Reducido" if _esta_protegida() else "Severo"
				estado_cambio.emit()
		Estado.AMENAZA_ACTIVA:
			_timer -= delta
			# Core Rule 6: la severidad pendiente se evalua en tiempo real, no
			# solo al momento del disparo -- el jugador puede ver el preview
			# cambiar si entra/sale de rango del Refugio durante la ventana.
			var nueva_severidad: String = "Reducido" if _esta_protegida() else "Severo"
			if nueva_severidad != severidad_actual:
				severidad_actual = nueva_severidad
				severidad_pendiente_cambio.emit(severidad_actual)
			if _timer <= 0.0:
				# Core Rule 6: sin prevencion, pasa a estado de dano.
				estado = Estado.DANADA
				estado_cambio.emit()
		Estado.REPARANDO:
			_timer -= delta
			if _timer <= 0.0:
				estado = Estado.VACIA
				estado_cambio.emit()
	queue_redraw()

func _draw() -> void:
	var base_rect := Rect2(-40, -40, 80, 80)

	match estado:
		Estado.VACIA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Tierra vacía")
		Estado.CRECIENDO:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(_progreso, false)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Creciendo %d%%" % int(_progreso * 100))
		Estado.LISTA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0, true)
			var pulso: float = 0.5 + 0.5 * sin(_pulse_time * 4.0)
			draw_rect(base_rect, Color(1.0, 0.85, 0.2, pulso * 0.25), false, 3.0)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "¡Listo!")
		Estado.PRE_ALERTA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0 if _progreso >= 1.0 else _progreso, _progreso >= 1.0)
			# Art bible: pre-alerta = parpadeo azul-blanco + contorno engrosado.
			var parpadeo: float = 0.5 + 0.5 * sin(_pulse_time * 30.0)
			draw_rect(base_rect, Color(0.6, 0.8, 1.0, parpadeo), false, 6.0)
		Estado.AMENAZA_ACTIVA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0 if _progreso >= 1.0 else _progreso, _progreso >= 1.0)
			_draw_enjambre()
			var restante: float = maxf(_timer, 0.0)
			var color_preview: Color = Color(0.6, 0.85, 0.75) if severidad_actual == "Reducido" else Color(1.0, 0.6, 0.1)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "¡AMENAZA! %.1fs (%s)" % [restante, severidad_actual])
			var frac: float = restante / REACTION_WINDOW
			draw_rect(Rect2(-40, 48, 80.0 * frac, 6), color_preview)
		Estado.DANADA:
			draw_rect(base_rect, Color(0.3, 0.28, 0.25))
			_draw_planta_danada()
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Dañada (%s)" % severidad_actual)
		Estado.REPARANDO:
			draw_rect(base_rect, Color(0.3, 0.28, 0.25))
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Reparando %.1fs" % maxf(_timer, 0.0))
			draw_circle(Vector2(0, 0), 10.0, Color(0.6, 0.85, 0.75, 0.6 + 0.2 * sin(_pulse_time * 3.0)))

func _draw_planta(progreso: float, listo: bool) -> void:
	var altura: float = lerpf(4.0, 46.0, progreso)
	var color_tallo := Color(0.3, 0.55, 0.15)
	draw_line(Vector2(0, 20), Vector2(0, 20 - altura), color_tallo, 4.0)
	var color_flor: Color = Color(0.98, 0.85, 0.15) if listo else Color(0.5, 0.8, 0.2)
	var radio_flor: float = lerpf(3.0, 12.0, progreso)
	draw_circle(Vector2(0, 20 - altura), radio_flor, color_flor)

func _draw_planta_danada() -> void:
	var color_marchito := Color(0.35, 0.28, 0.15)
	draw_line(Vector2(-10, 25), Vector2(8, -5), color_marchito, 4.0)
	draw_line(Vector2(8, -5), Vector2(-4, -20), color_marchito, 3.0)

func _draw_enjambre() -> void:
	# Art bible: gota/diamante suave, nube dispersa y arremolinada (no triangulos).
	for i in range(6):
		var angulo: float = (float(i) / 6.0) * TAU + _pulse_time * 1.2
		var dist: float = 20.0 + sin(_pulse_time * 3.0 + float(i)) * 6.0
		var pos: Vector2 = Vector2(cos(angulo), sin(angulo)) * dist
		draw_circle(pos, 4.0, Color(0.12, 0.11, 0.13, 0.85))
