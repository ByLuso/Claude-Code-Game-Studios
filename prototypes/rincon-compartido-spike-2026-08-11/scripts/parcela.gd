extends Area2D
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Updated: estado Bloqueada + expansion de terreno (design/gdd/farm-economy-
# system.md 3.3, 4.2); efecto de Cosechadora (cadena de auto-cosecha en
# vecinos Chebyshev-1, 3.6) y de Sembradora (auto-replante, ver maquinas.gd
# para la nota de por que diverge del mecanismo real).

signal estado_cambio
signal severidad_pendiente_cambio(severidad: String)

enum Estado { BLOQUEADA, VACIA, CRECIENDO, LISTA, PRE_ALERTA, AMENAZA_ACTIVA, DANADA, REPARANDO }

const PRE_ALERT_DURATION: float = 0.5
const PREVENT_COST: int = 15
const REPAIR_COST: int = 10
const REPAIR_DOWNTIME_SEVERO: float = 4.0
const REPAIR_DOWNTIME_REDUCIDO: float = 2.0

@export var estado_inicial: Estado = Estado.VACIA
@export var coste_desbloqueo: int = 0
@export var col: int = 0
@export var fila: int = 0

var estado: Estado = Estado.VACIA
var severidad_actual: String = "Severo"
var tipo_cultivo: String = "Trigo"
var _progreso: float = 0.0
var _timer: float = 0.0
var _pulse_time: float = 0.0
var _reaction_window: float = 6.0
var _auto_harvest_pendiente: float = -1.0

func _ready() -> void:
	estado = estado_inicial
	add_to_group("parcelas")
	add_to_group("interactuables")
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
		Estado.BLOQUEADA:
			return "Comprar terreno ($%d)" % coste_desbloqueo
		Estado.VACIA:
			var cultivo: String = Cultivos.cultivo_seleccionado
			if cultivo == "Fresa" and Cultivos.fresa_en_vuelo:
				return ""  # tope de concurrencia: max 1 Fresa en vuelo en la granja
			var datos: Dictionary = Cultivos.DATA[cultivo]
			return "Plantar %s ($%d)" % [cultivo, datos["seed_cost"]]
		Estado.LISTA:
			var datos: Dictionary = Cultivos.DATA[tipo_cultivo]
			return "Cosechar (+$%d)" % (int(datos["units"]) * int(datos["price"]))
		Estado.AMENAZA_ACTIVA:
			return "Prevenir ($%d)" % PREVENT_COST
		Estado.DANADA:
			return "Reparar ($%d)" % REPAIR_COST
		_:
			return ""

func ejecutar_accion() -> bool:
	match estado:
		Estado.BLOQUEADA:
			if not Economia.gastar(coste_desbloqueo):
				return false
			estado = Estado.VACIA
			estado_cambio.emit()
			queue_redraw()
			return true
		Estado.VACIA:
			return _plantar(Cultivos.cultivo_seleccionado)
		Estado.LISTA:
			var datos: Dictionary = Cultivos.DATA[tipo_cultivo]
			var unidades: int = datos["units"]
			Economia.ganar(unidades * int(datos["price"]))
			Cultivos.registrar_venta(unidades)
			if tipo_cultivo == "Fresa":
				Cultivos.fresa_en_vuelo = false
			_entrar_vacia()
			if Maquinas.tiene_cosechadora:
				_disparar_cadena_cosechadora()
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
			if tipo_cultivo == "Fresa":
				Cultivos.fresa_en_vuelo = false
			estado = Estado.REPARANDO
			_timer = REPAIR_DOWNTIME_SEVERO if severidad_actual == "Severo" else REPAIR_DOWNTIME_REDUCIDO
			estado_cambio.emit()
			queue_redraw()
			return true
		_:
			return false

func _plantar(cultivo: String) -> bool:
	if cultivo == "Fresa" and Cultivos.fresa_en_vuelo:
		return false
	var datos: Dictionary = Cultivos.DATA[cultivo]
	if not Economia.gastar(datos["seed_cost"]):
		return false
	tipo_cultivo = cultivo
	_reaction_window = datos["reaction_window"]
	if cultivo == "Fresa":
		Cultivos.fresa_en_vuelo = true
	estado = Estado.CRECIENDO
	_progreso = 0.0
	estado_cambio.emit()
	queue_redraw()
	return true

func _entrar_vacia() -> void:
	estado = Estado.VACIA
	estado_cambio.emit()
	queue_redraw()
	# Sembradora (simplificada, ver maquinas.gd): auto-replanta el cultivo
	# seleccionado apenas la parcela queda libre, si hay saldo. Sin
	# penalizacion si no alcanza -- simplemente se queda Vacia.
	if Maquinas.tiene_sembradora:
		_plantar(Cultivos.cultivo_seleccionado)

func _disparar_cadena_cosechadora() -> void:
	for otra in get_tree().get_nodes_in_group("parcelas"):
		if otra == self or otra.estado != Estado.LISTA:
			continue
		if otra.tipo_cultivo == "Fresa":
			continue  # Cosechadora nunca cosecha Fresa (manual-only)
		if absi(otra.col - col) <= 1 and absi(otra.fila - fila) <= 1:
			var retraso: float = Cultivos.DATA[otra.tipo_cultivo]["grow_time"] * Maquinas.RETRASO_COSECHADORA_FRACCION
			otra.disparar_auto_cosecha(retraso)

func disparar_auto_cosecha(retraso: float) -> void:
	if estado != Estado.LISTA:
		return
	_auto_harvest_pendiente = retraso

func _esta_protegida() -> bool:
	for refugio in get_tree().get_nodes_in_group("refugio"):
		if refugio.protege(global_position):
			return true
	return false

func _process(delta: float) -> void:
	_pulse_time += delta

	if _auto_harvest_pendiente >= 0.0:
		_auto_harvest_pendiente -= delta
		if _auto_harvest_pendiente <= 0.0:
			_auto_harvest_pendiente = -1.0
			if estado == Estado.LISTA:
				var datos: Dictionary = Cultivos.DATA[tipo_cultivo]
				var unidades: int = datos["units"]
				Economia.ganar(unidades * int(datos["price"]))
				Cultivos.registrar_venta(unidades)
				_entrar_vacia()
				# Auto-cosecha NO dispara otra cadena -- solo la cosecha manual dispara.

	match estado:
		Estado.CRECIENDO:
			var grow_time: float = Cultivos.DATA[tipo_cultivo]["grow_time"]
			_progreso += delta / grow_time
			if _progreso >= 1.0:
				_progreso = 1.0
				estado = Estado.LISTA
				estado_cambio.emit()
		Estado.PRE_ALERTA:
			_timer -= delta
			if _timer <= 0.0:
				estado = Estado.AMENAZA_ACTIVA
				_timer = _reaction_window
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
				_entrar_vacia()
	queue_redraw()

func _draw() -> void:
	var base_rect := Rect2(-40, -40, 80, 80)

	if estado == Estado.BLOQUEADA:
		draw_rect(base_rect, Color(0.4, 0.4, 0.42))
		for i in range(-40, 41, 16):
			draw_line(Vector2(i, -40), Vector2(i - 16, 40), Color(0.25, 0.25, 0.27), 2.0)
		draw_rect(Rect2(-10, -6, 20, 16), Color(0.15, 0.15, 0.17))
		draw_arc(Vector2(0, -8), 8.0, PI, TAU, 12, Color(0.15, 0.15, 0.17), 3.0)
		draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Comprar ($%d)" % coste_desbloqueo)
		return

	var color_cultivo: Color = Cultivos.DATA[tipo_cultivo]["color"]

	match estado:
		Estado.VACIA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Tierra vacía")
		Estado.CRECIENDO:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(_progreso, false, color_cultivo)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "%s %d%%" % [tipo_cultivo, int(_progreso * 100)])
		Estado.LISTA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0, true, color_cultivo)
			var pulso: float = 0.5 + 0.5 * sin(_pulse_time * 4.0)
			draw_rect(base_rect, Color(1.0, 0.85, 0.2, pulso * 0.25), false, 3.0)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "¡%s listo!" % tipo_cultivo)
			if _auto_harvest_pendiente >= 0.0:
				draw_string(ThemeDB.fallback_font, Vector2(-38, 55), "Cosechadora: %.1fs" % _auto_harvest_pendiente)
		Estado.PRE_ALERTA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0 if _progreso >= 1.0 else _progreso, _progreso >= 1.0, color_cultivo)
			# Art bible: pre-alerta = parpadeo azul-blanco + contorno engrosado.
			var parpadeo: float = 0.5 + 0.5 * sin(_pulse_time * 30.0)
			draw_rect(base_rect, Color(0.6, 0.8, 1.0, parpadeo), false, 6.0)
		Estado.AMENAZA_ACTIVA:
			draw_rect(base_rect, Color(0.36, 0.26, 0.16))
			_draw_planta(1.0 if _progreso >= 1.0 else _progreso, _progreso >= 1.0, color_cultivo)
			_draw_enjambre()
			var restante: float = maxf(_timer, 0.0)
			var color_preview: Color = Color(0.6, 0.85, 0.75) if severidad_actual == "Reducido" else Color(1.0, 0.6, 0.1)
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "¡AMENAZA! %.1fs (%s)" % [restante, severidad_actual])
			var frac: float = restante / _reaction_window
			draw_rect(Rect2(-40, 48, 80.0 * frac, 6), color_preview)
		Estado.DANADA:
			draw_rect(base_rect, Color(0.3, 0.28, 0.25))
			_draw_planta_danada()
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Dañada (%s)" % severidad_actual)
		Estado.REPARANDO:
			draw_rect(base_rect, Color(0.3, 0.28, 0.25))
			draw_string(ThemeDB.fallback_font, Vector2(-38, -50), "Reparando %.1fs" % maxf(_timer, 0.0))
			draw_circle(Vector2(0, 0), 10.0, Color(0.6, 0.85, 0.75, 0.6 + 0.2 * sin(_pulse_time * 3.0)))

func _draw_planta(progreso: float, listo: bool, color_base: Color) -> void:
	var altura: float = lerpf(4.0, 46.0, progreso)
	var color_tallo := Color(0.3, 0.55, 0.15)
	draw_line(Vector2(0, 20), Vector2(0, 20 - altura), color_tallo, 4.0)
	var color_flor: Color = color_base if listo else color_base.lerp(Color(0.5, 0.8, 0.2), 0.5)
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
