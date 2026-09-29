extends Node

signal money_changed(value: int)

var money := 30
var day_start_money := 30

func start_day() -> void:
	day_start_money = money

func get_day_earnings() -> int:
	return money - day_start_money

func make_money(value_money: int) -> void:
	money += value_money
	money_changed.emit(money)

func miss_money(value_money: int) -> void:
	money -= value_money
	money_changed.emit(money)

func load_from_save() -> void:
	money = int(SaveManager.data.get("money", 30))
	day_start_money = money
	money_changed.emit(money)
