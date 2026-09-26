extends Node

var money := 2000

func make_money(value_money) -> void:
	money += value_money
	
func miss_money(value_money) -> void:
	money -= value_money
