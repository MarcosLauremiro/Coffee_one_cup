class_name ManagerMoney
extends Node

@export var money := 0

func make_money(value_money) -> void:
	money += value_money
	
func miss_money(value_money) -> void:
	money -= value_money
