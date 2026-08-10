extends CanvasLayer
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

@onready var money_label: Label = $Money
@onready var silo_label: Label = $Silo
@onready var threat_label: Label = $Threat
@onready var stats_label: Label = $Stats

func _ready() -> void:
	Economy.money_changed.connect(_on_money_changed)
	Economy.silo_changed.connect(_on_silo_changed)
	Economy.contribution_changed.connect(_on_contribution_changed)
	ThreatManager.state_changed.connect(_on_state_changed)
	ThreatManager.warning_time_left.connect(_on_warning_time)
	_on_money_changed(Economy.money)
	_on_silo_changed(Economy.silo)
	_on_state_changed("IDLE")
	_on_contribution_changed()

func _on_money_changed(amount: int) -> void:
	money_label.text = "Dinero compartido: $%d" % amount

func _on_silo_changed(amount: int) -> void:
	silo_label.text = "Silo (sin vender): %d unidades" % amount

func _on_contribution_changed() -> void:
	var h1: int = Economy.harvested_by_player.get(1, 0)
	var h2: int = Economy.harvested_by_player.get(2, 0)
	var s1: int = Economy.spent_by_player.get(1, 0)
	var s2: int = Economy.spent_by_player.get(2, 0)
	stats_label.text = "J1: %d cosechados, $%d gastados   |   J2: %d cosechados, $%d gastados" % [h1, s1, h2, s2]

func _on_state_changed(state_name: String) -> void:
	match state_name:
		"IDLE":
			threat_label.text = "Todo tranquilo."
		"WARNING":
			threat_label.text = "¡ALERTA! Plaga en camino — ve al cultivo y pulsa tu tecla de acción para prevenir ($15)."
		_:
			threat_label.text = "¡PLAGA ACTIVA! Cultivo no produce — ve al cultivo y pulsa tu tecla de acción para reparar ($10)."

func _on_warning_time(seconds: float) -> void:
	threat_label.text = "¡ALERTA! Plaga en %0.1fs — ve al cultivo y pulsa tu tecla de acción para prevenir ($15)." % seconds
