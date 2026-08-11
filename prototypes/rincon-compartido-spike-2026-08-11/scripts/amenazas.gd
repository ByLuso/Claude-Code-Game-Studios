extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the full loop (crop + shared economy + Amenazas as designed
# through /design-review round 5) feel coherent when played end to end?
# Date: 2026-08-11
#
# Simplified single-player, single-severity version of design/gdd/amenazas.md
# Core Rules 1-2, 6, 10. Cut for this spike: Severo/Reducido split (no Refugio
# structure exists here), Core Rule 7b (needs 2 real players), network
# authority (single local process has no network layer to test).

var _hay_amenaza_activa: bool = false
var _temporizador: float = 0.0
var _pausado: bool = false

func _ready() -> void:
	_resortear_intervalo()

var _t_prev_pressed: bool = false

func _process(delta: float) -> void:
	var t_pressed := Input.is_physical_key_pressed(KEY_T)
	var t_just_pressed := t_pressed and not _t_prev_pressed
	_t_prev_pressed = t_pressed

	if _hay_amenaza_activa:
		return  # Core Rule 2: un solo hilo de amenaza activo, secuenciacion.

	var elegibles := _parcelas_elegibles()
	if elegibles.is_empty():
		_pausado = true  # Core Rule 10: el temporizador se pausa, no se resortea.
		return
	if _pausado:
		_pausado = false  # Se reanuda exactamente donde quedo.

	_temporizador -= delta
	# Tecla de debug (T): fuerza un disparo inmediato para poder probar el
	# spike sin esperar el intervalo real de 25-90s.
	if _temporizador <= 0.0 or t_just_pressed:
		_disparar(elegibles)

func _parcelas_elegibles() -> Array:
	var todas := get_tree().get_nodes_in_group("parcelas")
	return todas.filter(func(p): return p.esta_elegible_para_amenaza())

func _disparar(elegibles: Array) -> void:
	var objetivo = elegibles[randi() % elegibles.size()]
	objetivo.iniciar_pre_alerta()
	objetivo.estado_cambio.connect(_on_objetivo_resuelto.bind(objetivo), CONNECT_ONE_SHOT)
	_hay_amenaza_activa = true

func _on_objetivo_resuelto(objetivo: Node) -> void:
	# Cualquier salida de Amenaza activa (Prevenida, Danada, o Reparando ya
	# en curso) cuenta como "resuelta" a efectos de secuenciacion.
	if objetivo.estado == objetivo.Estado.PRE_ALERTA or objetivo.estado == objetivo.Estado.AMENAZA_ACTIVA:
		# Aun no resuelta (ej. paso de pre-alerta a activa) -- re-conectar.
		objetivo.estado_cambio.connect(_on_objetivo_resuelto.bind(objetivo), CONNECT_ONE_SHOT)
		return
	_hay_amenaza_activa = false
	_resortear_intervalo()

func _resortear_intervalo() -> void:
	var n: int = _parcelas_elegibles().size()
	var intervalo_min: float = minf(25.0 + 3.0 * n, 70.0)
	var intervalo_max: float = minf(45.0 + 3.0 * n, 90.0)
	_temporizador = randf_range(intervalo_min, intervalo_max)
