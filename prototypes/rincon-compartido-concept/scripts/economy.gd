extends Node
# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is a shared economy + threat-response loop engaging for 2 co-op players?
# Date: 2026-08-10

signal money_changed(new_amount: int)
signal silo_changed(new_amount: int)

var money: int = 20
var silo: int = 0

const SELL_PRICE_PER_UNIT: int = 5

func add_to_silo(amount: int) -> void:
	silo += amount
	silo_changed.emit(silo)

func sell_silo() -> int:
	if silo <= 0:
		return 0
	var earned := silo * SELL_PRICE_PER_UNIT
	money += earned
	silo = 0
	money_changed.emit(money)
	silo_changed.emit(silo)
	return earned

func spend(amount: int) -> bool:
	if money < amount:
		return false
	money -= amount
	money_changed.emit(money)
	return true
