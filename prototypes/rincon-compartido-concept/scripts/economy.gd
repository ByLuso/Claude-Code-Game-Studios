extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

signal money_changed(new_amount: int)
signal silo_changed(new_amount: int)
signal contribution_changed

var money: int = 20
var silo: int = 0

var harvested_by_player: Dictionary = {1: 0, 2: 0}
var spent_by_player: Dictionary = {1: 0, 2: 0}

const SELL_PRICE_PER_UNIT: int = 5

func add_to_silo(amount: int, player_id: int) -> void:
	silo += amount
	if harvested_by_player.has(player_id):
		harvested_by_player[player_id] += amount
	silo_changed.emit(silo)
	contribution_changed.emit()

func sell_silo() -> int:
	if silo <= 0:
		return 0
	var earned := silo * SELL_PRICE_PER_UNIT
	money += earned
	silo = 0
	money_changed.emit(money)
	silo_changed.emit(silo)
	return earned

func spend(amount: int, player_id: int) -> bool:
	if money < amount:
		return false
	money -= amount
	if spent_by_player.has(player_id):
		spent_by_player[player_id] += amount
	money_changed.emit(money)
	contribution_changed.emit()
	return true
