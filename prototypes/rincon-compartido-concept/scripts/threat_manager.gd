extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

signal state_changed(state_name: String)
signal warning_time_left(seconds: float)

enum State { IDLE, WARNING, ACTIVE }

const IDLE_DURATION: float = 20.0
const WARNING_DURATION: float = 10.0
const ACTIVE_DURATION: float = 25.0

const PROTECTION_COST: int = 15
const REPAIR_COST: int = 10

var state: State = State.IDLE
var _timer: float = IDLE_DURATION
var _crop_patch: Node = null

func register_crop_patch(patch: Node) -> void:
	_crop_patch = patch

func _process(delta: float) -> void:
	_timer -= delta
	match state:
		State.IDLE:
			if _timer <= 0.0:
				_enter_warning()
		State.WARNING:
			warning_time_left.emit(_timer)
			if _timer <= 0.0:
				_enter_active()
		State.ACTIVE:
			if _timer <= 0.0:
				_resolve_and_reset()

func try_protect(player_id: int) -> bool:
	if state != State.WARNING:
		return false
	if Economy.spend(PROTECTION_COST, player_id):
		_resolve_and_reset()
		return true
	return false

func try_repair(player_id: int) -> bool:
	if state != State.ACTIVE:
		return false
	if Economy.spend(REPAIR_COST, player_id):
		_resolve_and_reset()
		return true
	return false

func _enter_warning() -> void:
	state = State.WARNING
	_timer = WARNING_DURATION
	state_changed.emit("WARNING")

func _enter_active() -> void:
	state = State.ACTIVE
	_timer = ACTIVE_DURATION
	state_changed.emit("ACTIVE")
	if _crop_patch:
		_crop_patch.set_blighted(true)

func _resolve_and_reset() -> void:
	state = State.IDLE
	_timer = IDLE_DURATION
	state_changed.emit("IDLE")
	if _crop_patch:
		_crop_patch.set_blighted(false)
